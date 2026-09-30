import hashlib
import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from scripts import performance


ROOT = Path(__file__).resolve().parents[2]
OPERATIONS = (
    "refresh_top",
    "refresh_middle",
    "refresh_bottom",
    "cursor_top",
    "cursor_middle",
    "cursor_bottom",
    "edit_top",
    "edit_middle",
    "edit_bottom",
    "scroll_top_to_middle",
    "scroll_middle_to_bottom",
)


class CorpusTests(unittest.TestCase):
    def test_corpus_generation_is_deterministic_and_preserves_unrelated_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            corpus = Path(temporary) / "corpus"
            corpus.mkdir()
            unrelated = corpus / "keep.md"
            unrelated.write_text("do not remove\n", encoding="utf-8")

            first = performance.generate_corpus(corpus, [2])
            first_bytes = {path.name: path.read_bytes() for path in corpus.glob("*.md")}
            second = performance.generate_corpus(corpus, [2])

            self.assertEqual(first_bytes, {path.name: path.read_bytes() for path in corpus.glob("*.md")})
            self.assertEqual(unrelated.read_text(encoding="utf-8"), "do not remove\n")
            self.assertEqual({item["kind"] for item in first}, {"list", "nested_code", "code", "table", "section", "mixed"})
            self.assertEqual(first, second)
            for item in first:
                content = (corpus / item["name"]).read_bytes()
                self.assertEqual(item["bytes"], len(content))
                self.assertEqual(item["lines"], len(content.decode("utf-8").splitlines()))
                self.assertEqual(item["sha256"], hashlib.sha256(content).hexdigest())
                self.assertEqual(item["count"], item["size"])

    def test_generated_corpus_contains_expected_markdown_shapes(self):
        with tempfile.TemporaryDirectory() as temporary:
            corpus = Path(temporary)
            items = performance.generate_corpus(corpus, [3])
            by_kind = {item["kind"]: (corpus / item["name"]).read_text(encoding="utf-8") for item in items}

            self.assertIn("- Item 1", by_kind["list"])
            self.assertIn("```lua", by_kind["nested_code"])
            self.assertIn("  - Nested", by_kind["nested_code"])
            self.assertIn("```lua", by_kind["code"])
            self.assertIn("| Row 1 |", by_kind["table"])
            self.assertIn("    Indented body", by_kind["section"])
            self.assertIn("# Mixed corpus", by_kind["mixed"])

    def test_stress_fixtures_have_one_long_blank_heavy_block_and_one_long_section(self):
        with tempfile.TemporaryDirectory() as temporary:
            corpus = Path(temporary)
            performance.generate_corpus(corpus, [10])
            nested = (corpus / "nested_code-10.md").read_text(encoding="utf-8")
            section = (corpus / "section-10.md").read_text(encoding="utf-8")
            self.assertEqual(nested.count("```"), 2)
            self.assertIn("\n\n", nested.split("```lua", 1)[1].split("```", 1)[0])
            self.assertEqual(section.count("## Section"), 1)


class StatisticsTests(unittest.TestCase):
    def test_nearest_rank_percentile_uses_one_based_ceil_rank(self):
        self.assertEqual(performance.nearest_rank_percentile([9, 1, 4, 2, 3], 0.95), 9)
        self.assertEqual(performance.nearest_rank_percentile([9, 1, 4, 2, 3], 0.5), 3)

    def test_report_includes_raw_samples_and_baseline_and_previous_deltas(self):
        stages = {
            "baseline": {"stage": "baseline", "benchmarks": {"list/1": {"samples": {"refresh_top": [10, 20]}, "initial_ms": [5]}}},
            "step1": {"stage": "step1", "benchmarks": {"list/1": {"samples": {"refresh_top": [8, 12]}, "initial_ms": [4]}}},
            "step2": {"stage": "step2", "benchmarks": {"list/1": {"samples": {"refresh_top": [4, 8]}, "initial_ms": [3]}}},
        }
        report = performance.render_report({"schema_version": 1, "stages": stages})

        self.assertIn("refresh_top", report)
        self.assertIn("[8, 12]", report)
        self.assertIn("baseline", report)
        self.assertIn("previous", report)
        self.assertIn("-60.0%", report)

    def test_report_includes_viewport_marks_and_case_specific_settings(self):
        report = performance.render_report({"stages": {"baseline": {"benchmarks": {
            "section/1": {
                "input": {"lines": 3, "bytes": 30, "sha256": "abcdef1234567890"},
                "marks": {"top": 5, "middle": 6, "bottom": 7},
                "environment": {"settings": {"indent": {"enabled": True}}},
            },
        }}}})
        self.assertIn("Extmarks top", report)
        self.assertIn("| 5 | 6 | 7 |", report)
        self.assertIn('"enabled":true', report)
        self.assertIn("abcdef123456", report)


class CliTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.public_dir = self.root / "public"
        self.private_dir = self.root / "private"
        self.calls_file = self.root / "calls.jsonl"
        self.fake_nvim = self.root / "nvim"
        self.fake_nvim.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "from pathlib import Path\n"
            "calls = Path(os.environ['FAKE_NVIM_CALLS'])\n"
            "count = len(calls.read_text().splitlines()) + 1 if calls.exists() else 1\n"
            "with calls.open('a') as stream:\n"
            "    stream.write(json.dumps({'argv': sys.argv[1:], 'kind': os.environ['RM_BENCH_KIND'], 'input': os.environ['RM_BENCH_INPUT']}) + '\\n')\n"
            "ops = ['refresh_top', 'refresh_middle', 'refresh_bottom', 'cursor_top', 'cursor_middle', 'cursor_bottom', 'edit_top', 'edit_middle', 'edit_bottom', 'scroll_top_to_middle', 'scroll_middle_to_bottom']\n"
            "payload = {'nvim': 'NVIM v0.10.0', 'window': {'width': 120, 'height': 40}, 'settings': {'max_file_size': 1000}, 'initial_ms': count * 1.25, 'samples': {name: [float(count + i) for i in range(int(os.environ['RM_BENCH_SAMPLES']))] for name in ops}, 'marks': {'top': 1, 'middle': 2, 'bottom': 3}}\n"
            "Path(os.environ['RM_BENCH_OUTPUT']).write_text(json.dumps(payload))\n",
            encoding="utf-8",
        )
        self.fake_nvim.chmod(0o755)

    def invoke(self, stage="baseline", personal=None, extra=()):
        env = os.environ.copy()
        env["FAKE_NVIM_CALLS"] = str(self.calls_file)
        command = [
            sys.executable,
            str(ROOT / "scripts" / "performance.py"),
            "--stage",
            stage,
            "--samples",
            "2",
            "--cold-runs",
            "2",
            "--sizes",
            "1",
            "--nvim",
            str(self.fake_nvim),
            "--output-dir",
            str(self.public_dir),
            "--private-dir",
            str(self.private_dir),
            *extra,
        ]
        if personal is not None:
            command.extend(["--personal-file", str(personal)])
        return subprocess.run(command, cwd=ROOT, env=env, text=True, capture_output=True)

    def test_cli_keeps_synthetic_public_and_personal_private_results_separate(self):
        personal = self.root / "private-notes.md"
        personal.write_text("distinct personal content\n", encoding="utf-8")
        original_hash = hashlib.sha256(personal.read_bytes()).hexdigest()

        result = self.invoke(personal=personal)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(hashlib.sha256(personal.read_bytes()).hexdigest(), original_hash)
        public_json = (self.public_dir / "performance.json").read_text(encoding="utf-8")
        public_report = (self.public_dir / "PERFORMANCE.md").read_text(encoding="utf-8")
        private_json = (self.private_dir / "personal.json").read_text(encoding="utf-8")
        private_report = (self.private_dir / "PERSONAL.md").read_text(encoding="utf-8")
        calls = [json.loads(line) for line in self.calls_file.read_text(encoding="utf-8").splitlines()]
        public_data = json.loads(public_json)
        private_data = json.loads(private_json)
        synthetic_stage = public_data["stages"]["baseline"]
        personal_stage = private_data["stages"]["baseline"]

        self.assertEqual(len(calls), 14)  # six synthetic fixtures and one personal file, each cold-run twice
        self.assertTrue(all(call["argv"] == ["--clean", "--headless", "-l", "benches/performance.lua"] for call in calls))
        self.assertEqual(len(synthetic_stage["benchmarks"]), 6)
        self.assertEqual(len(synthetic_stage["benchmarks"]["list/1"]["initial_ms"]), 2)
        self.assertEqual(synthetic_stage["benchmarks"]["list/1"]["initial_ms"], [1.25, 2.5])
        self.assertEqual(synthetic_stage["benchmarks"]["list/1"]["samples"]["refresh_top"], [1.0, 2.0])
        self.assertNotIn("personal", public_json.lower())
        self.assertNotIn(str(personal), public_json)
        self.assertNotIn(personal.read_text(encoding="utf-8").strip(), public_json)
        self.assertNotIn(str(personal), public_report)
        self.assertNotIn(personal.read_text(encoding="utf-8").strip(), private_json + private_report)
        self.assertEqual(list(personal_stage["benchmarks"]), ["personal"])
        self.assertEqual(personal_stage["benchmarks"]["personal"]["input"]["sha256"], original_hash)
        self.assertTrue((self.public_dir / "corpus" / "mixed-1000.md").is_file())
        self.assertEqual(
            (self.public_dir / "corpus" / "mixed-1000.md").read_bytes(),
            (self.private_dir / "corpus" / "mixed-1000.md").read_bytes(),
        )

    def test_cli_rejects_duplicate_stage_without_replacement(self):
        first = self.invoke()
        second = self.invoke()

        self.assertEqual(first.returncode, 0, first.stderr)
        self.assertNotEqual(second.returncode, 0)
        self.assertIn("already recorded", second.stderr)

    def test_generate_only_recreates_corpus_without_starting_neovim(self):
        result = subprocess.run(
            [
                sys.executable,
                str(ROOT / "scripts" / "performance.py"),
                "--generate-only",
                "--sizes",
                "1",
                "--private-dir",
                str(self.private_dir),
            ],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        corpus = self.private_dir / "corpus"
        self.assertEqual(len(list(corpus.glob("*.md"))), 6)
        self.assertFalse(self.calls_file.exists())

    def test_cli_replacement_replaces_stage_instead_of_appending_duplicate(self):
        first = self.invoke()
        second = self.invoke(extra=("--replace-stage",))

        self.assertEqual(first.returncode, 0, first.stderr)
        self.assertEqual(second.returncode, 0, second.stderr)
        data = json.loads((self.public_dir / "performance.json").read_text(encoding="utf-8"))
        self.assertEqual(list(data["stages"]), ["baseline"])

    def test_cli_retains_case_specific_settings_without_rejecting_valid_variants(self):
        worker = self.fake_nvim.read_text(encoding="utf-8")
        worker = worker.replace(
            "'settings': {'max_file_size': 1000}",
            "'settings': {'indent': {'enabled': os.environ['RM_BENCH_KIND'] in ('section', 'mixed')}}",
        )
        self.fake_nvim.write_text(worker, encoding="utf-8")
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        benchmarks = json.loads((self.public_dir / "performance.json").read_text())["stages"]["baseline"]["benchmarks"]
        self.assertFalse(benchmarks["list/1"]["environment"]["settings"]["indent"]["enabled"])
        self.assertTrue(benchmarks["section/1"]["environment"]["settings"]["indent"]["enabled"])

    def test_cli_rejects_incomparable_corpus_between_stages(self):
        self.assertEqual(self.invoke().returncode, 0)
        changed = self.invoke(stage="step1", extra=("--sizes", "2"))
        self.assertNotEqual(changed.returncode, 0)
        self.assertIn("corpus", changed.stderr.lower())

    def test_personal_input_cannot_alias_generated_or_output_files(self):
        targets = (
            ("private", "corpus/list-1.md"),
            ("public", "PERFORMANCE.md"),
            ("private", "PERSONAL.md"),
            ("private", "personal.json.tmp"),
            ("public", "corpus/mixed-1000.md"),
        )
        for directory, name in targets:
            with self.subTest(target=name), tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary)
                public, private = root / "public", root / "private"
                target = (public if directory == "public" else private) / name
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text("private document: never overwrite\n", encoding="utf-8")
                before = target.read_bytes()
                result = self.invoke(personal=target, extra=("--output-dir", str(public), "--private-dir", str(private)))
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(before, target.read_bytes())

    def test_cli_rejects_a_different_host_before_comparing_stages(self):
        self.assertEqual(self.invoke().returncode, 0)
        path = self.public_dir / "performance.json"
        data = json.loads(path.read_text())
        data["stages"]["baseline"]["environment"]["cpu_model"] = "A different benchmark host"
        path.write_text(json.dumps(data))
        result = self.invoke(stage="step1")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("host", result.stderr.lower())

    def test_replacing_an_earlier_stage_does_not_leave_stale_downstream_results(self):
        self.assertEqual(self.invoke().returncode, 0)
        self.assertEqual(self.invoke(stage="step1").returncode, 0)
        path = self.public_dir / "performance.json"
        before = path.read_bytes()
        result = self.invoke(extra=("--replace-stage",))
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("later", result.stderr.lower())
        self.assertEqual(before, path.read_bytes())

    def test_private_stages_reject_changed_personal_documents(self):
        personal = self.root / "source.md"
        personal.write_text("original document\n")
        self.assertEqual(self.invoke(personal=personal).returncode, 0)
        personal.write_text("different document\n")
        result = self.invoke(stage="step1", personal=personal)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("personal input changed", result.stderr.lower())
        private = json.loads((self.private_dir / "personal.json").read_text())
        self.assertEqual(list(private["stages"]), ["baseline"])

    def test_private_stages_reject_changed_samples_even_without_public_baseline(self):
        personal = self.root / "source.md"
        personal.write_text("original document\n")
        self.assertEqual(self.invoke(personal=personal).returncode, 0)
        result = self.invoke(stage="step1", personal=personal, extra=("--samples", "3", "--output-dir", str(self.root / "other-public")))
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("private", result.stderr.lower())

    def test_cli_rejects_changed_measurement_harness(self):
        self.assertEqual(self.invoke().returncode, 0)
        path = self.public_dir / "performance.json"
        data = json.loads(path.read_text())
        self.assertIn("harness_fingerprint", data["stages"]["baseline"])
        data["stages"]["baseline"]["harness_fingerprint"] = "a different harness"
        path.write_text(json.dumps(data))
        result = self.invoke(stage="step1")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("harness", result.stderr.lower())

    @unittest.skipUnless(os.name == "posix", "Unix file permissions")
    def test_private_results_are_owner_only_even_with_a_permissive_umask(self):
        personal = self.root / "source.md"
        personal.write_text("private input\n")
        previous = os.umask(0o022)
        try:
            result = self.invoke(personal=personal)
        finally:
            os.umask(previous)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.private_dir.stat().st_mode & 0o777, 0o700)
        for name in ("personal.json", "PERSONAL.md"):
            self.assertEqual((self.private_dir / name).stat().st_mode & 0o777, 0o600)


if __name__ == "__main__":
    unittest.main()
