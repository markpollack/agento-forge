#!/usr/bin/env python3
"""Normalize AppMap's sequence export and emit a manifest without arguments or paths.

usage: recording-artifacts.py RECORDING SCOPE EXPORT OUT SCENARIO AGENT_VERSION CLI_VERSION
No message is changed. Receiver identities are local to this run. The retained
manifest is evidence about this recording, not a regenerated conformance oracle.
"""
import hashlib
import json
from pathlib import Path
import re
import sys
sys.dont_write_bytecode = True


def main(rec, scope, export, out, scenario, agent, cli):
    data = Path(rec).read_bytes()
    recording = json.loads(data)
    calls = [e for e in recording['events'] if e.get('event') == 'call']
    # Use the same complete per-thread nesting checks as the condenser.
    from importlib.util import spec_from_file_location, module_from_spec
    spec = spec_from_file_location('overview', Path(__file__).with_name('sequence-overview.py'))
    overview = module_from_spec(spec)
    spec.loader.exec_module(overview)
    overview.trees(recording, [])
    ids = [(e['thread_id'], e['id']) for e in calls]
    returned = {(e['thread_id'], e['parent_id']) for e in recording['events'] if e.get('event') == 'return'}
    manifest = {
        'kind': 'architecture/appmap-recording-manifest', 'format_version': '0.1',
        'status': 'observed execution of one scoped scenario; raw recording not committed',
        'scenario': scenario,
        'recorder': 'com.appland:appmap-agent:' + agent,
        'exporter': '@appland/appmap@' + cli,
        'scope_sha256': hashlib.sha256(Path(scope).read_bytes()).hexdigest(),
        'recording': {'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data),
                      'events': len(recording['events']), 'calls': len(calls)},
        'threads': [{'id': t, 'calls': sum(e['thread_id'] == t for e in calls)}
                    for t in sorted({e['thread_id'] for e in calls})],
        'matching_returns': sum(key in returned for key in ids),
        'limits': 'Thread-local nesting only; event ids and receiver identity do not prove cross-thread order or overlap. '
                  'Arguments, return payloads, paths and object ids are omitted. Add reviewed scenario-specific evidence '
                  'separately if a claim depends on them; do not key returns by id alone.',
    }
    lines = []
    for line in Path(export).read_text().splitlines():
        if line.startswith(('@startuml', '@enduml', '!includeurl ')):
            continue
        line = re.sub(r' <color:gray> [0-9.]* ms</color>', '', line)
        line = re.sub(r'^participant ([A-Za-z0-9_]*) as "([^"]*)"$', r'participant "\2" as \1', line)
        lines.append(line)
    dest = Path(out)
    dest.mkdir(parents=True, exist_ok=True)
    (dest/'observed-sequence.puml').write_text(
        '@startuml observed-sequence\n'
        "' GENERATED from a scoped AppMap recording; see observed-recording.json.\n"
        "' Remote theme and elapsed times removed; participant alias order normalized; no message changed.\n"
        'title Observed execution of one scoped scenario (detail)\n' + '\n'.join(lines) + '\n'
        'legend bottom left\n'
        '  One recording within the declared scope; see observed-recording.json for scenario and versions.\n'
        '  Thread blocks establish no cross-thread order. Full return payloads remain in the local recording.\n'
        'endlegend\n@enduml\n')
    (dest/'observed-recording.json').write_text(json.dumps(manifest, indent=2) + '\n')


if __name__ == '__main__':
    if len(sys.argv) != 8:
        raise SystemExit(__doc__)
    main(*sys.argv[1:])
