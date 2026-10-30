#!/usr/bin/env python3
"""Compile the documented proposed API and consumers; never execute the stub."""

from pathlib import Path
import re
import subprocess
import tempfile


def blocks(path):
    pairs = re.findall(
        r"<!-- compile: ([A-Za-z][A-Za-z0-9]*\.java) -->\n```java\n(.*?)\n```",
        path.read_text(),
        re.DOTALL,
    )
    result = dict(pairs)
    if len(result) != len(pairs):
        raise ValueError(f"Duplicate named Java block in {path}")
    return result


def main():
    here = Path(__file__).resolve().parent
    sources = blocks(here / "README.md")
    expected = {"ReportClient.java", "FollowUp.java", "CancelOne.java", "WaitLimit.java"}
    if sources.keys() != expected:
        raise ValueError(f"Expected {sorted(expected)}, found {sorted(sources)}")
    guide = blocks(here.parent.parent / "guides" / "consumer-first-design.md")
    if guide != {"FollowUp.java": sources["FollowUp.java"]}:
        raise ValueError("Guide example differs from the checked worked example")
    with tempfile.TemporaryDirectory(prefix="forge-consumer-syntax-") as directory:
        output = Path(directory)
        for name, source in sources.items():
            (output / name).write_text(source + "\n")
        subprocess.run(
            ["javac", "--release", "21", "-Xlint:all", "-Werror", "-d", str(output)]
            + [str(output / name) for name in sorted(sources)],
            check=True,
        )
    print("PASS: proposed API and three programs compile; guide matches. No behavior executed.")


if __name__ == "__main__":
    main()
