#!/usr/bin/env bash
set -euo pipefail

# One-command pipeline:
# 1) download PDFs/metadata/source
# 2) sync tracker download status + unresolved report
# 3) verify local artifacts
#
# Examples:
#   scripts/run_arxiv_batch.sh --from-tracker
#   scripts/run_arxiv_batch.sh --ids-file ids.txt
#   scripts/run_arxiv_batch.sh --id 2402.01680 --id 2308.00352

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INGEST="${ROOT_DIR}/scripts/arxiv_ingest.py"
SYNC="${ROOT_DIR}/scripts/sync_tracker_download_status.py"

if [[ ! -f "${INGEST}" ]]; then
  echo "Missing script: ${INGEST}" >&2
  exit 1
fi

if [[ ! -f "${SYNC}" ]]; then
  echo "Missing script: ${SYNC}" >&2
  exit 1
fi

if [[ "$#" -eq 0 ]]; then
  set -- --from-tracker
fi

echo "[1/3] Downloading artifacts..."
python3 "${INGEST}" --mode download "$@"

MANIFEST_PATH="$(ls -1t "${ROOT_DIR}"/papers/manifests/*-batch.json 2>/dev/null | head -n 1 || true)"
if [[ -z "${MANIFEST_PATH}" ]]; then
  echo "No batch manifest found after download step." >&2
  exit 1
fi

echo "[2/3] Syncing tracker status and unresolved report..."
python3 "${SYNC}" --manifest "${MANIFEST_PATH}"

echo "[3/3] Verifying artifacts..."
python3 "${INGEST}" --mode verify "$@"

echo "Batch pipeline complete."
