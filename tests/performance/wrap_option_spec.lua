---@module 'luassert'

local Client = require('benches.ui_client')

describe('wrapped-table option changes', function()
    local client

    local function setup()
        client = Client.new(vim.fn.getcwd())
        client:request('nvim_ui_attach', { 80, 40, { ext_linegrid = true } })
        -- OptionSet is suppressed during startup, including Plenary's runner.
        assert.is_true(vim.wait(10000, function()
            return client:lua('return vim.v.vim_did_enter') == 1
        end, 1))
        client:lua([[
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.signcolumn = 'no'
            require('render-markdown').setup({
                debounce = 0,
                anti_conceal = { enabled = false },
                win_options = { concealcursor = { rendered = 'nvic' } },
            })
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_set_current_buf(buf)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
                'BEFORE', '', '| A | B |', '| - | - |',
                '| x | one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen |',
                '', 'AFTER',
            })
            vim.bo.filetype = 'markdown'
        ]])
        assert.is_true(vim.wait(10000, function()
            return client:lua([[
                return #vim.api.nvim_buf_get_extmarks(
                    0, require('render-markdown.core.ui').ns, 0, -1, {}
                ) > 0
            ]])
        end, 1))
    end

    local function native_replacement()
        return client:lua([[
            local ns = require('render-markdown.core.ui').ns
            for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { details = true })) do
                if mark[2] == 4 and mark[4].conceal_lines then
                    return true
                end
            end
            return false
        ]])
    end

    local function following_row()
        return client:lua([[
            vim.cmd('redraw')
            return vim.fn.screenpos(0, 7, 1).row
        ]])
    end

    after_each(function()
        if client then
            client:close()
            client = nil
        end
    end)

    it('refreshes rendered rows when wrap changes without scrolling', function()
        setup()
        assert.is_false(native_replacement())
        local row = following_row()
        client:lua('vim.wo.wrap = true')
        assert.is_true(native_replacement())
        assert.same(row, following_row())
        client:lua('vim.wo.wrap = false')
        assert.is_false(native_replacement())
        assert.same(row, following_row())
    end)
end)
