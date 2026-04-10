#!/usr/bin/env python3
"""Download and verify arXiv artifacts for the research corpus.

Current scope:
- Download PDF for each arXiv ID
- Download metadata from arXiv API
- Download and extract source from arXiv e-print when available
- Write metadata JSON and a batch manifest
- Idempotent by default (skip existing artifacts)
"""

from __future__ import annotations

import argparse
import gzip
import io
import json
import re
import tarfile
import time
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ARXIV_API = "https://export.arxiv.org/api/query?id_list={paper_id}"
PDF_URL = "https://arxiv.org/pdf/{paper_id}.pdf"
ABS_URL = "https://arxiv.org/abs/{paper_id}"
EPRINT_URL = "https://arxiv.org/e-print/{paper_id}"

ARXIV_ID_RE = re.compile(r"\b\d{4}\.\d{4,5}(?:v\d+)?\b")
NS = {"atom": "http://www.w3.org/2005/Atom"}


@dataclass
class FetchResult:
    ok: bool
    status_code: int | None
    body: bytes | None
    error: str | None
    content_type: str | None


class ArxivClient:
    def __init__(self, sleep_seconds: float, timeout: int, user_agent: str) -> None:
        self.sleep_seconds = sleep_seconds
        self.timeout = timeout
        self.user_agent = user_agent
        self._last_request_ts = 0.0

    def _respect_rate_limit(self) -> None:
        elapsed = time.monotonic() - self._last_request_ts
        to_sleep = self.sleep_seconds - elapsed
        if to_sleep > 0:
            time.sleep(to_sleep)

    def fetch(self, url: str, max_retries: int) -> FetchResult:
        for attempt in range(1, max_retries + 1):
            self._respect_rate_limit()
            req = urllib.request.Request(
                url,
                headers={
                    "User-Agent": self.user_agent,
                    "Accept": "*/*",
                },
            )
            try:
                with urllib.request.urlopen(req, timeout=self.timeout) as resp:
                    body = resp.read()
                    self._last_request_ts = time.monotonic()
                    return FetchResult(
                        ok=True,
                        status_code=resp.getcode(),
                        body=body,
                        error=None,
                        content_type=resp.headers.get("Content-Type"),
                    )
            except urllib.error.HTTPError as exc:
                self._last_request_ts = time.monotonic()
                should_retry = exc.code in {408, 425, 429, 500, 502, 503, 504}
                if attempt < max_retries and should_retry:
                    time.sleep(2 ** (attempt - 1))
                    continue
                return FetchResult(
                    ok=False,
                    status_code=exc.code,
                    body=None,
                    error=f"HTTP {exc.code}",
                    content_type=None,
                )
            except urllib.error.URLError as exc:
                self._last_request_ts = time.monotonic()
                if attempt < max_retries:
                    time.sleep(2 ** (attempt - 1))
                    continue
                return FetchResult(
                    ok=False,
                    status_code=None,
                    body=None,
                    error=f"Network error: {exc.reason}",
                    content_type=None,
                )
            except TimeoutError:
                self._last_request_ts = time.monotonic()
                if attempt < max_retries:
                    time.sleep(2 ** (attempt - 1))
                    continue
                return FetchResult(
                    ok=False,
                    status_code=None,
                    body=None,
                    error="Timeout",
                    content_type=None,
                )
        return FetchResult(
            ok=False,
            status_code=None,
            body=None,
            error="Unknown fetch failure",
            content_type=None,
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download or verify arXiv PDFs + metadata in this repo's papers/ layout."
    )
    parser.add_argument(
        "--mode",
        choices=["download", "verify"],
        default="download",
        help="Operation mode: download artifacts or verify existing artifacts.",
    )
    parser.add_argument("--id", action="append", default=[], help="arXiv ID (repeatable)")
    parser.add_argument("--ids-file", type=Path, help="Text file with one arXiv ID per line")
    parser.add_argument(
        "--from-tracker",
        action="store_true",
        help="Extract IDs from plans/supporting_docs/paper-tracker.md",
    )
    parser.add_argument(
        "--tracker-file",
        type=Path,
        default=Path("plans/supporting_docs/paper-tracker.md"),
        help="Tracker markdown path (used with --from-tracker)",
    )
    parser.add_argument(
        "--papers-dir",
        type=Path,
        default=Path("papers"),
        help="Base papers directory",
    )
    parser.add_argument("--sleep-seconds", type=float, default=3.0, help="Min delay per request")
    parser.add_argument("--timeout", type=int, default=60, help="HTTP timeout in seconds")
    parser.add_argument("--max-retries", type=int, default=5, help="Max retries per request")
    parser.add_argument("--force", action="store_true", help="Re-download even if files exist")
    parser.add_argument("--dry-run", action="store_true", help="Resolve IDs only, no network/files")
    return parser.parse_args()


def extract_ids_from_text(text: str) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for match in ARXIV_ID_RE.findall(text):
        if match not in seen:
            seen.add(match)
            ordered.append(match)
    return ordered


def read_ids_file(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    ids: list[str] = []
    seen: set[str] = set()
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        found = ARXIV_ID_RE.search(line)
        if not found:
            continue
        paper_id = found.group(0)
        if paper_id not in seen:
            seen.add(paper_id)
            ids.append(paper_id)
    return ids


def read_ids_from_tracker(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    marker = "## Download Links for Unread Papers"
    idx = text.find(marker)
    if idx == -1:
        return []
    tail = text[idx + len(marker) :]
    next_heading = re.search(r"\n##\s+", tail)
    section = tail[: next_heading.start()] if next_heading else tail
    return extract_ids_from_text(section)


def parse_arxiv_metadata(xml_bytes: bytes, requested_id: str) -> dict[str, Any]:
    try:
        root = ET.fromstring(xml_bytes)
    except ET.ParseError as exc:
        return {
            "arxiv_id": requested_id,
            "found": False,
            "error": f"XML parse error: {exc}",
        }

    entry = root.find("atom:entry", NS)
    if entry is None:
        return {
            "arxiv_id": requested_id,
            "found": False,
            "error": "No entry in arXiv API response",
        }

    title = (entry.findtext("atom:title", default="", namespaces=NS) or "").strip()
    summary = (entry.findtext("atom:summary", default="", namespaces=NS) or "").strip()
    published = entry.findtext("atom:published", default=None, namespaces=NS)
    updated = entry.findtext("atom:updated", default=None, namespaces=NS)
    id_url = entry.findtext("atom:id", default="", namespaces=NS)
    authors = [
        (author.findtext("atom:name", default="", namespaces=NS) or "").strip()
        for author in entry.findall("atom:author", NS)
    ]
    categories = [cat.attrib.get("term", "") for cat in entry.findall("atom:category", NS)]

    return {
        "arxiv_id": requested_id,
        "found": True,
        "entry_id_url": id_url,
        "title": title,
        "authors": [a for a in authors if a],
        "summary": summary,
        "categories": [c for c in categories if c],
        "published": published,
        "updated": updated,
        "abs_url": ABS_URL.format(paper_id=requested_id),
        "pdf_url": PDF_URL.format(paper_id=requested_id),
        "fetched_at_utc": datetime.now(timezone.utc).isoformat(),
        "source": "arXiv API",
    }


def is_probably_pdf(content: bytes) -> bool:
    return content.startswith(b"%PDF")


def ensure_dirs(papers_dir: Path) -> tuple[Path, Path, Path]:
    metadata_dir = papers_dir / "metadata"
    manifests_dir = papers_dir / "manifests"
    source_root = papers_dir / "source"
    papers_dir.mkdir(parents=True, exist_ok=True)
    metadata_dir.mkdir(parents=True, exist_ok=True)
    manifests_dir.mkdir(parents=True, exist_ok=True)
    source_root.mkdir(parents=True, exist_ok=True)
    return metadata_dir, manifests_dir, source_root


def collect_ids(args: argparse.Namespace) -> list[str]:
    ids: list[str] = []
    seen: set[str] = set()

    def _add(candidates: list[str]) -> None:
        for paper_id in candidates:
            if paper_id not in seen:
                seen.add(paper_id)
                ids.append(paper_id)

    _add([paper_id for paper_id in args.id if ARXIV_ID_RE.fullmatch(paper_id)])
    if args.ids_file:
        _add(read_ids_file(args.ids_file))
    if args.from_tracker:
        _add(read_ids_from_tracker(args.tracker_file))
    return ids


def is_within_dir(base_dir: Path, target: Path) -> bool:
    base = base_dir.resolve()
    try:
        target.resolve().relative_to(base)
        return True
    except ValueError:
        return False


def safe_extract_tar(archive_bytes: bytes, dest_dir: Path) -> tuple[bool, str | None]:
    try:
        with tarfile.open(fileobj=io.BytesIO(archive_bytes), mode="r:*") as tf:
            for member in tf.getmembers():
                member_path = dest_dir / member.name
                if not is_within_dir(dest_dir, member_path):
                    return False, f"Unsafe tar path detected: {member.name}"
            tf.extractall(dest_dir)
        return True, None
    except tarfile.ReadError as exc:
        return False, f"Tar read error: {exc}"


def try_extract_source_bytes(body: bytes, dest_dir: Path) -> tuple[str, str | None]:
    extracted, err = safe_extract_tar(body, dest_dir)
    if extracted:
        return "downloaded", None

    if body.startswith(b"\x1f\x8b"):
        try:
            decompressed = gzip.decompress(body)
        except OSError as exc:
            return "failed", f"Gzip decompress error: {exc}"

        extracted2, err2 = safe_extract_tar(decompressed, dest_dir)
        if extracted2:
            return "downloaded", None

        single_file = dest_dir / "source.tex"
        single_file.write_bytes(decompressed)
        return "downloaded_single_file", None

    single_file = dest_dir / "source.bin"
    single_file.write_bytes(body)
    return "downloaded_single_file", err


def has_any_files(path: Path) -> bool:
    return path.exists() and any(path.iterdir())


def download_source(
    client: ArxivClient,
    paper_id: str,
    source_dir: Path,
    max_retries: int,
    force: bool,
) -> tuple[str, str | None]:
    if has_any_files(source_dir) and not force:
        return "skipped_exists", None

    source_dir.mkdir(parents=True, exist_ok=True)
    result = client.fetch(EPRINT_URL.format(paper_id=paper_id), max_retries)
    if not result.ok or result.body is None:
        if result.status_code == 404:
            return "unavailable", None
        return "failed", (result.error or "Source fetch failed")

    if not result.body:
        return "failed", "Source response was empty"

    status, err = try_extract_source_bytes(result.body, source_dir)
    return status, err


def main() -> int:
    args = parse_args()
    ids = collect_ids(args)
    if not ids:
        print("No valid arXiv IDs found. Use --id, --ids-file, and/or --from-tracker.")
        return 2

    print(f"Resolved {len(ids)} arXiv IDs.")
    if args.dry_run:
        for paper_id in ids:
            print(f"- {paper_id}")
        return 0

    metadata_dir, manifests_dir, source_root = ensure_dirs(args.papers_dir)

    if args.mode == "verify":
        return run_verify(ids, args.papers_dir, metadata_dir, manifests_dir, source_root)

    client = ArxivClient(
        sleep_seconds=args.sleep_seconds,
        timeout=args.timeout,
        user_agent="agento-studio/0.1 (https://github.com/markpollack/agento-studio)",
    )

    manifest_entries: list[dict[str, Any]] = []
    stats = {"success": 0, "partial": 0, "failed": 0, "skipped": 0}

    for idx, paper_id in enumerate(ids, start=1):
        print(f"[{idx}/{len(ids)}] {paper_id}")
        pdf_path = args.papers_dir / f"{paper_id}.pdf"
        metadata_path = metadata_dir / f"{paper_id}.json"
        source_dir = source_root / paper_id
        entry: dict[str, Any] = {
            "arxiv_id": paper_id,
            "pdf_path": str(pdf_path),
            "metadata_path": str(metadata_path),
            "source_path": str(source_dir),
            "pdf_status": None,
            "metadata_status": None,
            "source_status": None,
            "errors": [],
        }

        pdf_ok = False
        meta_ok = False

        if pdf_path.exists() and pdf_path.stat().st_size > 0 and not args.force:
            entry["pdf_status"] = "skipped_exists"
            pdf_ok = True
        else:
            pdf_result = client.fetch(PDF_URL.format(paper_id=paper_id), args.max_retries)
            if pdf_result.ok and pdf_result.body and is_probably_pdf(pdf_result.body):
                pdf_path.write_bytes(pdf_result.body)
                entry["pdf_status"] = "downloaded"
                pdf_ok = True
            else:
                entry["pdf_status"] = "failed"
                msg = pdf_result.error or "Invalid PDF response"
                entry["errors"].append(f"pdf: {msg}")

        if metadata_path.exists() and metadata_path.stat().st_size > 0 and not args.force:
            entry["metadata_status"] = "skipped_exists"
            meta_ok = True
        else:
            meta_result = client.fetch(ARXIV_API.format(paper_id=paper_id), args.max_retries)
            if meta_result.ok and meta_result.body:
                metadata_obj = parse_arxiv_metadata(meta_result.body, paper_id)
                metadata_path.write_text(json.dumps(metadata_obj, indent=2), encoding="utf-8")
                if metadata_obj.get("found"):
                    entry["metadata_status"] = "downloaded"
                    meta_ok = True
                else:
                    entry["metadata_status"] = "failed"
                    entry["errors"].append(f"metadata: {metadata_obj.get('error', 'Not found')}")
            else:
                entry["metadata_status"] = "failed"
                msg = meta_result.error or "Metadata request failed"
                entry["errors"].append(f"metadata: {msg}")

        source_status, source_err = download_source(
            client=client,
            paper_id=paper_id,
            source_dir=source_dir,
            max_retries=args.max_retries,
            force=args.force,
        )
        entry["source_status"] = source_status
        if source_err:
            entry["errors"].append(f"source: {source_err}")

        source_nonfatal = source_status in {
            "downloaded",
            "downloaded_single_file",
            "skipped_exists",
            "unavailable",
        }
        all_skipped = (
            entry["pdf_status"] == "skipped_exists"
            and entry["metadata_status"] == "skipped_exists"
            and entry["source_status"] == "skipped_exists"
        )
        if all_skipped:
            stats["skipped"] += 1
        elif pdf_ok and meta_ok and source_nonfatal:
            stats["success"] += 1
        elif pdf_ok or meta_ok:
            stats["partial"] += 1
        elif source_nonfatal and (entry["pdf_status"] != "failed" or entry["metadata_status"] != "failed"):
            stats["partial"] += 1
        else:
            stats["failed"] += 1

        manifest_entries.append(entry)

    run_ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    manifest = {
        "run_id": run_ts,
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "count": len(ids),
        "stats": stats,
        "entries": manifest_entries,
    }
    manifest_path = manifests_dir / f"{run_ts}-batch.json"
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")

    print("Done.")
    print(f"Manifest: {manifest_path}")
    print(
        "Stats: "
        f"success={stats['success']} partial={stats['partial']} "
        f"failed={stats['failed']} skipped={stats['skipped']}"
    )
    return 0


def run_verify(
    ids: list[str],
    papers_dir: Path,
    metadata_dir: Path,
    manifests_dir: Path,
    source_root: Path,
) -> int:
    manifest_entries: list[dict[str, Any]] = []
    stats = {"healthy": 0, "partial": 0, "missing": 0}

    for idx, paper_id in enumerate(ids, start=1):
        print(f"[{idx}/{len(ids)}] verify {paper_id}")
        pdf_path = papers_dir / f"{paper_id}.pdf"
        metadata_path = metadata_dir / f"{paper_id}.json"
        source_dir = source_root / paper_id
        entry: dict[str, Any] = {
            "arxiv_id": paper_id,
            "pdf_path": str(pdf_path),
            "metadata_path": str(metadata_path),
            "source_path": str(source_dir),
            "pdf_status": None,
            "metadata_status": None,
            "source_status": None,
            "errors": [],
        }

        pdf_ok = False
        meta_ok = False

        if not pdf_path.exists() or pdf_path.stat().st_size == 0:
            entry["pdf_status"] = "missing"
            entry["errors"].append("pdf: missing")
        else:
            pdf_bytes = pdf_path.read_bytes()
            if is_probably_pdf(pdf_bytes):
                entry["pdf_status"] = "ok"
                pdf_ok = True
            else:
                entry["pdf_status"] = "invalid"
                entry["errors"].append("pdf: file does not start with %PDF")

        if not metadata_path.exists() or metadata_path.stat().st_size == 0:
            entry["metadata_status"] = "missing"
            entry["errors"].append("metadata: missing")
        else:
            try:
                metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
                if metadata.get("arxiv_id") != paper_id:
                    entry["metadata_status"] = "invalid"
                    entry["errors"].append("metadata: arxiv_id mismatch")
                else:
                    entry["metadata_status"] = "ok"
                    meta_ok = True
            except json.JSONDecodeError as exc:
                entry["metadata_status"] = "invalid"
                entry["errors"].append(f"metadata: invalid JSON ({exc})")

        if has_any_files(source_dir):
            entry["source_status"] = "ok"
            source_ok = True
        else:
            entry["source_status"] = "missing"
            entry["errors"].append("source: missing")
            source_ok = False

        if pdf_ok and meta_ok and source_ok:
            stats["healthy"] += 1
        elif not pdf_ok and not meta_ok and not source_ok:
            stats["missing"] += 1
        else:
            stats["partial"] += 1

        manifest_entries.append(entry)

    run_ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    manifest = {
        "run_id": run_ts,
        "mode": "verify",
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "count": len(ids),
        "stats": stats,
        "entries": manifest_entries,
    }
    manifest_path = manifests_dir / f"{run_ts}-verify.json"
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")

    print("Done.")
    print(f"Verify report: {manifest_path}")
    print(
        "Stats: "
        f"healthy={stats['healthy']} partial={stats['partial']} "
        f"missing={stats['missing']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
