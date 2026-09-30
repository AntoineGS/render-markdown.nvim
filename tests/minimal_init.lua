---@param names string[]
---@return string
local function get_path(names)
    for _, name in ipairs(names) do
        local paths = vim.fs.find(name, { path = vim.fn.stdpath('data') })
        if #paths == 1 then
            return paths[1]
        end
    end
    error(table.concat(names, ' or ') .. ' must be installed')
end

-- settings
vim.o.columns = 80
vim.o.laststatus = 0
vim.o.lines = 40
vim.o.ruler = false
vim.o.tabstop = 4
vim.o.wrap = false

-- source dependencies first
vim.opt.rtp:prepend(get_path({ 'nvim-treesitter' }))
vim.cmd.runtime('plugin/nvim-treesitter.lua')
vim.opt.rtp:prepend(get_path({ 'mini.nvim', 'mini.icons' }))

-- source this plugin
vim.opt.rtp:prepend('.')
vim.cmd.runtime('plugin/render-markdown.lua')

-- used for unit testing
vim.opt.rtp:prepend(get_path({ 'plenary.nvim' }))
vim.cmd.runtime('plugin/plenary.vim')

-- Benchmarks can verify each stage against the installed parsers without
-- downloading or changing the developer's Neovim dependencies.
if vim.env.RM_TEST_OFFLINE ~= '1' then
    require('nvim-treesitter')
        .install({ 'html', 'latex', 'markdown', 'markdown_inline', 'yaml' })
        :wait()
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('Highlighter', {}),
    pattern = 'markdown',
    callback = function(args)
        vim.treesitter.start(args.buf)
    end,
})

require('mini.icons').setup({})
