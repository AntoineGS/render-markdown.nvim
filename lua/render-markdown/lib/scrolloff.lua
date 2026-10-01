local env = require('render-markdown.lib.env')

---@class render.md.Scrolloff
local M = {}

---@class render.md.scrolloff.Saved
---@field buf integer
---@field value integer
---@field applied integer

---@private
---@type table<integer, render.md.scrolloff.Saved>
M.cache = {}

---@private
---@type render.md.scrolloff.Saved?
M.inherited = nil

---@param win integer
---@return render.md.scrolloff.Saved?
function M.restore(win)
    local saved = M.cache[win]
    M.cache[win] = nil
    if
        saved
        and env.valid(saved.buf, win)
        and env.win.get(win, 'scrolloff') == saved.applied
    then
        env.win.set(win, 'scrolloff', saved.value)
        return saved
    end
    return nil
end

---@param buf? integer
function M.clear(buf)
    for win, saved in pairs(M.cache) do
        if not buf or saved.buf == buf then
            M.restore(win)
        end
    end
    M.inherited = nil
end

function M.leave()
    M.inherited = M.restore(env.win.current())
end

function M.split()
    -- A split copies window options before WinLeave restores the source.
    local saved = M.inherited
    local win = env.win.current()
    if saved and env.win.get(win, 'scrolloff') == saved.applied then
        env.win.set(win, 'scrolloff', saved.value)
    end
    M.inherited = nil
end

function M.enter()
    M.inherited = nil
end

---@param buf integer
---@param ranges render.md.Range[] Inclusive wrapped-table ranges.
function M.update(buf, ranges)
    if buf ~= env.buf.current() then
        return
    end
    local win = env.win.current()
    local row = vim.api.nvim_win_get_cursor(win)[1] - 1
    local inside = false
    for _, range in ipairs(ranges) do
        if row >= range[1] and row <= range[2] then
            inside = true
            break
        end
    end
    if not inside then
        M.restore(win)
        return
    end

    local value = env.win.get(win, 'scrolloff') -- preserve -1 inheritance
    local saved = M.cache[win]
    if not saved or saved.buf ~= buf or value ~= saved.applied then
        saved = { buf = buf, value = value, applied = value }
        M.cache[win] = saved
    end
    local original = saved.value >= 0 and saved.value
        or vim.api.nvim_get_option_value('scrolloff', { scope = 'global' })
    -- Native half-page motion ignores virtual lines when moving the cursor.
    -- A half-window margin makes Neovim constrain it to the scrolled viewport.
    saved.applied =
        math.max(original, math.floor(vim.api.nvim_win_get_height(win) / 2))
    env.win.set(win, 'scrolloff', saved.applied)
end

return M
