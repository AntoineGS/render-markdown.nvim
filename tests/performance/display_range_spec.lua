---@module 'luassert'

local env = require('render-markdown.lib.env')
local util = require('tests.util')

describe('display-aware viewport ranges', function()
    before_each(function()
        vim.o.columns = 40
        vim.o.wrap = false
        vim.o.number = false
        vim.o.signcolumn = 'no'
        vim.o.scrolloff = 0
        vim.fn.winrestview({ leftcol = 0 })
    end)

    it(
        'counts the displayed wrapped-table viewport rather than window-height buffer rows',
        function()
            local lines = { '| A | B |', '| - | - |' }
            for _ = 1, 200 do
                lines[#lines + 1] =
                    '| x | one two three four five six seven eight nine ten eleven twelve thirteen fourteen |'
            end
            util.setup.text(lines, { debounce = 0 })
            util.set_row(50, true)
            vim.cmd('redraw')
            local range = env.range(
                vim.api.nvim_get_current_buf(),
                vim.api.nvim_get_current_win(),
                0
            )
            assert.same(vim.fn.line('w$'), range[2])
            assert.is_true(range[2] - range[1] < 20)
        end
    )

    it(
        'accounts for native soft wrapping even without table decorations',
        function()
            vim.o.wrap = true
            local lines = {}
            for _ = 1, 100 do
                lines[#lines + 1] = ('x'):rep(120)
            end
            util.setup.text(lines, { enabled = false })
            vim.cmd('redraw')
            local range = env.range(
                vim.api.nvim_get_current_buf(),
                vim.api.nvim_get_current_win(),
                0
            )
            assert.same(vim.fn.line('w$'), range[2])
            assert.is_true(range[2] < 20)
        end
    )

    it(
        'keeps overscan on ordinary rows and clips at the end of the buffer',
        function()
            local lines = {}
            for _ = 1, 100 do
                lines[#lines + 1] = 'short'
            end
            util.setup.text(lines, { enabled = false })
            vim.cmd('normal! 30Gzt')
            assert.same(
                { 19, 78 },
                env.range(
                    vim.api.nvim_get_current_buf(),
                    vim.api.nvim_get_current_win(),
                    10
                )
            )
            vim.cmd('normal! Gzt')
            assert.same(
                100,
                env.range(
                    vim.api.nvim_get_current_buf(),
                    vim.api.nvim_get_current_win(),
                    10
                )[2]
            )
        end
    )
end)
