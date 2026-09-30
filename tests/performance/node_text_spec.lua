---@module 'luassert'

local Node = require('render-markdown.lib.node')
local util = require('tests.util')

describe('node text performance', function()
    local get_text
    local new_node

    before_each(function()
        get_text = vim.treesitter.get_node_text
        new_node = Node.new
    end)

    after_each(function()
        vim.treesitter.get_node_text = get_text
        Node.new = new_node
    end)

    it('reads text only on demand and caches the extracted value', function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '# Title', '', 'Body' })
        local root =
            vim.treesitter.get_parser(buf, 'markdown'):parse()[1]:root()
        local reads = 0
        vim.treesitter.get_node_text = function(...)
            reads = reads + 1
            return get_text(...)
        end
        local node = Node.new(buf, root)
        assert.same('document', node.type)
        assert.same(0, node.start_row)
        assert.same(0, reads)
        assert.is_true(node.text:find('Body', 1, true) ~= nil)
        local text = node.text
        assert.same(text, node.text)
        assert.same(1, reads)
    end)

    it(
        'does not extract query-capture text solely for disabled trace logging',
        function()
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(
                buf,
                0,
                -1,
                false,
                { '# Title', '', 'Body' }
            )
            local root =
                vim.treesitter.get_parser(buf, 'markdown'):parse()[1]:root()
            local reads = 0
            vim.treesitter.get_node_text = function(...)
                reads = reads + 1
                return get_text(...)
            end
            require('render-markdown').setup({ log_level = 'off' })
            local node = Node.new(buf, root)
            require('render-markdown.core.log').node('document', node)
            assert.same(0, reads)
        end
    )

    it('still extracts node text when trace logging is enabled', function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '# Title' })
        local root =
            vim.treesitter.get_parser(buf, 'markdown'):parse()[1]:root()
        local reads = 0
        vim.treesitter.get_node_text = function(...)
            reads = reads + 1
            return get_text(...)
        end
        local state = require('render-markdown.state')
        local level = state.log_level
        state.log_level = 'trace'
        require('render-markdown.core.log').node(
            'document',
            Node.new(buf, root)
        )
        state.log_level = level
        assert.same(1, reads)
    end)

    it(
        'filters offscreen table rows before allocating their wrappers',
        function()
            local wraps = 0
            Node.new = function(buf, node)
                if node:type() == 'pipe_table_row' and node:range() > 100 then
                    wraps = wraps + 1
                end
                return new_node(buf, node)
            end
            local lines = { '| A | B |', '| - | - |' }
            for _ = 1, 300 do
                lines[#lines + 1] = '| x | y |'
            end
            util.setup.text(lines, { debounce = 0 })
            assert.same(0, wraps)
        end
    )
end)
