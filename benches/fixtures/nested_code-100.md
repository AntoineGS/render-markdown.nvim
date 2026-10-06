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
  - Inspect the published examples.
    - Check that syntax highlighting still recognizes Lua fences.
    - Verify that code stays inside its parent list item.
      - Inspect the deepest item at a narrow window width.
  - Check a page with a table, a code example, and a nested checklist.

- Open an internal link from the published page.
- Record any broken anchors before promoting the artifact.
- Confirm the expected result before moving to the next task.
