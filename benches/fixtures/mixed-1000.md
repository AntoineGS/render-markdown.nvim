# Platform maintenance guide

This technical guide combines procedures, inventories, task lists, and Lua examples in the order a maintainer might consult them.

## Bootstrap a workstation (local development)

Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

### Scope and ownership

The developer experience team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Keep the change small.

#### Required evidence

Verify the executable on PATH matches the documented version.

Keep a short record of the starting state and the command used to inspect it.
This makes the review useful even when a later deployment changes the defaults.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

### Handoff

Record whether bootstrap a workstation is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Review a configuration change (local development)

Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Review a configuration change** | Editor tooling | In review | 8.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-2` | Deploy the documentation site | Documentation | `disabled` | 21.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-3` | **Rotate an API credential** | Security | Needs follow-up | 34.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Warm the application cache | Application platform | Verified | 47.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-5` | **Inspect a failed background job** | Data operations | Scheduled | 60.0 | Retain the job identifier when reporting an error to another team. |

The latency column describes the local development rehearsal, not a service-level guarantee. Compare the effective configuration with the checked-in defaults.

## Deploy the documentation site (local development)

Retry a transient failure. Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

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

## Rotate an API credential (local development)

Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

- Confirm ownership.
  - Never paste credentials into logs, terminal recordings, or bug reports.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
  - Stop if the affected owner cannot confirm the maintenance window.
    - Treat missing evidence as an unresolved task, not an implicit success.
- Capture the current state: Include a short reproduction.
- Check dependencies.
- Prepare a rollback: Keep the change small.
  - Never paste credentials into logs, terminal recordings, or bug reports.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
- Exercise the happy path.
- Exercise a denied action: Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

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

Locate the original input, distinguish a transient failure from invalid data, and retry only work that is safe to repeat.

### Scope and ownership

The data operations team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

#### Required evidence

Retain the job identifier when reporting an error to another team.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

### Handoff

Record whether inspect a failed background job is complete, blocked, or waiting for an owner to confirm the result.

## Validate a release candidate (local development)

Run the smoke suite against the packaged artifact, not just the development checkout, and document any known limitations.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Validate a release candidate** | Release engineering | **Ready** | 43.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-2` | Restore a service backup | Reliability | In review | 56.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-3` | **Investigate slow requests** | Observability | `disabled` | 69.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Configure a development proxy | Networking | Needs follow-up | 82.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |
| `worker-5` | **Migrate a persisted setting** | Storage | Verified | 95.0 | Keep a rollback copy until the new reader has been exercised. |
| `cache-6` | Triage an editor notification | Support | Scheduled | 108.0 | `not measured` until the rehearsal finishes |
| `scheduler-7` | **Audit a dependency update** | Maintenance | **Ready** | 121.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-8` | Measure a rendering regression | Performance | In review | 134.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-9` | **Prepare an incident handoff** | Incident response | `disabled` | 147.0 | `not measured` until the rehearsal finishes |
| `notification service-10` | Export a support bundle | Privacy | Needs follow-up | 160.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Verify the version string and the included runtime dependencies.

## Restore a service backup (local development)

Debounce editor events. Restore into an isolated environment, check representative records, and measure recovery time before declaring the backup usable.

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

## Investigate slow requests (local development)

Compare median and tail latency, isolate the expensive stage, and check whether the regression occurs only under concurrency.

1. Confirm ownership.
2. Capture the current state: If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.
   - Capture the request shape without recording personal information.
   - Keep a link to the change request.
   - Use a read-only check first.

   Capture the request shape without recording personal information. Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

3. Check dependencies.
4. Prepare a rollback: Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.
5. Exercise the happy path.
   - Capture the request shape without recording personal information.
   - Keep a link to the change request.
     - Treat missing evidence as an unresolved task, not an implicit success.
6. Exercise a denied action: Use the same input on both revisions so the comparison remains useful.
7. Inspect diagnostics.
8. Compare the result: If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.
   - Capture the request shape without recording personal information.
   - Keep a link to the change request.
   - Use a read-only check first.
   - Write down the observed version and active settings.
   - Stop if the affected owner cannot confirm the maintenance window.
9. Publish the handoff.
10. Archive the evidence: Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.
11. Review the next step.
   - Capture the request shape without recording personal information.
   - Keep a link to the change request.
   - Use a read-only check first.
   - Write down the observed version and active settings.
     - Treat missing evidence as an unresolved task, not an implicit success.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

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

Read the old representation, validate each value, and write the new format atomically so interruption cannot leave a partial document.

### Scope and ownership

The storage team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Include a short reproduction.

#### Required evidence

Keep a rollback copy until the new reader has been exercised.

Keep a short record of the starting state and the command used to inspect it.
This makes the review useful even when a later deployment changes the defaults.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Use the same input on both revisions so the comparison remains useful.

### Handoff

Record whether migrate a persisted setting is complete, blocked, or waiting for an owner to confirm the result.

## Triage an editor notification (local development)

Collect the exact action that triggered the message, inspect the active buffer settings, and reduce the configuration to the smallest reproduction.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Triage an editor notification** | Support | Scheduled | 78.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-2` | Audit a dependency update | Maintenance | **Ready** | 91.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-3` | **Measure a rendering regression** | Performance | In review | 104.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Prepare an incident handoff | Incident response | `disabled` | 117.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-5` | **Export a support bundle** | Privacy | Needs follow-up | 130.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-6` | Schedule a maintenance window | Operations | Verified | 143.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Test an offline workflow** | Quality engineering | Scheduled | 156.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-8` | Tune a queue consumer | Messaging | **Ready** | 169.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-9` | **Verify an access policy** | Identity | In review | 182.0 | `not measured` until the rehearsal finishes |
| `scheduler-10` | Publish a compatibility note | Community | `disabled` | 195.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-11` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 208.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-12` | Check a search index | Search | Verified | 221.0 | `not measured` until the rehearsal finishes |
| `notification service-13` | **Review a feature rollout** | Product platform | Scheduled | 234.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-14` | Bootstrap a workstation | Developer experience | **Ready** | 7.0 | Verify the executable on PATH matches the documented version. |
| `gateway-15` | **Review a configuration change** | Editor tooling | In review | 20.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Include the editor version and the relevant plugin revision.

## Audit a dependency update (local development)

Retry a transient failure. Read the release notes, compare configuration defaults, and run representative documents through the updated parser before publishing.

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

## Measure a rendering regression (local development)

Use the same document and viewport on both revisions, keep raw timings, and report regressions as well as improvements.

- [x] Confirm ownership.
- [ ] Capture the current state: Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.
- [ ] Check dependencies.
  - Separate cold attachment from warm edits and scrolling.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
  - Stop if the affected owner cannot confirm the maintenance window.
    - Treat missing evidence as an unresolved task, not an implicit success.
- [x] Prepare a rollback: Include a short reproduction.
- [ ] Exercise the happy path.
- [ ] Exercise a denied action: Keep the change small.
  - Separate cold attachment from warm edits and scrolling.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
- [x] Inspect diagnostics.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

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

Collect only the required diagnostic fields, redact private paths, and inspect the archive before sharing it outside the team.

### Scope and ownership

The privacy team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

#### Required evidence

Exclude document contents unless the owner explicitly approves sharing.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Keep the change small.

### Handoff

Record whether export a support bundle is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Schedule a maintenance window (local development)

Confirm ownership, list the affected integrations, and communicate the expected interruption before changing the service.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Schedule a maintenance window** | Operations | Verified | 113.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-2` | Test an offline workflow | Quality engineering | Scheduled | 126.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-3` | **Tune a queue consumer** | Messaging | **Ready** | 139.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Verify an access policy | Identity | In review | 152.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-5` | **Publish a compatibility note** | Community | `disabled` | 165.0 | Link to the migration instructions and the issue tracking the limitation. |

The latency column describes the local development rehearsal, not a service-level guarantee. Specify the rollback trigger and who can approve extending the window.

## Test an offline workflow (local development)

Debounce editor events. Disable network access and exercise a locally cached project to ensure setup does not silently depend on downloading tools.

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

Missing optional dependencies should produce actionable diagnostics.

## Tune a queue consumer (local development)

Bound concurrency, retain failed messages for inspection, and observe downstream load before increasing the worker count.

- Confirm ownership.
  - Check that retries cannot enqueue the same side effect indefinitely.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
    - Treat missing evidence as an unresolved task, not an implicit success.
- Capture the current state: Use the same input on both revisions so the comparison remains useful.

  Check that retries cannot enqueue the same side effect indefinitely. Keep the change small.

- Check dependencies.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

## Verify an access policy (local development)

- Test a permitted action and a denied action with separate identities; a successful administrator request does not prove the policy is correct.

  - Verify the implementation

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

      Use temporary test identities rather than another person’s account.

    - Validate runtime options

      ```lua
      local options = {
          service = "scheduler",
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

      Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

- Confirm the expected result before moving to the next task.

## Publish a compatibility note (local development)

Describe the supported versions, include a small working configuration, and distinguish known limitations from unsupported behavior.

### Scope and ownership

The community team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

#### Required evidence

Link to the migration instructions and the issue tracking the limitation.

Keep a short record of the starting state and the command used to inspect it.
This makes the review useful even when a later deployment changes the defaults.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

### Handoff

Record whether publish a compatibility note is complete, blocked, or waiting for an owner to confirm the result.

## Clean up a stale environment (local development)

List the resources first, confirm they are no longer referenced, and remove only the environment covered by the change request.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 148.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-2` | Check a search index | Search | Verified | 161.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-3` | **Review a feature rollout** | Product platform | Scheduled | 174.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Bootstrap a workstation | Developer experience | **Ready** | 187.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-5` | **Review a configuration change** | Editor tooling | In review | 200.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-6` | Deploy the documentation site | Documentation | `disabled` | 213.0 | `not measured` until the rehearsal finishes |
| `cache-7` | **Rotate an API credential** | Security | Needs follow-up | 226.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-8` | Warm the application cache | Application platform | Verified | 239.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-9` | **Inspect a failed background job** | Data operations | Scheduled | 12.0 | `not measured` until the rehearsal finishes |
| `exporter-10` | Validate a release candidate | Release engineering | **Ready** | 25.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Preserve state and diagnostic artifacts until ownership is confirmed.

## Check a search index (local development)

Retry a transient failure. Compare source records with indexed documents, inspect tokenization for representative queries, and repair only the affected partition.

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
    return { status = "ready", service = "exporter" }
end, 3)

assert(result, tostring(err))
```

Keep query examples short enough to inspect without exposing user data.

## Review a feature rollout (local development)

Enable the feature for a small cohort, compare error rates with the control group, and keep a fast path to disable the change.

- Confirm ownership.
- Capture the current state: Keep the change small.
  - Avoid comparing cohorts with different traffic patterns.
  - Keep a link to the change request.
- Check dependencies.
- Prepare a rollback: Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.
- Exercise the happy path.
  - Avoid comparing cohorts with different traffic patterns.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
  - Stop if the affected owner cannot confirm the maintenance window.
    - Treat missing evidence as an unresolved task, not an implicit success.
- Exercise a denied action: Include a short reproduction.
- Inspect diagnostics.
- Compare the result: Keep the change small.
  - Avoid comparing cohorts with different traffic patterns.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

# Platform maintenance guide: shared staging

## Bootstrap a workstation (shared staging)

- Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

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

    local key, value = parse_setting("timeout_ms = 1300")
    assert(key == "timeout_ms")
    assert(type(value) == "number")
    ```

    Verify the executable on PATH matches the documented version.

- Confirm the expected result before moving to the next task.

## Review a configuration change (shared staging)

Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

### Scope and ownership

The editor tooling team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Use the same input on both revisions so the comparison remains useful.

#### Required evidence

Compare the effective configuration with the checked-in defaults.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Include a short reproduction.

### Handoff

Record whether review a configuration change is complete, blocked, or waiting for an owner to confirm the result.

## Deploy the documentation site (shared staging)

Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Deploy the documentation site** | Documentation | `disabled` | 183.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-2` | Rotate an API credential | Security | Needs follow-up | 196.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-3` | **Warm the application cache** | Application platform | Verified | 209.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Inspect a failed background job | Data operations | Scheduled | 222.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-5` | **Validate a release candidate** | Release engineering | **Ready** | 235.0 | Verify the version string and the included runtime dependencies. |
| `notification service-6` | Restore a service backup | Reliability | In review | 8.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Investigate slow requests** | Observability | `disabled` | 21.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-8` | Configure a development proxy | Networking | Needs follow-up | 34.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-9` | **Migrate a persisted setting** | Storage | Verified | 47.0 | `not measured` until the rehearsal finishes |
| `cache-10` | Triage an editor notification | Support | Scheduled | 60.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-11` | **Audit a dependency update** | Maintenance | **Ready** | 73.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-12` | Measure a rendering regression | Performance | In review | 86.0 | `not measured` until the rehearsal finishes |
| `exporter-13` | **Prepare an incident handoff** | Incident response | `disabled` | 99.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-14` | Export a support bundle | Privacy | Needs follow-up | 112.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-15` | **Schedule a maintenance window** | Operations | Verified | 125.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Check a page with a table, a code example, and a nested checklist.

## Rotate an API credential (shared staging)

Debounce editor events. Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

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
    end, 100)
end

schedule_refresh(vim.api.nvim_get_current_buf())
```

Never paste credentials into logs, terminal recordings, or bug reports.

## Warm the application cache (shared staging)

Load frequently requested records gradually rather than creating a burst of concurrent calls immediately after deployment.

1. Confirm ownership.
2. Capture the current state: Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

   Record hit rate and eviction count before increasing the capacity. Include a short reproduction.

3. Check dependencies.
   - Record hit rate and eviction count before increasing the capacity.
   - Keep a link to the change request.
   - Use a read-only check first.
   - Write down the observed version and active settings.
     - Treat missing evidence as an unresolved task, not an implicit success.
4. Prepare a rollback: Use the same input on both revisions so the comparison remains useful.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

## Inspect a failed background job (shared staging)

- Locate the original input, distinguish a transient failure from invalid data, and retry only work that is safe to repeat.

  - Verify the implementation

    - Inspect the failure path

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

        Retain the job identifier when reporting an error to another team.

      - Validate runtime options

        ```lua
        local options = {
            service = "exporter",
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

        Keep the change small.

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

        Use the same input on both revisions so the comparison remains useful.

- Confirm the expected result before moving to the next task.
