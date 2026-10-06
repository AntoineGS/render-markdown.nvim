# Implementation review checklist

These review tasks keep implementation examples inside list items. List depth and the number of examples vary with the task.

## Bootstrap a workstation (local development)

- Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

  - Validate runtime options

    ```lua
    local options = {
        service = "editor",
        timeout_ms = 1000,
        retry = { attempts = 3, delay_ms = 200 },
        features = { diagnostics = true, tracing = false },
    }

    local function validate(config)
        assert(type(config.service) == "string", "service is required")
        assert(config.timeout_ms > 0, "timeout must be positive")
        return config
    end

    return validate(options)
    ```

    Verify the executable on PATH matches the documented version.

- Confirm the expected result before moving to the next task.

## Review a configuration change (local development)

- Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

  - Verify the implementation

    - Read a document safely

      ```lua
      local function read_document(filename)
          local file, open_error = io.open(filename, "r")
          if not file then
              return nil, open_error
          end

          local content, read_error = file:read("*a")
          file:close()
          if not content then
              return nil, read_error
          end
          return content
      end

      local content, err = read_document("README.md")
      if not content then
          io.stderr:write("Unable to read document: " .. tostring(err) .. "\n")
      end
      ```

      Compare the effective configuration with the checked-in defaults.

    - Retry a transient failure

      ```lua
      local function retry(operation, attempts)
          local last_error
          for attempt = 1, attempts do
              local ok, result = pcall(operation, attempt)
              if ok then
                  return result
              end
              last_error = result
          end
          return nil, last_error
      end

      local result, err = retry(function(attempt)
          assert(attempt > 1, "temporary upstream failure")
          return { status = "ready", service = "worker" }
      end, 3)

      assert(result, tostring(err))
      ```

      Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

- Confirm the expected result before moving to the next task.

## Deploy the documentation site (local development)

- Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

  - Verify the implementation

    - Inspect the failure path

      - Retry a transient failure

        ```lua
        local function retry(operation, attempts)
            local last_error
            for attempt = 1, attempts do
                local ok, result = pcall(operation, attempt)
                if ok then
                    return result
                end
                last_error = result
            end
            return nil, last_error
        end

        local result, err = retry(function(attempt)
            assert(attempt > 1, "temporary upstream failure")
            return { status = "ready", service = "worker" }
        end, 3)

        assert(result, tostring(err))
        ```

        Check a page with a table, a code example, and a nested checklist.

      - Bound the cache

        ```lua
        local function new_cache(capacity)
            assert(capacity > 0, "capacity must be positive")
            local entries, order = {}, {}
            return {
                get = function(key)
                    return entries[key]
                end,
                put = function(key, value)
                    if entries[key] == nil then
                        order[#order + 1] = key
                    end
                    entries[key] = value
                    if #order > capacity then
                        entries[table.remove(order, 1)] = nil
                    end
                end,
            }
        end

        local cache = new_cache(20)
        cache.put("health", { service = "cache", status = "ok" })
        assert(cache.get("health").status == "ok")
        ```

        If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

      - Parse a setting

        ```lua
        local function parse_setting(line)
            local key, value = line:match("^([%w_]+)%s*=%s*(.-)%s*$")
            if not key then
                return nil, "expected key=value"
            end
            if value == "true" or value == "false" then
                value = value == "true"
            else
                value = tonumber(value) or value
            end
            return key, value
        end

        local key, value = parse_setting("timeout_ms = 1400")
        assert(key == "timeout_ms")
        assert(type(value) == "number")
        ```

        Include a short reproduction.

- Confirm the expected result before moving to the next task.

## Rotate an API credential (local development)

- Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

  - Bound the cache

    ```lua
    local function new_cache(capacity)
        assert(capacity > 0, "capacity must be positive")
        local entries, order = {}, {}
        return {
            get = function(key)
                return entries[key]
            end,
            put = function(key, value)
                if entries[key] == nil then
                    order[#order + 1] = key
                end
                entries[key] = value
                if #order > capacity then
                    entries[table.remove(order, 1)] = nil
                end
            end,
        }
    end

    local cache = new_cache(20)
    cache.put("health", { service = "cache", status = "ok" })
    assert(cache.get("health").status == "ok")
    ```

    Never paste credentials into logs, terminal recordings, or bug reports.

- Confirm the expected result before moving to the next task.

## Warm the application cache (local development)

- Load frequently requested records gradually rather than creating a burst of concurrent calls immediately after deployment.

  - Verify the implementation

    - Parse a setting

      ```lua
      local function parse_setting(line)
          local key, value = line:match("^([%w_]+)%s*=%s*(.-)%s*$")
          if not key then
              return nil, "expected key=value"
          end
          if value == "true" or value == "false" then
              value = value == "true"
          else
              value = tonumber(value) or value
          end
          return key, value
      end

      local key, value = parse_setting("timeout_ms = 1400")
      assert(key == "timeout_ms")
      assert(type(value) == "number")
      ```

      Record hit rate and eviction count before increasing the capacity.

    - Summarize latency samples

      ```lua
      local function summarize(samples)
          assert(#samples > 0, "at least one sample is required")
          local ordered = {}
          for i, value in ipairs(samples) do
              ordered[i] = value
          end
          table.sort(ordered)

          local middle = math.floor(#ordered / 2)
          local median = #ordered % 2 == 0
              and (ordered[middle] + ordered[middle + 1]) / 2
              or ordered[middle + 1]
          return { median = median, p95 = ordered[math.ceil(#ordered * 0.95)] }
      end

      local result = summarize({ 4.2, 3.8, 5.1, 4.0, 3.9 })
      print(string.format("median=%.2fms p95=%.2fms", result.median, result.p95))
      ```

      Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

- Confirm the expected result before moving to the next task.

## Inspect a failed background job (local development)

- Locate the original input, distinguish a transient failure from invalid data, and retry only work that is safe to repeat.

  - Verify the implementation

    - Inspect the failure path

      - Summarize latency samples

        ```lua
        local function summarize(samples)
            assert(#samples > 0, "at least one sample is required")
            local ordered = {}
            for i, value in ipairs(samples) do
                ordered[i] = value
            end
            table.sort(ordered)

            local middle = math.floor(#ordered / 2)
            local median = #ordered % 2 == 0
                and (ordered[middle] + ordered[middle + 1]) / 2
                or ordered[middle + 1]
            return { median = median, p95 = ordered[math.ceil(#ordered * 0.95)] }
        end

        local result = summarize({ 4.2, 3.8, 5.1, 4.0, 3.9 })
        print(string.format("median=%.2fms p95=%.2fms", result.median, result.p95))
        ```

        Retain the job identifier when reporting an error to another team.

      - Consume queued work

        ```lua
        local queue = { first = 1, last = 0, values = {} }

        local function enqueue(value)
            queue.last = queue.last + 1
            queue.values[queue.last] = value
        end

        local function dequeue()
            if queue.first > queue.last then
                return nil
            end
            local value = queue.values[queue.first]
            queue.values[queue.first] = nil
            queue.first = queue.first + 1
            return value
        end

        enqueue({ action = "refresh", service = "exporter" })
        local job = dequeue()
        assert(job and job.action == "refresh")
        assert(dequeue() == nil)
        ```

        Keep the change small.

      - Debounce editor events

        ```lua
        local pending = {}
        local function schedule_refresh(buffer)
            if pending[buffer] then
                return
            end
            pending[buffer] = true
            vim.defer_fn(function()
                pending[buffer] = nil
                if not vim.api.nvim_buf_is_valid(buffer) then
                    return
                end
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "DocumentRefresh",
                    data = { buffer = buffer },
                })
            end, 150)
        end

        schedule_refresh(vim.api.nvim_get_current_buf())
        ```

        Use the same input on both revisions so the comparison remains useful.

- Confirm the expected result before moving to the next task.

## Validate a release candidate (local development)

- Run the smoke suite against the packaged artifact, not just the development checkout, and document any known limitations.

  - Consume queued work

    ```lua
    local queue = { first = 1, last = 0, values = {} }

    local function enqueue(value)
        queue.last = queue.last + 1
        queue.values[queue.last] = value
    end

    local function dequeue()
        if queue.first > queue.last then
            return nil
        end
        local value = queue.values[queue.first]
        queue.values[queue.first] = nil
        queue.first = queue.first + 1
        return value
    end

    enqueue({ action = "refresh", service = "exporter" })
    local job = dequeue()
    assert(job and job.action == "refresh")
    assert(dequeue() == nil)
    ```

    Verify the version string and the included runtime dependencies.

- Confirm the expected result before moving to the next task.

## Restore a service backup (local development)

- Restore into an isolated environment, check representative records, and measure recovery time before declaring the backup usable.

  - Verify the implementation

    - Debounce editor events

      ```lua
      local pending = {}
      local function schedule_refresh(buffer)
          if pending[buffer] then
              return
          end
          pending[buffer] = true
          vim.defer_fn(function()
              pending[buffer] = nil
              if not vim.api.nvim_buf_is_valid(buffer) then
                  return
              end
              vim.api.nvim_exec_autocmds("User", {
                  pattern = "DocumentRefresh",
                  data = { buffer = buffer },
              })
          end, 150)
      end

      schedule_refresh(vim.api.nvim_get_current_buf())
      ```

      Do not overwrite the production dataset during a recovery exercise.

    - Discover Markdown documents

      ```lua
      local function collect_markdown(directory)
          local documents = {}
          for name, kind in vim.fs.dir(directory) do
              if kind == "file" and name:match("%.md$") then
                  documents[#documents + 1] = vim.fs.joinpath(directory, name)
              end
          end
          table.sort(documents)
          return documents
      end

      for _, filename in ipairs(collect_markdown("docs")) do
          local lines = vim.fn.readfile(filename)
          print(string.format("%s: %d lines", filename, #lines))
      end
      ```

      Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

- Confirm the expected result before moving to the next task.

## Investigate slow requests (local development)

- Compare median and tail latency, isolate the expensive stage, and check whether the regression occurs only under concurrency.

  - Verify the implementation

    - Inspect the failure path

      - Discover Markdown documents

        ```lua
        local function collect_markdown(directory)
            local documents = {}
            for name, kind in vim.fs.dir(directory) do
                if kind == "file" and name:match("%.md$") then
                    documents[#documents + 1] = vim.fs.joinpath(directory, name)
                end
            end
            table.sort(documents)
            return documents
        end

        for _, filename in ipairs(collect_markdown("docs")) do
            local lines = vim.fn.readfile(filename)
            print(string.format("%s: %d lines", filename, #lines))
        end
        ```

        Capture the request shape without recording personal information.

      - Merge configuration defaults

        ```lua
        local function merge_defaults(defaults, overrides)
            local result = {}
            for key, value in pairs(defaults) do
                result[key] = value
            end
            for key, value in pairs(overrides) do
                assert(defaults[key] ~= nil, "unknown option: " .. key)
                result[key] = value
            end
            return result
        end

        local config = merge_defaults({ timeout_ms = 1000, enabled = true }, {
            timeout_ms = 2300,
        })
        assert(config.enabled)
        print(config.timeout_ms)
        ```

        If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

      - Validate runtime options

        ```lua
        local options = {
            service = "worker",
            timeout_ms = 2000,
            retry = { attempts = 3, delay_ms = 200 },
            features = { diagnostics = true, tracing = false },
        }

        local function validate(config)
            assert(type(config.service) == "string", "service is required")
            assert(config.timeout_ms > 0, "timeout must be positive")
            return config
        end

        return validate(options)
        ```

        Include a short reproduction.

- Confirm the expected result before moving to the next task.

## Configure a development proxy (local development)

- Bind the listener to the local interface, preserve the original request headers, and make upstream failures visible to the caller.

  - Merge configuration defaults

    ```lua
    local function merge_defaults(defaults, overrides)
        local result = {}
        for key, value in pairs(defaults) do
            result[key] = value
        end
        for key, value in pairs(overrides) do
            assert(defaults[key] ~= nil, "unknown option: " .. key)
            result[key] = value
        end
        return result
    end

    local config = merge_defaults({ timeout_ms = 1000, enabled = true }, {
        timeout_ms = 2300,
    })
    assert(config.enabled)
    print(config.timeout_ms)
    ```

    Confirm the proxy does not accidentally expose a private service.

- Confirm the expected result before moving to the next task.

## Migrate a persisted setting (local development)

- Read the old representation, validate each value, and write the new format atomically so interruption cannot leave a partial document.

  - Verify the implementation

    - Validate runtime options

      ```lua
      local options = {
          service = "worker",
          timeout_ms = 2000,
          retry = { attempts = 3, delay_ms = 200 },
          features = { diagnostics = true, tracing = false },
      }

      local function validate(config)
          assert(type(config.service) == "string", "service is required")
          assert(config.timeout_ms > 0, "timeout must be positive")
          return config
      end

      return validate(options)
      ```

      Keep a rollback copy until the new reader has been exercised.

    - Read a document safely

      ```lua
      local function read_document(filename)
          local file, open_error = io.open(filename, "r")
          if not file then
              return nil, open_error
          end

          local content, read_error = file:read("*a")
          file:close()
          if not content then
              return nil, read_error
          end
          return content
      end

      local content, err = read_document("README.md")
      if not content then
          io.stderr:write("Unable to read document: " .. tostring(err) .. "\n")
      end
      ```

      Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

- Confirm the expected result before moving to the next task.

## Triage an editor notification (local development)

- Collect the exact action that triggered the message, inspect the active buffer settings, and reduce the configuration to the smallest reproduction.

  - Verify the implementation

    - Inspect the failure path

      - Read a document safely

        ```lua
        local function read_document(filename)
            local file, open_error = io.open(filename, "r")
            if not file then
                return nil, open_error
            end

            local content, read_error = file:read("*a")
            file:close()
            if not content then
                return nil, read_error
            end
            return content
        end

        local content, err = read_document("README.md")
        if not content then
            io.stderr:write("Unable to read document: " .. tostring(err) .. "\n")
        end
        ```

        Include the editor version and the relevant plugin revision.

      - Retry a transient failure

        ```lua
        local function retry(operation, attempts)
            local last_error
            for attempt = 1, attempts do
                local ok, result = pcall(operation, attempt)
                if ok then
                    return result
                end
                last_error = result
            end
            return nil, last_error
        end

        local result, err = retry(function(attempt)
            assert(attempt > 1, "temporary upstream failure")
            return { status = "ready", service = "scheduler" }
        end, 3)

        assert(result, tostring(err))
        ```

        Keep the change small.

      - Bound the cache

        ```lua
        local function new_cache(capacity)
            assert(capacity > 0, "capacity must be positive")
            local entries, order = {}, {}
            return {
                get = function(key)
                    return entries[key]
                end,
                put = function(key, value)
                    if entries[key] == nil then
                        order[#order + 1] = key
                    end
                    entries[key] = value
                    if #order > capacity then
                        entries[table.remove(order, 1)] = nil
                    end
                end,
            }
        end

        local cache = new_cache(20)
        cache.put("health", { service = "indexer", status = "ok" })
        assert(cache.get("health").status == "ok")
        ```

        Use the same input on both revisions so the comparison remains useful.

- Confirm the expected result before moving to the next task.

## Audit a dependency update (local development)

- Read the release notes, compare configuration defaults, and run representative documents through the updated parser before publishing.

  - Retry a transient failure

    ```lua
    local function retry(operation, attempts)
        local last_error
        for attempt = 1, attempts do
            local ok, result = pcall(operation, attempt)
            if ok then
                return result
            end
            last_error = result
        end
        return nil, last_error
    end

    local result, err = retry(function(attempt)
        assert(attempt > 1, "temporary upstream failure")
        return { status = "ready", service = "scheduler" }
    end, 3)

    assert(result, tostring(err))
    ```

    Pin the previous version so the rollout can be reversed quickly.

- Confirm the expected result before moving to the next task.

## Measure a rendering regression (local development)

- Use the same document and viewport on both revisions, keep raw timings, and report regressions as well as improvements.

  - Verify the implementation

    - Bound the cache

      ```lua
      local function new_cache(capacity)
          assert(capacity > 0, "capacity must be positive")
          local entries, order = {}, {}
          return {
              get = function(key)
                  return entries[key]
              end,
              put = function(key, value)
                  if entries[key] == nil then
                      order[#order + 1] = key
                  end
                  entries[key] = value
                  if #order > capacity then
                      entries[table.remove(order, 1)] = nil
                  end
              end,
          }
      end

      local cache = new_cache(20)
      cache.put("health", { service = "indexer", status = "ok" })
      assert(cache.get("health").status == "ok")
      ```

      Separate cold attachment from warm edits and scrolling.

    - Parse a setting

      ```lua
      local function parse_setting(line)
          local key, value = line:match("^([%w_]+)%s*=%s*(.-)%s*$")
          if not key then
              return nil, "expected key=value"
          end
          if value == "true" or value == "false" then
              value = value == "true"
          else
              value = tonumber(value) or value
          end
          return key, value
      end

      local key, value = parse_setting("timeout_ms = 1000")
      assert(key == "timeout_ms")
      assert(type(value) == "number")
      ```

      Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

- Confirm the expected result before moving to the next task.

## Prepare an incident handoff (local development)

- Summarize the impact, list the actions already taken, and identify the next safe experiment instead of asking the next responder to restart the investigation.

  - Verify the implementation

    - Inspect the failure path

      - Parse a setting

        ```lua
        local function parse_setting(line)
            local key, value = line:match("^([%w_]+)%s*=%s*(.-)%s*$")
            if not key then
                return nil, "expected key=value"
            end
            if value == "true" or value == "false" then
                value = value == "true"
            else
                value = tonumber(value) or value
            end
            return key, value
        end

        local key, value = parse_setting("timeout_ms = 1000")
        assert(key == "timeout_ms")
        assert(type(value) == "number")
        ```

        Link the timeline and note which mitigation is still active.

      - Summarize latency samples

        ```lua
        local function summarize(samples)
            assert(#samples > 0, "at least one sample is required")
            local ordered = {}
            for i, value in ipairs(samples) do
                ordered[i] = value
            end
            table.sort(ordered)

            local middle = math.floor(#ordered / 2)
            local median = #ordered % 2 == 0
                and (ordered[middle] + ordered[middle + 1]) / 2
                or ordered[middle + 1]
            return { median = median, p95 = ordered[math.ceil(#ordered * 0.95)] }
        end

        local result = summarize({ 4.2, 3.8, 5.1, 4.0, 3.9 })
        print(string.format("median=%.2fms p95=%.2fms", result.median, result.p95))
        ```

        If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

      - Consume queued work

        ```lua
        local queue = { first = 1, last = 0, values = {} }

        local function enqueue(value)
            queue.last = queue.last + 1
            queue.values[queue.last] = value
        end

        local function dequeue()
            if queue.first > queue.last then
                return nil
            end
            local value = queue.values[queue.first]
            queue.values[queue.first] = nil
            queue.first = queue.first + 1
            return value
        end

        enqueue({ action = "refresh", service = "editor" })
        local job = dequeue()
        assert(job and job.action == "refresh")
        assert(dequeue() == nil)
        ```

        Include a short reproduction.

- Confirm the expected result before moving to the next task.

## Export a support bundle (local development)

- Collect only the required diagnostic fields, redact private paths, and inspect the archive before sharing it outside the team.

  - Summarize latency samples

    ```lua
    local function summarize(samples)
        assert(#samples > 0, "at least one sample is required")
        local ordered = {}
        for i, value in ipairs(samples) do
            ordered[i] = value
        end
        table.sort(ordered)

        local middle = math.floor(#ordered / 2)
        local median = #ordered % 2 == 0
            and (ordered[middle] + ordered[middle + 1]) / 2
            or ordered[middle + 1]
        return { median = median, p95 = ordered[math.ceil(#ordered * 0.95)] }
    end

    local result = summarize({ 4.2, 3.8, 5.1, 4.0, 3.9 })
    print(string.format("median=%.2fms p95=%.2fms", result.median, result.p95))
    ```

    Exclude document contents unless the owner explicitly approves sharing.

- Confirm the expected result before moving to the next task.

## Schedule a maintenance window (local development)

- Confirm ownership, list the affected integrations, and communicate the expected interruption before changing the service.

  - Verify the implementation

    - Consume queued work

      ```lua
      local queue = { first = 1, last = 0, values = {} }

      local function enqueue(value)
          queue.last = queue.last + 1
          queue.values[queue.last] = value
      end

      local function dequeue()
          if queue.first > queue.last then
              return nil
          end
          local value = queue.values[queue.first]
          queue.values[queue.first] = nil
          queue.first = queue.first + 1
          return value
      end

      enqueue({ action = "refresh", service = "editor" })
      local job = dequeue()
      assert(job and job.action == "refresh")
      assert(dequeue() == nil)
      ```

      Specify the rollback trigger and who can approve extending the window.

    - Debounce editor events

      ```lua
      local pending = {}
      local function schedule_refresh(buffer)
          if pending[buffer] then
              return
          end
          pending[buffer] = true
          vim.defer_fn(function()
              pending[buffer] = nil
              if not vim.api.nvim_buf_is_valid(buffer) then
                  return
              end
              vim.api.nvim_exec_autocmds("User", {
                  pattern = "DocumentRefresh",
                  data = { buffer = buffer },
              })
          end, 200)
      end

      schedule_refresh(vim.api.nvim_get_current_buf())
      ```

      Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

- Confirm the expected result before moving to the next task.
