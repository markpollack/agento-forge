#!/usr/bin/env python3
"""Synthetic unit inputs test the tools; these are not real recording evidence."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('overview', TOOLS/'sequence-overview.py')
overview = importlib.util.module_from_spec(spec)
spec.loader.exec_module(overview)


def call(i, cls, method, thread=1):
    return dict(id=i, event='call', defined_class=cls, method_id=method, thread_id=thread)


def ret(i, parent, thread=1):
    return dict(id=i, parent_id=parent, event='return', thread_id=thread)


class ToolTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.rec = self.root/'recording.json'
        self.view = self.root/'view.json'
        self.out = self.root/'out.puml'
        self.model = {'components': [
            {'id': 'session', 'name': 'Session admission', 'classes': ['example.app.Session']},
            {'id': 'execution', 'name': 'Execution', 'classes': ['example.app.Execution']}]}

    def render(self, events, model=None):
        self.rec.write_text(json.dumps({'events': events}))
        self.view.write_text(json.dumps(model or self.model))
        overview.main(self.rec, self.view, self.out)
        return self.out.read_text()

    def test_condenses_repetitions_retains_root_steps_and_provenance(self):
        events = [call(1, 'example.app.Session', 'submit'),
                  call(2, 'example.app.Execution', 'run'), ret(3, 2),
                  call(4, 'example.app.Execution', 'run'), ret(5, 4), ret(6, 1)]
        actual = self.render(events)
        self.assertIn('session : Session.submit', actual)
        self.assertIn('loop repeated, 2 recorded', actual)
        self.assertIn('covers recorded calls 2, 4', actual)
        self.assertEqual(actual, self.render(events))

    def test_preserves_multiple_worker_roots_and_thread_local_ids(self):
        # Repeated ids on different threads are legitimate. Shared receiver is not a time relation.
        events = []
        for thread in (1, 2, 3):
            e = call(1, 'example.app.Execution$Worker', 'run', thread)
            e['receiver'] = {'object_id': 42}
            events += [e, ret(2, 1, thread)]
        actual = self.render(events)
        self.assertEqual(actual.count('execution : Execution.Worker.run'), 3)
        self.assertEqual(actual.count('order relative to other threads not established'), 3)
        self.assertNotIn('\npar ', actual)

    def test_distinct_nested_classes_with_same_method_keep_root_steps(self):
        actual = self.render([call(1, 'example.app.Session$Owner', 'run'),
                              call(2, 'example.app.Session$Worker', 'run'), ret(3, 2), ret(4, 1)])
        self.assertIn('Session.Owner.run', actual)
        self.assertIn('Session.Worker.run', actual)

    def test_folded_calls_still_require_component_membership(self):
        with self.assertRaisesRegex(SystemExit, 'not in any component'):
            self.render([call(1, 'example.app.Session', 'submit'),
                         call(2, 'unlisted.Hidden', 'call'), ret(3, 2), ret(4, 1)])

    def test_duplicate_membership_and_aliases_fail(self):
        events = [call(1, 'example.app.Session', 'submit'), ret(2, 1)]
        model = json.loads(json.dumps(self.model))
        model['components'][1]['classes'].append('example.app.Session')
        with self.assertRaisesRegex(ValueError, 'multiple components'):
            self.render(events, model)
        model['components'][0]['id'] = 'same-id'
        model['components'][1]['id'] = 'same_id'
        model['components'][1]['classes'] = ['example.app.Execution']
        with self.assertRaisesRegex(ValueError, 'aliases collide'):
            self.render(events, model)

    def test_rejects_empty_incomplete_mismatched_and_duplicate_events(self):
        for events in ([], [call(1, 'example.app.Session', 'submit')],
                       [ret(2, 1)], [call(1, 'example.app.Session', 'submit'), ret(2, 9)],
                       [call(1, 'example.app.Session', 'submit'), ret(1, 1)]):
            with self.subTest(events=events), self.assertRaises(ValueError):
                self.render(events)

    def test_manifest_returns_are_thread_qualified_and_do_not_leak_payloads(self):
        self.render([call(1, 'example.app.Session', 'submit'),
                     call(1, 'example.app.Execution', 'run', 2), ret(2, 1, 2), ret(2, 1)])
        data = json.loads(self.rec.read_text())
        data['events'][0]['parameters'] = [{'value': 'private-argument'}]
        self.rec.write_text(json.dumps(data))
        scope, export = self.root/'scope.yml', self.root/'detail.uml'
        scope.write_text('name: synthetic-unit-input\n')
        export.write_text('@startuml\n!includeurl https://example.invalid/theme\n'
                          'participant Session as "Session"\nparticipant Execution as "Execution"\n'
                          'Session -> Execution : run <color:gray> 1.2 ms</color>\n@enduml\n')
        subprocess.run(['python3', str(TOOLS/'recording-artifacts.py'), str(self.rec), str(scope),
                        str(export), str(self.root), 'synthetic unit input', '1.30.2', '3.204.0'], check=True)
        manifest = (self.root/'observed-recording.json').read_text()
        self.assertEqual(json.loads(manifest)['matching_returns'], 2)
        self.assertNotIn('private-argument', manifest)
        normalized = (self.root/'observed-sequence.puml').read_text()
        self.assertNotIn('!includeurl', normalized)
        self.assertNotIn(' ms</color>', normalized)
        self.assertIn('participant "Session" as Session', normalized)
        self.assertIn('Session -> Execution : run', normalized)

    @unittest.skipUnless(os.environ.get('ARCHITECTURE_PLANTUML_JAR'), 'set ARCHITECTURE_PLANTUML_JAR for real render/lint checks')
    def test_real_presentation_checks_and_negative_controls(self):
        jar = os.environ['ARCHITECTURE_PLANTUML_JAR']
        out = self.root/'generated'
        out.mkdir()
        # Real entry point: syntax, both pinned lint profiles, SVG rendering.
        valid = '@startuml overview\ntitle Synthetic unit input\nparticipant "Session" as session\nparticipant "Execution" as execution\nsession -> execution : submit\n@enduml\n'
        (out/'overview.puml').write_text(self.render([call(1, 'example.app.Session', 'submit'),
                           call(2, 'example.app.Execution', 'run'), ret(3, 2), ret(4, 1)]).replace('@startuml out', '@startuml overview'))
        (out/'detail.puml').write_text(valid.replace('@startuml overview', '@startuml detail').replace('as session', 'as Session').replace('as execution', 'as Execution').replace('session -> execution', 'Session -> Execution'))
        config = self.root/'project.sh'
        import shlex
        config.write_text('PROJECT_ROOT=' + shlex.quote(str(self.root)) + '\nOUT=' + shlex.quote(str(out)) +
                          '\nPLANTUML_JAR=' + shlex.quote(jar) + '\nOVERVIEWS=(overview)\nDETAILS=(detail)\n')
        def run(*args):
            return subprocess.run(args, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        result = run('bash', str(TOOLS/'architecture-docs.sh'), str(config))
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('<svg', (out/'overview.svg').read_text())
        for name, text in {
            'unclosed': valid.replace('session -> execution', 'loop repeated\nsession -> execution'),
            'undeclared': valid.replace('session -> execution', 'session -> missing'),
        }.items():
            path = self.root/(name+'.puml')
            path.write_text(text)
            result = run('uvx', '-q', '--from', 'pumllint==0.33.0', 'pumllint', '-c',
                         str(TOOLS/'pumllint-overview.toml'), '--fail-on', 'minor', str(path))
            self.assertNotEqual(result.returncode, 0, name + ': ' + result.stdout)
            self.assertIn('SEQ004' if name == 'unclosed' else 'SEQ001', result.stdout)
        result = run('bash', str(TOOLS/'architecture-docs.sh'), str(config), '--docx')
        self.assertEqual(result.returncode, 2)


if __name__ == '__main__':
    unittest.main()
