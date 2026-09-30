---@class render.md.bench.Runner
local M = {}

---Measure the operation itself and wait for its observable render completion.
---@param callback fun()
---@param completed fun(): boolean
---@return number
function M.measure(callback, completed)
    local start = vim.uv.hrtime()
    callback()
    assert(vim.wait(10000, completed, 1), 'benchmark render did not complete')
    vim.wait(0)
    return (vim.uv.hrtime() - start) / 1e6
end

---@param input string
---@param kind string
---@param count integer
---@return table
function M.run(input, kind, count)
    assert(count > 0, 'sample count must be positive')
    local lines = vim.fn.readfile(input)
    assert(#lines > 0, 'benchmark input must not be empty')
    local renders = 0
    local buf
    local settings = {
        debounce = 0,
        change_events = { 'TextChanged' },
        log_level = 'off',
        latex = { enabled = false },
        indent = { enabled = kind == 'section' or kind == 'mixed' },
    }
    require('render-markdown').setup(vim.tbl_deep_extend('force', settings, {
        on = {
            render = function(args)
                if args.buf == buf then
                    renders = renders + 1
                end
            end,
        },
    }))
    local function measure(callback)
        local before = renders
        return M.measure(callback, function()
            return renders > before
        end)
    end
    local initial = measure(function()
        buf = vim.api.nvim_create_buf(false, false)
        vim.api.nvim_set_current_buf(buf)
        vim.api.nvim_buf_set_name(buf, input)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].filetype = 'markdown'
    end)
    local win = vim.api.nvim_get_current_win()
    local ui = require('render-markdown.core.ui')
    local function event(name)
        vim.api.nvim_exec_autocmds(name, { buffer = buf })
    end
    local function locate(row)
        measure(function()
            vim.api.nvim_win_set_cursor(win, { row, 0 })
            vim.cmd('normal! zt')
            event('TextChanged')
        end)
    end
    local function sample(callback)
        for i = 1, 3 do
            measure(function()
                callback(i)
            end)
        end
        local result = {}
        for i = 1, count do
            result[i] = measure(function()
                callback(i + 3)
            end)
        end
        return result
    end
    local positions = {
        top = 1,
        middle = math.max(1, math.floor(#lines / 2)),
        bottom = math.max(1, #lines - vim.api.nvim_win_get_height(win) + 1),
    }
    local samples, marks = {}, {}
    for _, location in ipairs({ 'top', 'middle', 'bottom' }) do
        local row = positions[location]
        locate(row)
        samples['refresh_' .. location] = sample(function()
            event('TextChanged')
        end)
        samples['cursor_' .. location] = sample(function(i)
            vim.api.nvim_win_set_cursor(
                win,
                { math.min(#lines, row + (i % 2)), 0 }
            )
            event('CursorMoved')
        end)
        local edit_row = math.min(#lines, row + 3) - 1
        local original = lines[edit_row + 1]
        samples['edit_' .. location] = sample(function(i)
            vim.api.nvim_buf_set_lines(buf, edit_row, edit_row + 1, false, {
                original .. (i % 2 == 0 and ' ' or ''),
            })
            event('TextChanged')
        end)
        measure(function()
            vim.api.nvim_buf_set_lines(
                buf,
                edit_row,
                edit_row + 1,
                false,
                { original }
            )
            event('TextChanged')
        end)
        marks[location] = #vim.api.nvim_buf_get_extmarks(buf, ui.ns, 0, -1, {})
    end
    for _, route in ipairs({ { 'top', 'middle' }, { 'middle', 'bottom' } }) do
        local from, to = route[1], route[2]
        local result = {}
        for i = 1, count + 3 do
            locate(positions[from])
            local elapsed = measure(function()
                vim.api.nvim_win_set_cursor(win, { positions[to], 0 })
                vim.cmd('normal! zt')
                event('WinScrolled')
            end)
            if i > 3 then
                result[#result + 1] = elapsed
            end
        end
        samples['scroll_' .. from .. '_to_' .. to] = result
    end
    local result = {
        nvim = vim.fn.execute('version'):match('NVIM[^\n]+'),
        window = {
            width = vim.api.nvim_win_get_width(win),
            height = vim.api.nvim_win_get_height(win),
        },
        settings = settings,
        initial_ms = initial,
        samples = samples,
        marks = marks,
    }
    vim.api.nvim_buf_delete(buf, { force = true })
    return result
end

return M
