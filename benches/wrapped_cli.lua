-- Real Ctrl-U/D benchmark for the published wide-table report, not private input.
local root = vim.fn.getcwd()
local input = root .. '/benches/results/PERFORMANCE.md'
local lines = vim.fn.readfile(input)
local count = tonumber(vim.env.RM_WRAP_SAMPLES) or 15
assert(
    count > 0 and count % 1 == 0,
    'RM_WRAP_SAMPLES must be a positive integer'
)
local result = require('benches.wrapped').run({
    root = vim.env.RM_WRAP_ROOT or root,
    lines = lines,
    samples = count,
    width = 140,
    height = 80,
    row = 464,
})
result.input = { name = 'generated PERFORMANCE.md', lines = #lines }
local output = vim.env.RM_WRAP_OUTPUT or root .. '/temp/benchmarks/wrapped.json'
vim.fn.mkdir(vim.fn.fnamemodify(output, ':h'), 'p')
vim.fn.writefile({ vim.json.encode(result) }, output)
vim.cmd('qa!')
