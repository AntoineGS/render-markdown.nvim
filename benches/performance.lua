-- Standalone offline worker. No user configuration, parser installation, or disk edits.
local root = vim.fn.getcwd()
local data = vim.fn.stdpath('data')
for _, name in ipairs({ 'nvim-treesitter', 'mini.nvim', 'mini.icons' }) do
    local paths =
        vim.fs.find(name, { path = data, type = 'directory', limit = 1 })
    if paths[1] then
        vim.opt.rtp:prepend(paths[1])
    end
end
vim.opt.rtp:prepend(data .. '/site')
vim.opt.rtp:prepend(root)
vim.o.columns = 80
-- Resizing this development Neovim's headless grid to 40 rows crashes on some
-- conceal-heavy documents. Keep the normal 80x23 window fixed across all stages.
vim.o.lines = 24
vim.o.laststatus = 0
vim.o.ruler = false
vim.o.tabstop = 4
vim.o.wrap = false
vim.cmd('redraw') -- apply the fixed benchmark window before timing
vim.cmd.runtime('plugin/render-markdown.lua')
local has_icons, icons = pcall(require, 'mini.icons')
if has_icons then
    icons.setup({})
end
for _, language in ipairs({ 'markdown', 'markdown_inline' }) do
    assert(
        pcall(vim.treesitter.language.add, language),
        language .. ' parser must already be installed'
    )
end
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(args)
        vim.treesitter.start(args.buf)
    end,
})
local input = assert(vim.env.RM_BENCH_INPUT, 'RM_BENCH_INPUT is required')
local output = assert(vim.env.RM_BENCH_OUTPUT, 'RM_BENCH_OUTPUT is required')
local result = require('benches.runner').run(
    input,
    vim.env.RM_BENCH_KIND or 'mixed',
    tonumber(vim.env.RM_BENCH_SAMPLES) or 15
)
vim.fn.writefile({ vim.json.encode(result) }, output)
vim.cmd('qa!')
