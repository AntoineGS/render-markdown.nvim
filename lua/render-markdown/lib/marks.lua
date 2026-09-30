local compat = require('render-markdown.lib.compat')
local log = require('render-markdown.core.log')

---@class (exact) render.md.Mark
---@field modes? render.md.Modes
---@field conceal render.md.mark.Conceal
---@field start_row integer
---@field start_col integer
---@field opts render.md.mark.Opts
---@field replace? render.md.mark.Line[]

---@alias render.md.mark.Conceal boolean|render.md.Element

---@class render.md.mark.Opts: vim.api.keyset.set_extmark
---@field virt_text? render.md.mark.Line
---@field virt_lines? render.md.mark.Line[]

---@alias render.md.mark.Line render.md.mark.Text[]

---@class (exact) render.md.mark.Text
---@field [1] string text
---@field [2] render.md.mark.Hl highlight

---@alias render.md.mark.Hl string|string[]

---@class render.md.Marks
---@field private context render.md.request.Context
---@field private update boolean
---@field private marks render.md.Mark[]
local Marks = {}
Marks.__index = Marks

---@param context render.md.request.Context
---@param update boolean
---@return render.md.Marks
function Marks.new(context, update)
    local self = setmetatable({}, Marks)
    self.context = context
    self.update = update
    self.marks = {}
    return self
end

---@return render.md.Mark[]
function Marks:get()
    return self.marks
end

---@param config render.md.base.Config
---@param conceal render.md.mark.Conceal
---@param node render.md.Node
---@param opts render.md.mark.Opts
---@return boolean
function Marks:start(config, conceal, node, opts)
    return self:add(config, conceal, node.start_row, node.start_col, opts)
end

---@param config render.md.base.Config
---@param conceal render.md.mark.Conceal
---@param node? render.md.Node
---@param opts render.md.mark.Opts
---@param offset? Range4
---@return boolean
function Marks:over(config, conceal, node, opts, offset)
    if not node then
        return false
    end
    offset = offset or { 0, 0, 0, 0 }
    local start_row = node.start_row + offset[1]
    local start_col = node.start_col + offset[2]
    opts.end_row = node.end_row + offset[3]
    opts.end_col = node.end_col + offset[4]
    return self:add(config, conceal, start_row, start_col, opts)
end

---@param config render.md.base.Config
---@param node render.md.Node
---@param lines render.md.mark.Line[]
function Marks:replace(config, node, lines)
    local continuation = {} ---@type render.md.mark.Line[]
    for i = 2, #lines do
        continuation[#continuation + 1] = lines[i]
    end
    ---@type render.md.mark.Opts
    local opts = {
        end_row = node.end_row,
        end_col = node.end_col,
    }
    local col = node.start_col
    if self.context.view.native_wrap then
        -- Concealing text does not collapse Neovim's native soft-wrap height.
        -- Keep the existing concealed-line strategy in soft-wrapped windows.
        opts.conceal_lines = ''
    else
        -- Leave a real cursor anchor per source row. Grouping concealed rows
        -- onto a later line makes native half-page movements skip whole tables.
        col = 0
        opts.conceal = ''
        opts.virt_text = lines[1]
        opts.virt_text_pos = 'overlay'
        opts.virt_lines = continuation
    end
    self:insert(config, {
        conceal = true,
        start_row = node.start_row,
        start_col = col,
        opts = opts,
        replace = lines,
    })
end

---@param config render.md.base.Config
---@param conceal render.md.mark.Conceal
---@param start_row integer
---@param start_col integer
---@param opts render.md.mark.Opts
---@return boolean
function Marks:add(config, conceal, start_row, start_col, opts)
    return self:insert(config, {
        conceal = conceal,
        start_row = start_row,
        start_col = start_col,
        opts = opts,
    })
end

---@private
---@param config render.md.base.Config
---@param mark render.md.Mark
---@return boolean
function Marks:insert(config, mark)
    mark.modes = config.render_modes
    local feature, min_version = self:validate(mark.opts)
    if feature and min_version then
        local message = feature .. ' requires neovim >= ' .. min_version
        log.add('error', 'Mark', message, mark)
        return false
    end
    log.add('trace', 'Mark', mark)
    if self.update then
        self:run_update(mark)
    end
    self.marks[#self.marks + 1] = mark
    return true
end

---@private
---@param opts render.md.mark.Opts
---@return string?, string?
function Marks:validate(opts)
    if not compat.has_10 then
        if opts.virt_text_pos == 'inline' then
            return "virt_text_pos = 'inline'", '0.10.0'
        end
        if opts.virt_text_repeat_linebreak then
            return 'virt_text_repeat_linebreak', '0.10.0'
        end
    end
    if not compat.has_11 then
        if opts.virt_text_pos == 'eol_right_align' then
            return "virt_text_pos = 'eol_right_align'", '0.11.0'
        end
        if opts.conceal_lines then
            return 'conceal_lines', '0.11.0'
        end
    end
    return nil, nil
end

---@private
---@param mark render.md.Mark
function Marks:run_update(mark)
    local row, start_col, opts = mark.start_row, mark.start_col, mark.opts
    if opts.conceal then
        local end_col = assert(opts.end_col, 'conceal requires end_col')
        self.context.highlights:add(row, {
            conceal = {
                start_col,
                end_col,
                replacement = opts.conceal,
                blocks = 1,
            },
        })
    end
    if opts.hl_group and opts.end_col then
        self.context.highlights:add(row, {
            group = {
                start_col,
                opts.end_col,
                priority = opts.priority or 4096,
                highlight = opts.hl_group,
            },
        })
    end
    if opts.virt_text_pos == 'inline' then
        self.context.inline:add(row, {
            col = start_col,
            line = opts.virt_text or {},
        })
    end
end

return Marks
