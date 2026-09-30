-- Offline attached-UI initialization, without the user's config or installations.
local data = vim.fn.stdpath('data')
for _, name in ipairs({ 'nvim-treesitter', 'mini.nvim', 'mini.icons' }) do
    local paths =
        vim.fs.find(name, { path = data, type = 'directory', limit = 1 })
    if paths[1] then
        vim.opt.rtp:prepend(paths[1])
    end
end
vim.opt.rtp:prepend(data .. '/site')
vim.opt.rtp:prepend(assert(vim.env.RM_WRAP_ROOT))
vim.cmd.runtime('plugin/render-markdown.lua')
local ok, icons = pcall(require, 'mini.icons')
if ok then
    icons.setup({})
end
vim.o.laststatus = 0
vim.o.cmdheight = 1
vim.o.ruler = false
vim.o.wrap = false
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.scrolloff = 0
vim.o.swapfile = false
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(args)
        vim.treesitter.start(args.buf)
    end,
})
