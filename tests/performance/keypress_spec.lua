---@module 'luassert'

describe('attached-UI scrolling benchmark', function()
    for _, center in ipairs({ false, true }) do
        local mapping = center and 'recentered' or 'native'
        it(mapping .. ' keys scroll tall rows by half a screen', function()
            local lines = {
                '| Fixture | Operation | Baseline | Result |',
                '| --- | --- | --- | --- |',
            }
            for _ = 1, 200 do
                lines[#lines + 1] =
                    '| table/1000 | refresh_middle | `[10.896295, 11.556458, 11.933051, 10.676041, 9.651291, 11.19259]` | `[11.713626, 11.908586, 10.153404, 10.711305, 11.356425, 10.769417]` |'
            end
            local result = require('benches.wrapped').run({
                lines = lines,
                width = 84,
                height = 42,
                samples = 2,
                row = 135,
                center = center,
            })
            assert.same({ width = 84, height = 41 }, result.window)
            for _, key in ipairs({ 'down', 'up' }) do
                assert.same(2, #result.samples[key])
                for _, sample in ipairs(result.samples[key]) do
                    assert.is_true(sample.elapsed_ms > 0)
                    assert.is_true(sample.marks > 0)
                    assert.is_true(sample.max_row_height > 1)
                    assert.is_true(sample.max_row_height < sample.scroll)
                    assert.is_true(
                        (key == 'down' and sample.viewport_delta > 0)
                            or (key == 'up' and sample.viewport_delta < 0)
                    )
                    -- A cursor cannot occupy a virtual continuation. Allow one
                    -- rendered row of rounding, not a whole page of skipped text.
                    assert.is_true(
                        math.abs(sample.screen_rows - sample.scroll)
                            <= sample.max_row_height,
                        ('%s scrolled %d screen rows; expected %d +/- %d'):format(
                            key,
                            sample.screen_rows,
                            sample.scroll,
                            sample.max_row_height
                        )
                    )
                end
            end
        end)
    end
end)
