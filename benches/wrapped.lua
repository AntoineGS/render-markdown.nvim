local Client = require('benches.ui_client')
local M = {}

local snapshot = [=[
    vim.cmd('redraw')
    local marks = vim.api.nvim_buf_get_extmarks(0, require('render-markdown.core.ui').ns, 0, -1, {details=true})
    local virtual = 0
    for _, mark in ipairs(marks) do virtual = virtual + #(mark[4].virt_lines or {}) end
    return { renders = _G.bench_renders, row = vim.fn.line('.'), top = vim.fn.line('w0'),
        bottom = vim.fn.line('w$'), leftcol = vim.fn.winsaveview().leftcol,
        scroll = vim.wo.scroll, marks = #marks, virtual_lines = virtual,
        parses = require('render-markdown.core.ui').get(vim.api.nvim_get_current_buf()).n }
]=]

local function settled(client, before)
    local previous, stable, current = nil, 0, nil
    assert(
        vim.wait(20000, function()
            current = client:lua(snapshot)
            local signature = vim.json.encode(current)
            stable = signature == previous and stable + 1 or 0
            previous = signature
            return current.renders > before and stable >= 3
        end, 1),
        'scroll did not finish rendering'
    )
    return current
end

---@param opts table
---@return table
function M.run(opts)
    local client = Client.new(opts.root or vim.fn.getcwd())
    local ok, result = xpcall(function()
        client:request(
            'nvim_ui_attach',
            { opts.width or 140, opts.height or 80, { ext_linegrid = true } }
        )
        assert(vim.wait(10000, function()
            return client:lua('return vim.v.vim_did_enter') == 1
        end, 1))
        client:request(
            'nvim_ui_try_resize',
            { opts.width or 140, opts.height or 80 }
        )
        client:lua(
            [=[
            local lines = ...
            _G.bench_renders = 0
            require('render-markdown').setup({
                preset = 'lazy', render_modes = { 'n', 'i', 'c', 't' },
                debounce = 0, log_level = 'off', latex = { enabled = false },
                on = { render = function() _G.bench_renders = _G.bench_renders + 1 end },
            })
            vim.wo.scroll = 0
            local buf = vim.api.nvim_create_buf(false, false)
            vim.api.nvim_set_current_buf(buf)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo.filetype = 'markdown'
            vim.keymap.set('n', '<C-d>', '<C-d>zz')
            vim.keymap.set('n', '<C-u>', '<C-u>zz')
        ]=],
            { opts.lines }
        )
        settled(client, 0)
        local samples = { down = {}, up = {} }
        for _, key in ipairs({ 'down', 'up' }) do
            for i = 1, (opts.samples or 15) + 3 do
                local count = client:lua('return _G.bench_renders')
                client:lua(
                    [=[
                    vim.fn.winrestview({leftcol=0})
                    vim.api.nvim_win_set_cursor(0, { ..., 0 })
                    vim.cmd('normal! zz')
                    vim.api.nvim_exec_autocmds('TextChanged', {buffer=vim.api.nvim_get_current_buf()})
                ]=],
                    { opts.row or 464 }
                )
                local before = settled(client, count)
                local start = vim.uv.hrtime()
                client:request(
                    'nvim_input',
                    { key == 'down' and '<C-d>' or '<C-u>' }
                )
                local after = settled(client, before.renders)
                if i > 3 then
                    samples[key][#samples[key] + 1] = {
                        elapsed_ms = (vim.uv.hrtime() - start) / 1e6,
                        source_rows = math.abs(after.row - before.row),
                        from_row = before.row,
                        to_row = after.row,
                        scroll = after.scroll,
                        marks = after.marks,
                        virtual_lines = after.virtual_lines,
                        reparses = after.parses - before.parses,
                        leftcol = after.leftcol,
                    }
                end
            end
        end
        return {
            nvim = client:lua(
                "return vim.fn.execute('version'):match('NVIM[^' .. string.char(10) .. ']+')"
            ),
            window = client:lua(
                'return {width=vim.api.nvim_win_get_width(0), height=vim.api.nvim_win_get_height(0)}'
            ),
            settings = {
                preset = 'lazy',
                wrap = false,
                debounce = 0,
                highlighting = true,
                latex = false,
                anti_conceal = true,
                render_modes = { 'n', 'i', 'c', 't' },
            },
            samples = samples,
        }
    end, debug.traceback)
    client:close()
    assert(ok, result)
    return result
end

return M
