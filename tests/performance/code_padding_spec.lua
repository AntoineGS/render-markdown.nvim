---@module 'luassert'

local Code = require('render-markdown.render.markdown.code')
local util = require('tests.util')

describe('code padding performance', function()
    it(
        'pads blank nested rows without repeatedly searching the blank-row array',
        function()
            local contains = vim.tbl_contains
            local scans = 0
            vim.tbl_contains = function(values, value, ...)
                if debug.getinfo(2, 'f').func == Code.padding then
                    scans = scans + #values
                end
                return contains(values, value, ...)
            end
            local ok, err = pcall(function()
                util.setup.text({
                    '- Example',
                    '',
                    '  ```text',
                    '  first',
                    '',
                    '  last',
                    '  ```',
                }, {
                    debounce = 0,
                    sign = { enabled = false },
                    code = {
                        sign = false,
                        language_icon = false,
                        language_name = false,
                        border = 'none',
                    },
                })
                util.assert_screen({
                    '● Example',
                    '',
                    '',
                    '  first',
                    '',
                    '  last',
                    '',
                })
                assert.same(0, scans)
            end)
            vim.tbl_contains = contains
            assert(ok, err)
        end
    )
end)
