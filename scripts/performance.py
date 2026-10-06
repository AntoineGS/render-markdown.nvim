#!/usr/bin/env python3
"""Run repeatable Neovim performance benchmarks against committed Markdown."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import platform
import statistics
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
CORPUS_DIR = ROOT / "benches" / "fixtures"
STAGES = ("baseline", "step1", "step2", "step3", "step4")
STAGE_DESCRIPTIONS = {
    "baseline": "Baseline implementation",
    "step1": "Avoid unused list indices",
    "step2": "Empty-row hash membership",
    "step3": "Lazy node text and early viewport checks",
    "step4": "Viewport-bounded decorations",
}
KINDS = ("list", "nested_code", "code", "table", "section")
MIXED_SIZE = 1000
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
SCHEMA_VERSION = 1


class PerformanceError(Exception):
    """A safe-to-display benchmark orchestration error."""


def positive_int(value: str) -> int:
    try:
        parsed = int(value)
    except ValueError as error:
        raise argparse.ArgumentTypeError("must be an integer greater than zero") from error
    if parsed < 1:
        raise argparse.ArgumentTypeError("must be an integer greater than zero")
    return parsed


def parse_sizes(value: str) -> list[int]:
    try:
        sizes = [int(part.strip()) for part in value.split(",")]
    except ValueError as error:
        raise argparse.ArgumentTypeError("sizes must be comma-separated positive integers") from error
    if not sizes or any(size < 1 for size in sizes):
        raise argparse.ArgumentTypeError("sizes must be comma-separated positive integers")
    if len(set(sizes)) != len(sizes):
        raise argparse.ArgumentTypeError("sizes must not contain duplicates")
    return sizes


def _input_metadata(kind: str, size: int, name: str, content: bytes) -> dict[str, Any]:
    lines = len(content.decode("utf-8").splitlines())
    return {
        "kind": kind,
        "size": size,
        "name": name,
        "count": lines,
        "bytes": len(content),
        "lines": lines,
        "sha256": hashlib.sha256(content).hexdigest(),
    }


def load_corpus(corpus_dir: Path | str, sizes: list[int]) -> list[dict[str, Any]]:
    """Read static inputs and fingerprint their actual bytes; never generate them."""
    directory = Path(corpus_dir)
    metadata: list[dict[str, Any]] = []
    cases = [(kind, size) for size in sizes for kind in KINDS]
    cases.append(("mixed", MIXED_SIZE))
    for kind, size in cases:
        name = f"{kind}-{size}.md"
        try:
            content = (directory / name).read_bytes()
        except OSError as error:
            raise PerformanceError(f"fixture {name} is unavailable; select committed sizes with --sizes") from error
        if not content.strip():
            raise PerformanceError(f"fixture {name} is empty")
        metadata.append(_input_metadata(kind, size, name, content))
    return metadata


def nearest_rank_percentile(values: list[float], percentile: float) -> float:
    """Return a percentile using the one-based nearest-rank definition."""
    if not values:
        raise ValueError("percentile requires at least one value")
    if not 0 < percentile <= 1:
        raise ValueError("percentile must be in the interval (0, 1]")
    ordered = sorted(values)
    rank = math.ceil(percentile * len(ordered))
    return ordered[rank - 1]


def _median(values: list[float]) -> float:
    return statistics.median(values)


def _format_number(value: float) -> str:
    return f"{value:.3f}"


def _format_delta(value: float | None) -> str:
    if value is None:
        return "—"
    return f"{value:+.1f}%"


def _metric_values(benchmark: dict[str, Any], metric: str) -> list[float]:
    if metric == "initial_ms":
        values = benchmark.get("initial_ms", [])
    else:
        values = benchmark.get("samples", {}).get(metric, [])
    return values if isinstance(values, list) else []


def _metric_delta(current: list[float], other: list[float]) -> float | None:
    if not current or not other:
        return None
    comparison = _median(other)
    if comparison == 0:
        return None
    return (_median(current) - comparison) / comparison * 100


def _ordered_stage_names(stages: dict[str, Any]) -> list[str]:
    known = [stage for stage in STAGES if stage in stages]
    return known + sorted(stage for stage in stages if stage not in STAGES)


def render_report(document: dict[str, Any], title: str = "Performance results") -> str:
    """Render summaries and raw per-operation distributions for recorded stages."""
    stages = document.get("stages", {})
    if not isinstance(stages, dict):
        stages = {}
    stage_names = _ordered_stage_names(stages)
    lines = [
        f"# {title}",
        "",
        "This report preserves raw timing distributions. Lower times are better; percentage deltas are relative to the comparison stage.",
        "Comparisons are shown against the baseline and the previous recorded stage when matching measurements exist.",
        "",
        "## Stage summary",
        "",
        "| Stage | Description | Benchmarks | Source fingerprint |",
        "| --- | --- | ---: | --- |",
    ]

    for stage_name in stage_names:
        stage = stages[stage_name]
        benchmarks = stage.get("benchmarks", {})
        fingerprint = stage.get("source_fingerprint", "")
        lines.append(
            f"| {stage_name} | {stage.get('description', STAGE_DESCRIPTIONS.get(stage_name, stage_name))} | "
            f"{len(benchmarks)} | {fingerprint[:12] or '—'} |"
        )

    lines.extend(
        (
            "",
            "## Environment",
            "",
            "| Stage | Platform | Python | CPU | Neovim | Window | First case settings |",
            "| --- | --- | --- | --- | --- | --- | --- |",
        )
    )
    for stage_name in stage_names:
        environment = stages[stage_name].get("environment", {})
        settings = json.dumps(environment.get("settings", {}), sort_keys=True, separators=(",", ":"))
        window = json.dumps(environment.get("window", {}), sort_keys=True, separators=(",", ":"))
        lines.append(
            f"| {stage_name} | {environment.get('platform', '—')} | {environment.get('python', '—')} | "
            f"{environment.get('cpu_model', '—')} | {environment.get('nvim', '—')} | {window} | {settings} |"
        )

    lines.extend(
        (
            "",
            "## Inputs and viewport decorations",
            "",
            "Case-specific settings are retained below (section and mixed fixtures enable indentation).",
            "",
            "| Stage | Benchmark | Lines | Bytes | Input SHA-256 | Extmarks top | Extmarks middle | Extmarks bottom | Case settings |",
            "| --- | --- | ---: | ---: | --- | ---: | ---: | ---: | --- |",
        )
    )
    for stage_name in stage_names:
        for key, benchmark in sorted(stages[stage_name].get("benchmarks", {}).items()):
            metadata = benchmark.get("input", {})
            marks = benchmark.get("marks", {})
            settings = json.dumps(benchmark.get("environment", {}).get("settings", {}), sort_keys=True, separators=(",", ":"))
            lines.append(
                f"| {stage_name} | {key} | {metadata.get('lines', '—')} | {metadata.get('bytes', '—')} | "
                f"{metadata.get('sha256', '')[:12] or '—'} | {marks.get('top', '—')} | "
                f"{marks.get('middle', '—')} | {marks.get('bottom', '—')} | {settings} |"
            )
    if any("mixed/1000" in stages[stage].get("benchmarks", {}) for stage in stage_names):
        lines.extend(("", "Inputs are committed under `benches/fixtures/`; no corpus copies are generated."))

    lines.extend(
        (
            "",
            "## Operation distributions",
            "",
            "`initial_ms` is aggregated across cold runs. Warm operation samples are from the first cold run only. Raw values are in milliseconds.",
            "",
            "| Stage | Benchmark | Metric | Median ms | p95 ms | Baseline Δ | Previous Δ | Raw samples ms |",
            "| --- | --- | --- | ---: | ---: | ---: | ---: | --- |",
        )
    )

    for stage_index, stage_name in enumerate(stage_names):
        stage = stages[stage_name]
        benchmarks = stage.get("benchmarks", {})
        baseline = stages.get("baseline", {}).get("benchmarks", {})
        previous = stages[stage_names[stage_index - 1]].get("benchmarks", {}) if stage_index else {}
        for benchmark_key in sorted(benchmarks):
            benchmark = benchmarks[benchmark_key]
            metrics = ["initial_ms"] + [operation for operation in OPERATIONS if operation in benchmark.get("samples", {})]
            for metric in metrics:
                values = _metric_values(benchmark, metric)
                if not values:
                    continue
                baseline_values = _metric_values(baseline.get(benchmark_key, {}), metric)
                previous_values = _metric_values(previous.get(benchmark_key, {}), metric)
                lines.append(
                    f"| {stage_name} | {benchmark_key} | {metric} | {_format_number(_median(values))} | "
                    f"{_format_number(nearest_rank_percentile(values, 0.95))} | "
                    f"{_format_delta(_metric_delta(values, baseline_values))} | "
                    f"{_format_delta(_metric_delta(values, previous_values))} | {values} |"
                )

    lines.append("")
    return "\n".join(lines)


def _sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def source_fingerprint(root: Path = ROOT) -> str:
    """Hash sorted Lua source paths and bytes, independent of the Git diff."""
    digest = hashlib.sha256()
    sources = [path for directory in ("lua", "plugin") for path in (root / directory).rglob("*.lua")]
    for path in sorted(sources, key=lambda item: item.relative_to(root).as_posix()):
        digest.update(path.relative_to(root).as_posix().encode("utf-8"))
        digest.update(b"\0")
        digest.update(path.read_bytes())
        digest.update(b"\0")
    return digest.hexdigest()


def harness_fingerprint(root: Path = ROOT) -> str:
    digest = hashlib.sha256()
    for name in ("benches/runner.lua", "benches/performance.lua", "scripts/performance.py"):
        digest.update(name.encode("utf-8") + b"\0")
        digest.update((root / name).read_bytes() + b"\0")
    return digest.hexdigest()


def _cpu_model() -> str:
    try:
        for line in Path("/proc/cpuinfo").read_text(encoding="utf-8").splitlines():
            if line.lower().startswith(("model name", "hardware")):
                return line.partition(":")[2].strip() or "unknown"
    except OSError:
        pass
    return platform.processor() or "unknown"


def _redact_home(value: Any) -> Any:
    home = str(Path.home())
    if isinstance(value, str):
        return value.replace(home, "<HOME>") if home and home != "/" else value
    if isinstance(value, list):
        return [_redact_home(item) for item in value]
    if isinstance(value, dict):
        return {_redact_home(key): _redact_home(item) for key, item in value.items()}
    return value


def _valid_number(value: Any) -> bool:
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and value >= 0


def _validate_worker(data: Any, samples: int) -> dict[str, Any]:
    if not isinstance(data, dict):
        raise PerformanceError("benchmark worker output must be a JSON object")
    if not isinstance(data.get("nvim"), str) or not data["nvim"]:
        raise PerformanceError("benchmark worker output is missing the Neovim version")
    window = data.get("window")
    if not isinstance(window, dict) or any(not isinstance(window.get(key), int) or window[key] <= 0 for key in ("width", "height")):
        raise PerformanceError("benchmark worker output has an invalid window")
    if "settings" not in data:
        raise PerformanceError("benchmark worker output is missing settings")
    try:
        json.dumps(data["settings"], allow_nan=False)
    except (TypeError, ValueError) as error:
        raise PerformanceError("benchmark worker settings are not JSON serializable") from error
    if not _valid_number(data.get("initial_ms")):
        raise PerformanceError("benchmark worker output has an invalid initial_ms")
    operation_samples = data.get("samples")
    if not isinstance(operation_samples, dict):
        raise PerformanceError("benchmark worker output is missing operation samples")
    for operation in OPERATIONS:
        values = operation_samples.get(operation)
        if not isinstance(values, list) or len(values) != samples or any(not _valid_number(value) for value in values):
            raise PerformanceError(f"benchmark worker returned invalid samples for {operation}")
    marks = data.get("marks")
    if not isinstance(marks, dict) or any(key not in marks for key in ("top", "middle", "bottom")):
        raise PerformanceError("benchmark worker output is missing viewport marks")
    return data


def _run_worker(
    executable: str,
    root: Path,
    input_path: Path,
    kind: str,
    samples: int,
    private_dir: Path,
    label: str,
) -> dict[str, Any]:
    with tempfile.TemporaryDirectory(prefix="worker-", dir=private_dir) as temporary:
        output_path = Path(temporary) / "result.json"
        environment = os.environ.copy()
        environment.update(
            {
                "RM_BENCH_INPUT": str(input_path.resolve()),
                "RM_BENCH_KIND": kind,
                "RM_BENCH_SAMPLES": str(samples),
                "RM_BENCH_OUTPUT": str(output_path.resolve()),
            }
        )
        try:
            completed = subprocess.run(
                [executable, "--clean", "--headless", "-l", "benches/performance.lua"],
                cwd=root,
                env=environment,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=False,
            )
        except OSError as error:
            raise PerformanceError("could not start Neovim; check --nvim") from error
        if completed.returncode != 0:
            raise PerformanceError(f"benchmark process failed for {label} (exit {completed.returncode})")
        try:
            result = json.loads(output_path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, json.JSONDecodeError) as error:
            raise PerformanceError(f"benchmark worker did not produce valid JSON for {label}") from error
        return _validate_worker(result, samples)


def _worker_signature(worker: dict[str, Any]) -> str:
    return json.dumps(
        {key: worker[key] for key in ("nvim", "window")},
        sort_keys=True,
        separators=(",", ":"),
        allow_nan=False,
    )


def _run_benchmark(
    executable: str,
    root: Path,
    input_path: Path,
    kind: str,
    samples: int,
    cold_runs: int,
    private_dir: Path,
    label: str,
    input_metadata: dict[str, Any],
    expected_signature: str | None,
) -> tuple[dict[str, Any], dict[str, Any], str]:
    initial_times: list[float] = []
    first_worker: dict[str, Any] | None = None
    signature = expected_signature
    for cold_run in range(cold_runs):
        worker = _run_worker(executable, root, input_path, kind, samples, private_dir, label)
        current_signature = _worker_signature(worker)
        if signature is None:
            signature = current_signature
        elif signature != current_signature:
            raise PerformanceError("Neovim version, window, or settings changed during the benchmark")
        initial_times.append(worker["initial_ms"])
        if cold_run == 0:
            first_worker = worker
        elif first_worker["settings"] != worker["settings"]:
            raise PerformanceError("settings changed between cold runs of the same benchmark")

    assert first_worker is not None and signature is not None
    benchmark = {
        "kind": kind,
        "input": input_metadata,
        "initial_ms": initial_times,
        "samples": first_worker["samples"],
        "marks": first_worker["marks"],
        "environment": {key: first_worker[key] for key in ("nvim", "window", "settings")},
    }
    environment = {
        "nvim": first_worker["nvim"],
        "window": first_worker["window"],
        "settings": first_worker["settings"],
    }
    return benchmark, environment, signature


def _read_results(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"schema_version": SCHEMA_VERSION, "stages": {}}
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        raise PerformanceError(f"existing results file {path.name} is not valid JSON") from error
    if not isinstance(document, dict) or not isinstance(document.get("stages"), dict):
        raise PerformanceError(f"existing results file {path.name} has an invalid schema")
    return document


def _validate_public_results(document: dict[str, Any]) -> None:
    """Refuse to continue if the public aggregate contains a non-synthetic fixture."""
    for stage in document["stages"].values():
        benchmarks = stage.get("benchmarks", {}) if isinstance(stage, dict) else {}
        if not isinstance(benchmarks, dict):
            raise PerformanceError("public results contain an invalid benchmark collection")
        for benchmark in benchmarks.values():
            if not isinstance(benchmark, dict) or benchmark.get("kind") not in (*KINDS, "mixed"):
                raise PerformanceError("public results may contain synthetic inputs only")
            input_metadata = benchmark.get("input", {})
            if not isinstance(input_metadata, dict) or input_metadata.get("kind") not in (*KINDS, "mixed"):
                raise PerformanceError("public results may contain synthetic inputs only")


def _write_results(path: Path, document: dict[str, Any], private: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(document, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    if private and os.name == "posix":
        temporary.chmod(0o600)
    temporary.replace(path)


def _relative_to_root(path: str, root: Path) -> Path:
    target = Path(path).expanduser()
    return target if target.is_absolute() else root / target


def _personal_input_metadata(path: Path) -> dict[str, Any]:
    try:
        content = path.read_bytes()
    except OSError as error:
        raise PerformanceError("personal input must be a readable file") from error
    return {
        "kind": "personal",
        "name": "private input",
        "count": len(content.decode("utf-8", errors="replace").splitlines()),
        "bytes": len(content),
        "lines": len(content.decode("utf-8", errors="replace").splitlines()),
        "sha256": hashlib.sha256(content).hexdigest(),
    }


def _protect_personal_input(value: str | None, output_dir: Path, private_dir: Path, sizes: list[int]) -> Path | None:
    """Reject source/output aliases before creating or overwriting any files."""
    if private_dir.is_relative_to(output_dir) or output_dir.is_relative_to(private_dir):
        raise PerformanceError("private and shareable output directories must be disjoint")
    if value is None:
        return None
    try:
        source = Path(value).expanduser().resolve(strict=True)
        if not source.is_file():
            raise PerformanceError("personal input must be a readable file")
    except (OSError, RuntimeError) as error:
        raise PerformanceError("personal input must be a readable file") from error
    targets = [CORPUS_DIR / f"{kind}-{size}.md" for size in sizes for kind in KINDS]
    targets.extend((
        CORPUS_DIR / f"mixed-{MIXED_SIZE}.md",
        output_dir / "PERFORMANCE.md",
        output_dir / "performance.json",
        output_dir / "performance.json.tmp",
        private_dir / "PERSONAL.md",
        private_dir / "personal.json",
        private_dir / "personal.json.tmp",
    ))
    for target in targets:
        if source == target.resolve() or (target.exists() and source.samefile(target)):
            raise PerformanceError("personal input collides with a benchmark input or output file")
    if source.is_relative_to(output_dir):
        raise PerformanceError("personal input must be outside the shareable output directory")
    return source


def _make_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run the render-markdown Neovim performance benchmark")
    parser.add_argument("--stage", choices=STAGES, help="implementation stage to record")
    parser.add_argument("--samples", type=positive_int, default=15, help="warm samples per operation (default: 15)")
    parser.add_argument("--cold-runs", type=positive_int, default=3, help="fresh Neovim processes (default: 3)")
    parser.add_argument("--sizes", type=parse_sizes, default=parse_sizes("100,1000,5000"), help="comma-separated committed fixture sizes (100,1000,5000)")
    parser.add_argument("--personal-file", help="optional private Markdown input (never written to public results)")
    parser.add_argument("--output-dir", default="benches/results", help="directory for public JSON and report")
    parser.add_argument("--private-dir", default="temp/benchmarks", help="directory for worker scratch files and private results")
    parser.add_argument("--nvim", default="nvim", help="Neovim executable (default: nvim)")
    parser.add_argument("--replace-stage", action="store_true", help="replace a stage already present in the output")
    parser.add_argument("--list-inputs", action="store_true", help="list committed input metadata as JSON without running Neovim")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = _make_parser()
    args = parser.parse_args(argv)
    if not args.list_inputs and args.stage is None:
        parser.error("--stage is required unless --list-inputs is used")

    root = ROOT
    output_dir = _relative_to_root(args.output_dir, root).resolve()
    private_dir = _relative_to_root(args.private_dir, root).resolve()
    corpus_dir = CORPUS_DIR.resolve()
    try:
        for directory in (output_dir, private_dir):
            if directory.is_relative_to(corpus_dir) or corpus_dir.is_relative_to(directory):
                raise PerformanceError("output directories must not overlap the committed fixtures")
        _protect_personal_input(args.personal_file, output_dir, private_dir, args.sizes)
        corpus_metadata = load_corpus(corpus_dir, args.sizes)
        if args.list_inputs:
            print(json.dumps(corpus_metadata, indent=2))
            return 0
        private_dir.mkdir(parents=True, exist_ok=True, mode=0o700)
        if os.name == "posix":
            private_dir.chmod(0o700)
        public_path = output_dir / "performance.json"
        public_document = _read_results(public_path)
        private_path = private_dir / "personal.json"
        private_document: dict[str, Any] | None = None
        personal_path: Path | None = None
        personal_hash_before: str | None = None
        personal_metadata: dict[str, Any] | None = None
        if args.personal_file:
            try:
                personal_path = Path(args.personal_file).expanduser().resolve(strict=True)
                if not personal_path.is_file():
                    raise PerformanceError("personal input must be a readable file")
                personal_hash_before = _sha256_file(personal_path)
            except (OSError, RuntimeError) as error:
                raise PerformanceError("personal input must be a readable file") from error
            personal_metadata = _personal_input_metadata(personal_path)
            if personal_metadata["sha256"] != personal_hash_before:
                raise PerformanceError("personal input changed while it was being prepared")
            private_document = _read_results(private_path)

        _validate_public_results(public_document)

        baseline = public_document["stages"].get("baseline")
        host = {
            "platform": platform.platform(),
            "python": platform.python_version(),
            "cpu_model": _cpu_model(),
        }
        private_baseline = private_document["stages"].get("baseline") if private_document else None
        if private_baseline is not None and args.stage != "baseline":
            previous_input = private_baseline["benchmarks"]["personal"]["input"]
            if previous_input["sha256"] != personal_metadata["sha256"]:
                raise PerformanceError("personal input changed since private baseline")
            if any(private_baseline["config"][key] != getattr(args, key) for key in ("samples", "cold_runs")):
                raise PerformanceError("private sample configuration changed since baseline")
            if any(private_baseline["environment"].get(key) != value for key, value in host.items()):
                raise PerformanceError("private benchmark host changed since baseline")
        if baseline is not None and args.stage != "baseline":
            if any(baseline["environment"].get(key) != value for key, value in host.items()):
                raise PerformanceError("benchmark host changed since baseline")
            previous_inputs = {
                key: value["input"]["sha256"]
                for key, value in baseline["benchmarks"].items()
            }
            current_inputs = {
                f"{item['kind']}/{item['size']}": item["sha256"]
                for item in corpus_metadata
            }
            if previous_inputs != current_inputs:
                raise PerformanceError("corpus changed since baseline; use a separate output directory")
            if any(baseline["config"][key] != getattr(args, key) for key in ("samples", "cold_runs")):
                raise PerformanceError("sample configuration changed since baseline")
        fingerprint = source_fingerprint(root)
        harness = harness_fingerprint(root)
        for document in (public_document, private_document):
            if document is None:
                continue
            for previous in document["stages"].values():
                recorded_harness = previous.get("harness_fingerprint")
                if recorded_harness is not None and recorded_harness != harness:
                    raise PerformanceError("measurement harness changed; use another output directory")

        for document, description in ((public_document, "public"), (private_document, "private")):
            if document is None:
                continue
            if args.stage in document["stages"] and not args.replace_stage:
                raise PerformanceError(
                    f"stage {args.stage} is already recorded in {description} results; use --replace-stage to replace it"
                )
            if args.stage in document["stages"] and args.replace_stage:
                later = STAGES[STAGES.index(args.stage) + 1:]
                if any(stage in document["stages"] for stage in later):
                    raise PerformanceError("cannot replace a stage with later cumulative results; use another output directory")

        stage_benchmarks: dict[str, Any] = {}
        worker_environment: dict[str, Any] | None = None
        signature: str | None = None
        for item in corpus_metadata:
            kind = item["kind"]
            size = item["size"]
            label = f"{kind} size {size}"
            benchmark, environment, signature = _run_benchmark(
                args.nvim,
                root,
                corpus_dir / item["name"],
                kind,
                args.samples,
                args.cold_runs,
                private_dir,
                label,
                {key: item[key] for key in ("kind", "size", "name", "count", "bytes", "lines", "sha256")},
                signature,
            )
            benchmark_key = f"{kind}/{size}"
            if baseline is not None and args.stage != "baseline":
                previous_environment = baseline["benchmarks"][benchmark_key]["environment"]
                if previous_environment != environment:
                    raise PerformanceError("benchmark environment changed since baseline")
            stage_benchmarks[benchmark_key] = benchmark
            if worker_environment is None:
                worker_environment = environment

        if personal_path is not None and personal_metadata is not None:
            personal_benchmark, personal_environment, signature = _run_benchmark(
                args.nvim,
                root,
                personal_path,
                "personal",
                args.samples,
                args.cold_runs,
                private_dir,
                "personal input",
                personal_metadata,
                signature,
            )
            assert private_document is not None
            if private_baseline is not None and args.stage != "baseline":
                previous_environment = private_baseline["benchmarks"]["personal"]["environment"]
                if previous_environment != personal_environment:
                    raise PerformanceError("private benchmark environment changed since baseline")
            if personal_hash_before != _sha256_file(personal_path):
                raise PerformanceError("personal input changed during the benchmark; no results were saved")
            private_benchmarks = {"personal": personal_benchmark}
            private_environment = {
                **host,
                **personal_environment,
            }
            private_stage = {
                "stage": args.stage,
                "description": STAGE_DESCRIPTIONS[args.stage],
                "recorded_at_utc": datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z"),
                "config": {"samples": args.samples, "cold_runs": args.cold_runs},
                "environment": private_environment,
                "source_fingerprint": fingerprint,
                "harness_fingerprint": harness,
                "benchmarks": private_benchmarks,
            }
            if args.replace_stage:
                private_document["stages"].pop(args.stage, None)
            private_document["stages"][args.stage] = private_stage

        if worker_environment is None:
            raise PerformanceError("no benchmark inputs were loaded")
        public_environment = {
            **host,
            **worker_environment,
        }
        public_stage = {
            "stage": args.stage,
            "description": STAGE_DESCRIPTIONS[args.stage],
            "recorded_at_utc": datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z"),
            "config": {"samples": args.samples, "cold_runs": args.cold_runs, "sizes": args.sizes},
            "environment": public_environment,
            "source_fingerprint": fingerprint,
            "harness_fingerprint": harness,
            "benchmarks": stage_benchmarks,
        }
        if source_fingerprint(root) != fingerprint:
            raise PerformanceError("Lua source changed during the benchmark; no results were saved")
        if harness_fingerprint(root) != harness:
            raise PerformanceError("measurement harness changed during the benchmark; no results were saved")
        if load_corpus(corpus_dir, args.sizes) != corpus_metadata:
            raise PerformanceError("fixtures changed during the benchmark; no results were saved")
        public_document["schema_version"] = SCHEMA_VERSION
        if args.replace_stage:
            public_document["stages"].pop(args.stage, None)
        public_document["stages"][args.stage] = _redact_home(public_stage)
        public_document = _redact_home(public_document)
        _write_results(public_path, public_document)
        (output_dir / "PERFORMANCE.md").write_text(render_report(public_document), encoding="utf-8")
        if private_document is not None:
            private_document["schema_version"] = SCHEMA_VERSION
            _write_results(private_path, private_document, private=True)
            private_report = private_dir / "PERSONAL.md"
            private_report.write_text(
                render_report(private_document, "Personal performance results"), encoding="utf-8"
            )
            if os.name == "posix":
                private_report.chmod(0o600)

        print(f"Recorded {args.stage}: {len(stage_benchmarks)} public fixtures" + (" and one private input." if personal_path else "."))
        return 0
    except PerformanceError as error:
        parser.error(str(error))
    except (OSError, UnicodeError, ValueError, TypeError) as error:
        # Do not include arbitrary exception text: it may contain a personal path.
        parser.error("benchmark orchestration failed; check the configured directories and inputs")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
