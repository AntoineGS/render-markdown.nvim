# Benchmark fixtures

These static Markdown documents model technical guides, operational notebooks,
implementation reviews, and service inventories. Edit and review the files
directly: the performance runner never generates, rewrites, or copies them.

The number in a filename is an **approximate total line count**, not an item,
table-row, or code-line count. Files end at complete Markdown constructs rather
than being padded or truncated to hit an exact size.

| Kind | `100` lines | `1000` lines | `5000` lines |
| --- | ---: | ---: | ---: |
| `list` | 109 | 1,011 | 5,004 |
| `nested_code` | 101 | 961 | 5,009 |
| `code` | 111 | 995 | 5,012 |
| `table` | 96 | 1,000 | 4,998 |
| `section` | 98 | 1,016 | 4,985 |

`mixed-1000.md` contains 997 lines and interleaves all five kinds.

## Document shapes

- **Lists:** grouped operational tasks with 3–11 main items, varied text lengths,
  ordered steps, checkboxes, continuation paragraphs, and nested notes.
- **Nested code:** review checklists with multiple independent Lua examples,
  different nesting depths, and different numbers of examples per group.
- **Code:** Lua configuration, safe file reading, retries, bounded caching,
  setting parsing, statistics, queues, and Neovim integration. Blocks contain
  roughly 13–24 code lines, not thousands of repeated assignments.
- **Tables:** six columns, left/center/right alignment, short and long cells,
  inline code, emphasis, and links. Each table has 4–18 data rows; large files
  contain many tables rather than one enormous table.
- **Sections:** a heading hierarchy covering levels 1–6, with ordinary prose
  beneath preparation, execution, failure-handling, verification, and handoff
  headings. These documents contain no indented code masquerading as prose.
- **Mixed:** a maintenance guide combining sections, tables, fenced code,
  grouped lists, and list-nested code.

The corpus is synthetic, with recurring procedures and code recipes across
different environments. It is closer to everyday document structure, but it is
not a collection of independent real-world documents or a worst-case stress
suite. The largest documents intentionally remain large while individual
constructs stay bounded. All code examples are authored for these fixtures;
external runbook URLs are illustrative.

## Updating a fixture

Preserve valid Markdown, complete fences, and list indentation. Keep six
columns in table fixtures and a range of heading levels in section fixtures.
When changing the content, update the line counts above and start a new set of
benchmark results: input SHA-256 hashes make old and new corpora incomparable.

See [performance benchmarks](../PERFORMANCE.md) for commands and measurement
limitations. Original PR #696 fixtures used different size units and very long
individual constructs; their timing results are not directly comparable.
