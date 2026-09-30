# Performance benchmarks

`scripts/performance.py` runs deterministic, headless Neovim benchmarks against generated Markdown files. The inputs are synthetic and live under the ignored `temp/benchmarks/corpus/` directory; no corpus file is copied into benchmark results. To regenerate the public corpus without launching Neovim:

```sh
python scripts/performance.py --generate-only
```

The default corpus sizes are 100, 1,000, and 5,000. Each size includes a nested list, one long list-nested fenced Lua block with alternating blank rows, one long fenced Lua block, one long table, and one long indented section. A representative mixed document is also generated at size 1,000. These shapes deliberately exercise the reviewed hot paths rather than merely repeating many small blocks. Generation is deterministic and leaves unrelated files in the corpus directory alone. To use different sizes, pass `--sizes 100,1000,5000` (or another comma-separated list).

The generated mixed document is also published at `benches/results/corpus/mixed-1000.md`, independently of the personal input. Other synthetic Markdown snapshots can be shared by regenerating them and selecting files from `temp/benchmarks/corpus/`.

## Recording stages

Record the stages sequentially so the report can compare each implementation with the baseline and the preceding stage:

```sh
python scripts/performance.py --stage baseline
python scripts/performance.py --stage step1
python scripts/performance.py --stage step2
python scripts/performance.py --stage step3
python scripts/performance.py --stage step4
```

The stages describe these changes:

1. `step1` — avoid unused list indices while preserving index-dependent providers
2. `step2` — empty-row hash membership
3. `step3` — lazy node text and early viewport checks
4. `step4` — viewport-bounded decorations

The defaults are 15 warm samples, three cold runs, and `nvim` as the executable. Each operation has three unrecorded warm-up samples. Use `--samples`, `--cold-runs`, `--sizes`, or `--nvim` to adjust them. Each cold run starts a separate `nvim --clean --headless -l benches/performance.lua` process from the repository root. The process count is `(5 × number of sizes + 1 mixed fixture) × cold runs`, plus the optional personal-file runs. Processes run sequentially; avoid other test or benchmark runs while collecting measurements.

The standalone worker uses an 80-column, 23-row window. The installed Neovim development build reproducibly aborts with `grid_put_linebuf` when its headless grid is resized to a 40-row viewport on a conceal-heavy document; the fixed normal headless size avoids that unrelated native crash. The exact build and actual window dimensions are recorded. Rendering uses the installed Markdown parsers and highlighter, default anti-conceal, zero debounce, and disabled LaTeX conversion; section and mixed fixtures additionally enable section indentation. No parser is installed or updated by the benchmark.

The worker's `initial_ms` includes initial buffer attachment and rendering, but excludes Neovim process startup. Warm operation samples measure real buffer edits and viewport actions, including Neovim/editor and Tree-sitter costs; they are not plugin-only timings. Cold initial timings are all retained. Warm operation distributions come from the first cold process to avoid mixing process variants. Reports show the median, nearest-rank p95, raw samples, and percentage deltas for matching benchmark/operation keys against baseline and the preceding recorded stage. Lower times are better.

Public JSON and its generated report are written to `benches/results/performance.json` and `benches/results/PERFORMANCE.md`. Stages append to those files; a duplicate stage is rejected unless `--replace-stage` is specified. The result records platform, Python and CPU details, Neovim version, case-specific window/settings, input byte/line/count/SHA-256 metadata, extmark counts at each position, and a SHA-256 fingerprint over sorted `lua/**/*.lua` paths and contents. The source fingerprint is not based on a Git diff. Changing the corpus, sample configuration, or case environment after baseline is rejected; use another output directory for a different experiment. Changing Lua source during a run also prevents saving misleading results.

At 15 samples, nearest-rank p95 is the maximum observed warm sample; at three cold runs it is likewise the maximum cold sample. These are local exploratory distributions, not strong statistical tail estimates or portable latency guarantees. Cursor and scroll timings include Neovim cursor placement; real-edit timings also include Tree-sitter parsing. Report both improvements and regressions rather than attributing all latency to the renderer.

Stage replacement is allowed only when no later cumulative stage is recorded.
Host fields (platform, Python, CPU), personal-input hashes, and private sample
configuration are checked too. Personal inputs that alias generated corpus or
output files are rejected before any files are written. Private outputs must
remain outside the shareable directory.

The harness fingerprint covers the Lua worker and Python driver. Comparing
different harnesses, inputs, sample counts or environments is rejected.
For independent changes, record a shared baseline and exactly one step in
each separate output directory; do not mix results from sibling branches.

## Optional personal input

A personal Markdown file can be benchmarked with the same stage without publishing its path or contents:

```sh
python scripts/performance.py --stage baseline --personal-file /path/to/your/document.md
```

The personal input is opened read-only by the orchestrator, and its SHA-256 is checked before and after benchmarking. The worker is expected to perform edits in memory only. Personal raw timings and their report are stored separately in the ignored `temp/benchmarks/personal.json` and `temp/benchmarks/PERSONAL.md`. The public JSON/report are generated solely from synthetic fixtures; neither personal measurements, document content, nor its path is copied there. Keep any custom `--private-dir` private as well.

On Unix, the private directory is restricted to 0700 and the personal JSON/report
to 0600, even with a permissive umask. Use separate output/private directories
for a new staged experiment.

## Test baseline note

The known offline baseline has 10 failures, including the unavailable LaTeX parser and five code-fixture failures. These failures are tracked; this note is not a claim that the full test suite is green.

To rerun the full existing suite without installing parsers:

```sh
RM_TEST_OFFLINE=1 nvim --headless --noplugin -u tests/minimal_init.lua \
  -c "PlenaryBustedDirectory tests { minimal_init = 'tests/minimal_init.lua', sequential = true, keep_going = true }"
PYTHONDONTWRITEBYTECODE=1 python -m unittest discover -s scripts/tests
```

The default test initializer still installs its requested parsers when `RM_TEST_OFFLINE` is not set. Baseline validation currently reports five code-layout mismatches and five LaTeX failures (the LaTeX parser is unavailable).

## Attached-UI measurements

`benches.wrapped.run` accepts synthetic Markdown lines and measures real
Ctrl-U/D keypresses through an attached Neovim UI. The standalone
`benches/wrapped_cli.lua` expects an existing large generated report at
`benches/results/PERFORMANCE.md` (at least 464 lines); it is not a tracked
fixture. For shorter reports or other synthetic inputs, call the runner
directly with the appropriate `lines` and `row` values.

Recorded results and PR comparison documents are intentionally excluded
from the framework commit. Generate them locally and keep them uncommitted.
