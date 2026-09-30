---@module 'luassert'

local util = require('tests.util')

describe('wrapped-table split safeguards', function()
    local function setup()
        vim.o.columns = 80
        vim.o.wrap = false
        vim.o.number = false
        vim.o.signcolumn = 'no'
        util.setup.text({
            'BEFORE',
            '',
            '| A | B |',
            '| - | - |',
            '| x | one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen |',
            '',
            'AFTER',
        }, { debounce = 0 })
    end

    local function native_replacement()
        local ns = require('render-markdown.core.ui').ns
        for _, mark in
            ipairs(
                vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true })
            )
        do
            if mark[2] == 4 and mark[4].conceal_lines then
                return true
            end
        end
        return false
    end

    after_each(function()
        vim.cmd('silent! only!')
    end)

    it(
        'uses the native-wrap safeguard for the shared buffer when a sibling window wraps',
        function()
            setup()
            local win = vim.api.nvim_get_current_win()
            vim.cmd('vsplit')
            vim.wo.wrap = true
            vim.api.nvim_set_current_win(win)
            require('render-markdown.core.ui').update(
                vim.api.nvim_get_current_buf(),
                win,
                'MixedWrap',
                true
            )
            vim.wait(0)
            assert.is_true(native_replacement())
        end
    )

    it(
        'invalidates cached replacements when native wrapping is toggled',
        function()
            setup()
            assert.is_false(native_replacement())
            vim.wo.wrap = true
            vim.api.nvim_exec_autocmds('WinScrolled', {})
            vim.wait(0)
            assert.is_true(native_replacement())
        end
    )
end)
