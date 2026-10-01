---@module 'luassert'

local util = require('tests.util')

describe('wrapped table navigation', function()
    before_each(function()
        vim.o.columns = 40
        vim.o.wrap = false
        vim.o.number = false
        vim.o.signcolumn = 'no'
        vim.o.scrolloff = 0
        vim.wo.scroll = 0
        vim.fn.winrestview({ leftcol = 0 })
    end)

    local function setup()
        local lines = { '| Name | Description |', '| --- | --- |' }
        for _ = 1, 200 do
            lines[#lines + 1] =
                '| item | one two three four five six seven eight nine ten eleven twelve thirteen fourteen |'
        end
        util.setup.text(
            lines,
            { debounce = 0, anti_conceal = { enabled = true } }
        )
        util.set_row(50, true)
    end

    it(
        'does not skip concealed table rows on a half-page cursor movement',
        function()
            setup()
            local before = vim.fn.line('.')
            local scroll = vim.wo.scroll
            vim.cmd('normal! \4zz')
            assert.is_true(vim.fn.line('.') - before <= scroll)
        end
    )

    it('keeps every wrapped row as a separate cursor anchor', function()
        setup()
        local marks = vim.api.nvim_buf_get_extmarks(
            0,
            require('render-markdown.core.ui').ns,
            0,
            -1,
            { details = true }
        )
        local anchors = {}
        for _, mark in ipairs(marks) do
            local opts = mark[4]
            assert.is_nil(opts.conceal_lines)
            if opts.virt_lines and #opts.virt_lines > 1 then
                anchors[mark[2]] = true
            end
        end
        assert.is_true(anchors[51])
        assert.is_true(anchors[52])
    end)
end)
