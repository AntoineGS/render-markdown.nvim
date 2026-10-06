# Performance benchmarks

The benchmark consumes the committed Markdown in [`fixtures/`](fixtures/README.md).
It does not generate inputs or modify files on disk. `scripts/generate.py` and
the older Plenary timing specs are not used by this runner.

```sh
# Inspect exact line counts, byte counts, and hashes without launching Neovim.
python scripts/performance.py --list-inputs

# Record all 16 fixtures: 15 warm samples and three cold runs by default.
just bench
# Equivalent, without requiring just:
python scripts/performance.py --stage baseline

# Quick smoke test, with separate output directories.
python scripts/performance.py --stage baseline --samples 2 --cold-runs 1 \
  --output-dir temp/performance-smoke/results \
  --private-dir temp/performance-smoke/private
```

`--sizes 100`, `--sizes 1000`, or `--sizes 100,1000,5000` selects existing
fixtures; a missing size is rejected, never generated. The mixed document is
always included. `just bench step4` records the viewport-decoration stage.
The runner retains the original framework's `baseline` and `step1`–`step4`
labels; change the implementation between stages, not the harness or inputs.
Use the same runner and fixtures on every revision being compared.

Public results go to ignored `benches/results/performance.json` and
`benches/results/PERFORMANCE.md`. Temporary worker files and optional private
results go to ignored `temp/benchmarks/`. No corpus copies are created.
Recorded stages append; recording the same stage again requires
`--replace-stage`, and replacing a stage with recorded downstream stages is
rejected. Use a separate output directory for a different experiment.

## What is measured

Each cold run starts a clean headless Neovim process with the installed Markdown
parsers. The worker does not install parsers or load the user's configuration.
Initial timing covers buffer attachment and rendering, excluding process
startup. Warm samples measure refreshes, cursor movement, in-memory edits, and
scrolling at the top, middle, and bottom of the document. Each operation has
three unrecorded warm-ups; warm samples come from the first cold run.

Timings include editor and Tree-sitter costs, not just plugin work. Edits append
and remove trailing whitespace rather than simulating arbitrary typing.
Scrolls jump between positions rather than replaying an interactive browsing
session. Inputs are more representative; the actions remain controlled probes.

The viewport is fixed at 80 columns and 23 rows with wrapping disabled. This
keeps the original framework's viewport and avoids a known native crash when
resizing the local development build's headless grid to 40 rows. Wide tables
therefore extend beyond the visible window. Default anti-conceal is retained,
debounce is zero, LaTeX is disabled, and section/mixed cases enable indentation.
This is not a measurement of wrapped-table navigation or attached-UI latency.

Reports preserve raw timings, medians, nearest-rank p95, viewport extmark counts,
actual input sizes and SHA-256 hashes, environment/settings, source fingerprints
covering `lua/` and `plugin/`, and harness fingerprints. At 15 samples, p95 is the largest warm
sample; three cold runs are likewise too few for a reliable tail estimate.
Run measurements sequentially without other tests or benchmarks competing for
CPU. Treat a two-sample smoke run as a correctness check, not performance data.

Changing inputs, the measurement harness, sample counts, host, or case settings
invalidates a comparison. The runner checks static input hashes again before
saving results. The original PR #696 numbers used a different corpus and cannot
serve as a baseline for these fixtures.

## Optional private input

```sh
python scripts/performance.py --stage baseline --personal-file /path/to/notes.md
```

Private document contents and paths are not published in public JSON/reports.
Private timings go to `temp/benchmarks/personal.json` and `PERSONAL.md`, with
owner-only permissions on Unix. Source files remain unchanged: edits are made
only in a scratch buffer. Output directories cannot overlap the committed
fixtures, and personal inputs cannot alias benchmark inputs or output files.

## Orchestration tests

```sh
PYTHONDONTWRITEBYTECODE=1 python -m unittest discover -s scripts/tests
```

These tests cover read-only fixture loading, missing/empty inputs, worker
arguments, sample aggregation, reporting, stage compatibility, output-location
guards (including disjoint public/private directories), and private-result
isolation. Run a real Neovim smoke test as well to verify rendering with the
locally installed parsers.

## Existing attached-UI helpers

`benches.wrapped.run` and its UI-client helpers remain available for separate
Ctrl-U/D measurements with an attached Neovim UI. They are not invoked by
`just bench` or the headless corpus comparison above.

The existing `benches/wrapped_cli.lua` reads the generated
`benches/results/PERFORMANCE.md` and starts at row 464. It therefore requires a
report with at least that many lines; reports are untracked benchmark outputs,
not corpus fixtures. For a shorter report or a static fixture, call
`benches.wrapped.run` with explicit `lines` and an appropriate `row` instead.
