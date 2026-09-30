---@module 'luassert'

local Node = require('render-markdown.lib.node')
local util = require('tests.util')

describe('performance regressions', function()
    local sibling_count

    before_each(function()
        sibling_count = Node.sibling_count
    end)

    after_each(function()
        Node.sibling_count = sibling_count
    end)

    it(
        'renders index-independent bullets without scanning preceding siblings',
        function()
            local scans = 0
            Node.sibling_count = function(self, target, level)
                if target == 'list_item' then
                    scans = scans + 1
                end
                return sibling_count(self, target, level)
            end
            util.setup.text(
                { '- First', '- Second', '- Third' },
                { debounce = 0 }
            )
            util.assert_screen({ '● First', '● Second', '● Third' })
            assert.same(0, scans)
        end
    )

    it('preserves item indices for custom providers', function()
        util.setup.text({ '- First', '- Second', '- Third' }, {
            debounce = 0,
            bullet = {
                icons = function(ctx)
                    return tostring(ctx.index) .. '. '
                end,
            },
        })
        util.assert_screen({ '1. First', '2. Second', '3. Third' })
    end)

    it('preserves nested item-indexed icons and ordered numbering', function()
        util.setup.text(
            { '- First', '- Second', '', '1. Alpha', '1. Beta', '5. Gamma' },
            {
                debounce = 0,
                bullet = { icons = { { 'A', 'B' } } },
            }
        )
        util.assert_screen({
            'A First',
            'B Second',
            '',
            '1. Alpha',
            '2. Beta',
            '5. Gamma',
        })
    end)

    it('preserves item indices for padding providers', function()
        util.setup.text({ '- First', '- Second', '- Third' }, {
            debounce = 0,
            bullet = {
                right_pad = function(ctx)
                    return ctx.index
                end,
            },
        })
        util.assert_screen({ '●  First', '●   Second', '●    Third' })
    end)
end)
