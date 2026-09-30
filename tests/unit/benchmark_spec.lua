---@module 'luassert'

describe('benchmark timing', function()
    it('includes the operation and its scheduled completion', function()
        local runner = require('benches.runner')
        local completed = false
        local elapsed = runner.measure(function()
            vim.wait(20)
            vim.defer_fn(function()
                completed = true
            end, 10)
        end, function()
            return completed
        end)
        assert.is_true(completed)
        assert.is_true(elapsed >= 25)
    end)

    it('edits only an in-memory copy and records every operation', function()
        local runner = require('benches.runner')
        local path = vim.fn.fnamemodify('tests/data/benchmark.md', ':p')
        local before = vim.fn.readfile(path)
        local result = runner.run(path, 'mixed', 2)
        assert.same(before, vim.fn.readfile(path))
        assert.is_true(result.initial_ms > 0)
        for _, location in ipairs({ 'top', 'middle', 'bottom' }) do
            for _, operation in ipairs({ 'refresh', 'cursor', 'edit' }) do
                local samples = result.samples[operation .. '_' .. location]
                assert.same(2, #samples)
                for _, elapsed in ipairs(samples) do
                    assert.is_true(elapsed > 0)
                end
            end
            assert.is_true(result.marks[location] > 0)
        end
        assert.same(2, #result.samples.scroll_top_to_middle)
        assert.same(2, #result.samples.scroll_middle_to_bottom)
    end)
end)
