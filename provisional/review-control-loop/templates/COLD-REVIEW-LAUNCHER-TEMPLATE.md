# Cold Review Launcher Template

Use this pattern when an independent sensor runs through an agentic CLI. Instantiate one launcher in
each reviewer's persistent output directory; do not make a temporary directory the sole home of the
result.

## Choose the review profile first

| Profile | Configuration rule |
|---|---|
| `ITERATIVE` | Select a capable, responsive model at its normal or high reasoning tier. Optimize for useful correction cycles, not maximum effort. |
| `FINAL` | Select the strongest suitable independent single-reviewer configuration currently available. Use separate launchers for diverse model families or vendors when multiple sensors are warranted. |

Resolve actual CLI, model, and reasoning names when generating the launcher. Do not hardcode today's
vendor catalog into the reusable method, and do not treat a delegating multi-agent mode as a stronger
version of one cold reviewer.

For an owner-operated review, prefer the CLI's interactive mode and supply the handoff as its initial
prompt. This keeps the native progress display visible without asking the owner to reconstruct the
invocation. Enable inline display or preserved scrollback when available. Do not use print/exec mode
unless the run is intentionally unattended or its stream is captured. Some session-persistence and
configuration flags are mode-specific; validate the exact selected form from installed CLI help.

## Directory contract

```text
<persistent-review-root>/
├── canonical/
│   └── input/                    # one frozen packet shared by identity
├── <reviewer-a>/
│   ├── input -> ../canonical/input
│   └── run-review.sh
└── <reviewer-b>/
    ├── input -> ../canonical/input
    └── run-review.sh
```

Each reviewer writes only `<reviewer>/REVIEW.md`. The canonical packet contains the complete review
work order as `REVIEW-PROMPT.md` and, when byte identity is not already supplied by one immutable
repository tree, a manifest or equivalent integrity record. Make the packet read-only after it is
assembled. A symlink is only a convenient shared view; immutable source identity and filesystem
permissions provide the boundary.

## Launcher skeleton

Instantiate the placeholders, keep the handoff prompt small, and run `bash -n run-review.sh` without
launching the reviewer.

```bash
#!/usr/bin/env bash
set -euo pipefail

review_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$review_dir"

if [[ -e REVIEW.md ]]; then
  echo "Refusing to overwrite $review_dir/REVIEW.md" >&2
  exit 1
fi

verify_input() {
  (
    cd input
    sha256sum --quiet -c PACKET-MANIFEST.sha256
  )
}

verify_input

handoff='Read input/REVIEW-PROMPT.md completely, perform the independent review exactly as directed, write REVIEW.md in the current directory, and stop.'

# Default owner-operated form: one exact interactive CLI invocation with the
# handoff as its initial prompt. Pin the model, reasoning tier, configuration/
# session behavior, and permission mode; do not rely on ambient defaults or
# automatically choose maximum effort.
reviewer-cli --model <model> --reasoning <tier> <isolation-flags> "$handoff"

test -s REVIEW.md
verify_input

echo "Review complete: $review_dir/REVIEW.md"
```

If the frozen candidate is already protected and checked as one immutable Git tree, replace
`verify_input` with that single integrity preflight rather than adding prophylactic per-file hashes.
If a CLI cannot disable ambient rules, prior sessions, network, or unrelated roots, record the
exception beside the launcher and enforce the boundary externally.

## Handoff record

Before launch, record:

- absolute reviewer directory and output path;
- launcher SHA-256;
- candidate or packet identity;
- selected `ITERATIVE` or `FINAL` profile and why this sensor fits it;
- installed CLI version;
- selected model and reasoning tier;
- interactive or unattended mode, including how progress/output is preserved;
- configuration, session, permission, network, and allowed-root posture;
- successful syntax and input-integrity checks; and
- who will launch the reviewer.

After completion, retain the received `REVIEW.md` verbatim and record its digest before adjudication.
Do not edit the sensor output to normalize its verdict or findings.
