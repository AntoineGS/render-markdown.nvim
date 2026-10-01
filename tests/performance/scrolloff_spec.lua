---@module 'luassert'

local Client = require('benches.ui_client')

describe('wrapped-table scrolloff', function()
    local client

    local function scrolloff(win)
        return client:lua(
            [[
            return vim.api.nvim_get_option_value('scrolloff', {scope = 'local', win = ...})
        ]],
            { win or 0 }
        )
    end

    local function expect(value, win)
        assert.is_true(
            vim.wait(2000, function()
                return scrolloff(win) == value
            end, 1),
            ('expected scrolloff %d, got %d'):format(value, scrolloff(win))
        )
    end

    local function move(row)
        client:lua('vim.api.nvim_win_set_cursor(0, {..., 0})', { row })
    end

    before_each(function()
        client = Client.new(vim.fn.getcwd())
        client:request('nvim_ui_attach', { 84, 42, { ext_linegrid = true } })
        assert.is_true(vim.wait(10000, function()
            return client:lua('return vim.v.vim_did_enter') == 1
        end, 1))
        client:lua([[
            require('render-markdown').setup({debounce = 0, latex = {enabled = false}})
            vim.api.nvim_set_option_value('scrolloff', 7, {scope = 'global'})
            local lines = {'BEFORE', '', '| Name | Description |', '| --- | --- |'}
            for _ = 1, 20 do
                lines[#lines + 1] = '| item | one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty |'
            end
            vim.list_extend(lines, {'', 'AFTER'})
            local buf = vim.api.nvim_create_buf(false, false)
            vim.api.nvim_set_current_buf(buf)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo.filetype = 'markdown'
            vim.wo.scrolloff = 3
        ]])
        expect(3)
    end)

    after_each(function()
        if client then
            client:close()
            client = nil
        end
    end)

    it('restores on table exit or disable', function()
        move(10)
        expect(20)
        local global = client:lua([[
            return vim.api.nvim_get_option_value('scrolloff', {scope = 'global'})
        ]])
        assert.same(7, global)
        move(26)
        expect(3)
        move(10)
        expect(20)
        client:lua("require('render-markdown').disable()")
        expect(3)
    end)

    it('restores global inheritance', function()
        client:lua([[
            vim.api.nvim_set_option_value('scrolloff', -1, {scope = 'local'})
        ]])
        move(10)
        expect(20)
        move(1)
        expect(-1)
    end)

    it('does not leak the override into another buffer', function()
        local buffers = client:lua([[
            local original = vim.api.nvim_get_current_buf()
            local other = vim.api.nvim_create_buf(false, false)
            vim.api.nvim_set_current_buf(other)
            vim.wo.scrolloff = 9
            vim.api.nvim_set_current_buf(original)
            return {original, other}
        ]])
        move(10)
        expect(20)
        client:lua('vim.api.nvim_set_current_buf(...)', { buffers[2] })
        expect(9)
        client:lua('vim.api.nvim_set_current_buf(...)', { buffers[1] })
        expect(20)
        move(1)
        expect(3)
    end)

    it('restores and reapplies across split windows', function()
        move(10)
        expect(20)
        local original = client:lua('return vim.api.nvim_get_current_win()')
        local split = client:lua([[
            vim.cmd('vsplit')
            return vim.api.nvim_get_current_win()
        ]])
        expect(20)
        expect(3, original)
        client:lua('vim.api.nvim_set_current_win(...)', { original })
        expect(20, original)
        expect(3, split)
        client:lua('vim.api.nvim_set_current_win(...)', { split })
        expect(20, split)
        expect(3, original)
        move(1)
        expect(3)
    end)

    it('recomputes the half-window margin after resizing', function()
        move(10)
        expect(20)
        client:request('nvim_ui_try_resize', { 84, 62 })
        expect(30)
        move(1)
        expect(3)
    end)

    it('preserves a user option change made inside the table', function()
        move(10)
        expect(20)
        client:lua('vim.wo.scrolloff = 5')
        move(1)
        expect(5)
    end)
end)
