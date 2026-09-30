-- A small MessagePack-RPC client which consumes (but does not render) UI events.
-- Neovim's own RPC client cannot act as an attached UI: redraw notifications
-- are not editor API methods. Use raw pipes instead of forwarding them.
local Client = {}
Client.__index = Client

---@param root string
---@return table
function Client.new(root)
    local self =
        setmetatable({ responses = {}, sequence = 0, exited = false }, Client)
    self.input = vim.uv.new_pipe(false)
    self.output = vim.uv.new_pipe(false)
    self.errors = vim.uv.new_pipe(false)
    local environment = vim.fn.environ()
    environment.RM_WRAP_ROOT = root
    local values = {}
    for key, value in pairs(environment) do
        values[#values + 1] = key .. '=' .. value
    end
    self.process = assert(vim.uv.spawn('nvim', {
        args = {
            '--clean',
            '--embed',
            '-u',
            root .. '/benches/wrapped_init.lua',
        },
        cwd = root,
        env = values,
        stdio = { self.input, self.output, self.errors },
    }, function()
        self.exited = true
    end))
    local unpacker = vim.mpack.Unpacker()
    self.output:read_start(function(err, data)
        if err then
            self.error = err
        elseif data then
            local position = 1
            while position <= #data do
                local message
                message, position = unpacker(data, position)
                if message and message[1] == 1 then
                    self.responses[message[2]] = message
                end
            end
        end
    end)
    self.errors:read_start(function() end)
    return self
end

---@param method string
---@param args table
---@return any
function Client:request(method, args)
    self.sequence = self.sequence + 1
    local id = self.sequence
    self.input:write(vim.mpack.encode({ 0, id, method, args }))
    assert(
        vim.wait(20000, function()
            return self.responses[id] ~= nil or self.exited or self.error ~= nil
        end, 1),
        method .. ' timed out'
    )
    assert(
        not self.exited and not self.error,
        'benchmark editor exited or RPC pipe failed'
    )
    local response = self.responses[id]
    self.responses[id] = nil
    assert(response[3] == vim.NIL, vim.inspect(response[3]))
    return response[4]
end

---@param code string
---@param args? table
---@return any
function Client:lua(code, args)
    return self:request('nvim_exec_lua', { code, args or {} })
end

function Client:close()
    if not self.exited then
        self.input:write(vim.mpack.encode({ 2, 'nvim_command', { 'qa!' } }))
        if
            not vim.wait(1000, function()
                return self.exited
            end, 1)
        then
            self.process:kill('sigterm')
            vim.wait(1000, function()
                return self.exited
            end, 1)
        end
    end
    for _, handle in ipairs({
        self.input,
        self.output,
        self.errors,
        self.process,
    }) do
        if not handle:is_closing() then
            handle:close()
        end
    end
end

return Client
