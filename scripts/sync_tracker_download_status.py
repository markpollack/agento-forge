#!/usr/bin/env python3
"""Sync paper-tracker download status from manifest and report unresolved IDs."""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ARXIV_ID_RE = re.compile(r"\b\d{4}\.\d{4,5}(?:v\d+)?\b")


@dataclass
class TableBlock:
    start: int
    end: int
    heading: str
    lines: list[str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Update tracker download status from manifest and report unresolved IDs."
    )
    parser.add_argument(
        "--tracker-file",
        type=Path,
        default=Path("plans/supporting_docs/paper-tracker.md"),
        help="Path to paper tracker markdown.",
    )
    parser.add_argument(
        "--manifests-dir",
        type=Path,
        default=Path("papers/manifests"),
        help="Directory containing batch manifests.",
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        help="Specific batch manifest JSON; if omitted uses latest *-batch.json.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print summary only; do not write files.",
    )
    return parser.parse_args()


def load_manifest(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def latest_batch_manifest(manifests_dir: Path) -> Path:
    candidates = sorted(manifests_dir.glob("*-batch.json"))
    if not candidates:
        raise FileNotFoundError(f"No *-batch.json manifests found in {manifests_dir}")
    return candidates[-1]


def normalize_ok(status: str | None) -> bool:
    if not status:
        return False
    return status in {"downloaded", "skipped_exists", "ok", "downloaded_single_file"}


def format_status(entry: dict[str, Any]) -> str:
    pdf = "ok" if normalize_ok(entry.get("pdf_status")) else "fail"
    meta = "ok" if normalize_ok(entry.get("metadata_status")) else "fail"
    source_status = entry.get("source_status")
    if source_status in {"unavailable"}:
        src = "n/a"
    else:
        src = "ok" if normalize_ok(source_status) else "fail"
    return f"PDF:{pdf} META:{meta} SRC:{src}"


def split_row(line: str) -> list[str]:
    return [cell.strip() for cell in line.strip().strip("|").split("|")]


def join_row(cells: list[str]) -> str:
    return "| " + " | ".join(cells) + " |"


def is_separator_row(line: str) -> bool:
    raw = line.strip()
    return bool(raw) and set(raw.replace("|", "").replace(":", "").strip()) <= {"-"}


def find_table_blocks(lines: list[str]) -> list[TableBlock]:
    blocks: list[TableBlock] = []
    heading = ""
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("#"):
            heading = line.strip()
        if line.startswith("|"):
            start = i
            block_lines: list[str] = []
            while i < len(lines) and lines[i].startswith("|"):
                block_lines.append(lines[i])
                i += 1
            blocks.append(TableBlock(start=start, end=i, heading=heading, lines=block_lines))
            continue
        i += 1
    return blocks


def update_download_tables(
    tracker_lines: list[str], status_by_id: dict[str, str]
) -> tuple[list[str], int, int]:
    updated = tracker_lines[:]
    table_updates = 0
    row_updates = 0

    for block in find_table_blocks(tracker_lines):
        if len(block.lines) < 2:
            continue
        header_cells = split_row(block.lines[0])
        if not any(c.lower() == "arxiv" for c in header_cells):
            continue

        has_status_col = any(c.lower() == "download status" for c in header_cells)
        if not has_status_col:
            header_cells.append("Download Status")
            updated[block.start] = join_row(header_cells)
            has_status_col = True
            table_updates += 1

        # separator row
        sep_line = block.lines[1]
        if is_separator_row(sep_line):
            sep_cells = split_row(sep_line)
            target_len = len(header_cells)
            if len(sep_cells) < target_len:
                sep_cells += ["-------"] * (target_len - len(sep_cells))
            elif len(sep_cells) > target_len:
                sep_cells = sep_cells[:target_len]
            updated[block.start + 1] = join_row(sep_cells)

        # data rows
        for rel_idx, row_line in enumerate(block.lines[2:], start=2):
            if not row_line.startswith("|") or is_separator_row(row_line):
                continue
            row_cells = split_row(row_line)
            paper_id_match = ARXIV_ID_RE.search(row_line)
            if not paper_id_match:
                continue
            paper_id = paper_id_match.group(0)
            status = status_by_id.get(paper_id, "PDF:na META:na SRC:na")

            target_len = len(header_cells)
            if len(row_cells) < target_len:
                row_cells += [""] * (target_len - len(row_cells))
            elif len(row_cells) > target_len:
                row_cells = row_cells[:target_len]

            row_cells[-1] = status
            updated[block.start + rel_idx] = join_row(row_cells)
            row_updates += 1

    return updated, table_updates, row_updates


def extract_unresolved_items(tracker_lines: list[str]) -> list[dict[str, str]]:
    unresolved: list[dict[str, str]] = []
    blocks = find_table_blocks(tracker_lines)
    for block in blocks:
        if len(block.lines) < 2:
            continue
        headers = split_row(block.lines[0])
        if "Paper" not in headers or "Status" not in headers:
            continue
        hmap = {name: idx for idx, name in enumerate(headers)}
        for row_line in block.lines[2:]:
            if is_separator_row(row_line):
                continue
            cells = split_row(row_line)
            if len(cells) < len(headers):
                cells += [""] * (len(headers) - len(cells))
            status = cells[hmap["Status"]].strip()
            if status not in {"Unread", "Not Found"}:
                continue
            joined = " | ".join(cells)
            if ARXIV_ID_RE.search(joined) or "arxiv.org" in joined.lower():
                continue
            unresolved.append(
                {
                    "section": block.heading,
                    "paper": cells[hmap["Paper"]].strip(),
                    "status": status,
                    "row": row_line.strip(),
                }
            )
    return unresolved


def write_unresolved_report(
    manifests_dir: Path, unresolved_items: list[dict[str, str]], manifest_path: Path
) -> Path:
    run_ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    report = {
        "run_id": run_ts,
        "mode": "unresolved-report",
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "source_manifest": str(manifest_path),
        "count": len(unresolved_items),
        "items": unresolved_items,
    }
    out = manifests_dir / f"{run_ts}-unresolved.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2), encoding="utf-8")
    return out


def main() -> int:
    args = parse_args()

    if args.manifest:
        manifest_path = args.manifest
    else:
        manifest_path = latest_batch_manifest(args.manifests_dir)

    manifest = load_manifest(manifest_path)
    entries = manifest.get("entries", [])
    status_by_id = {e.get("arxiv_id"): format_status(e) for e in entries if e.get("arxiv_id")}

    tracker_lines = args.tracker_file.read_text(encoding="utf-8").splitlines()
    updated_lines, table_updates, row_updates = update_download_tables(tracker_lines, status_by_id)
    unresolved_items = extract_unresolved_items(updated_lines)

    if args.dry_run:
        print(f"Manifest: {manifest_path}")
        print(f"Tables updated: {table_updates}")
        print(f"Rows updated: {row_updates}")
        print(f"Unresolved items: {len(unresolved_items)}")
        return 0

    args.tracker_file.write_text("\n".join(updated_lines) + "\n", encoding="utf-8")
    unresolved_path = write_unresolved_report(args.manifests_dir, unresolved_items, manifest_path)

    print(f"Manifest: {manifest_path}")
    print(f"Updated tracker: {args.tracker_file}")
    print(f"Tables updated: {table_updates}")
    print(f"Rows updated: {row_updates}")
    print(f"Unresolved report: {unresolved_path}")
    print(f"Unresolved items: {len(unresolved_items)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
