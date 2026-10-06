# Engineering operations handbook

Procedures are organized into sections, subsections, and detailed failure-handling notes. Body text is ordinary Markdown prose, not indented code.

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

## Deploy the documentation site (local development)

Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

### Scope and ownership

The documentation team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

#### Required evidence

Check a page with a table, a code example, and a nested checklist.

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

Record whether deploy the documentation site is complete, blocked, or waiting for an owner to confirm the result.

## Rotate an API credential (local development)

Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

### Scope and ownership

The security team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

#### Required evidence

Never paste credentials into logs, terminal recordings, or bug reports.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Keep the change small.

### Handoff

Record whether rotate an api credential is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Warm the application cache (local development)

Load frequently requested records gradually rather than creating a burst of concurrent calls immediately after deployment.

### Scope and ownership

The application platform team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Include a short reproduction.

#### Required evidence

Record hit rate and eviction count before increasing the capacity.

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

Record whether warm the application cache is complete, blocked, or waiting for an owner to confirm the result.

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

### Scope and ownership

The release engineering team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Keep the change small.

#### Required evidence

Verify the version string and the included runtime dependencies.

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

Record whether validate a release candidate is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Restore a service backup (local development)

Restore into an isolated environment, check representative records, and measure recovery time before declaring the backup usable.

### Scope and ownership

The reliability team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Use the same input on both revisions so the comparison remains useful.

#### Required evidence

Do not overwrite the production dataset during a recovery exercise.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Include a short reproduction.

### Handoff

Record whether restore a service backup is complete, blocked, or waiting for an owner to confirm the result.

## Investigate slow requests (local development)

Compare median and tail latency, isolate the expensive stage, and check whether the regression occurs only under concurrency.

### Scope and ownership

The observability team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

#### Required evidence

Capture the request shape without recording personal information.

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

Record whether investigate slow requests is complete, blocked, or waiting for an owner to confirm the result.

## Configure a development proxy (local development)

Bind the listener to the local interface, preserve the original request headers, and make upstream failures visible to the caller.

### Scope and ownership

The networking team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

#### Required evidence

Confirm the proxy does not accidentally expose a private service.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Keep the change small.

### Handoff

Record whether configure a development proxy is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

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

### Scope and ownership

The support team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

#### Required evidence

Include the editor version and the relevant plugin revision.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

### Handoff

Record whether triage an editor notification is complete, blocked, or waiting for an owner to confirm the result.

## Audit a dependency update (local development)

Read the release notes, compare configuration defaults, and run representative documents through the updated parser before publishing.

### Scope and ownership

The maintenance team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Keep the change small.

#### Required evidence

Pin the previous version so the rollout can be reversed quickly.

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

Record whether audit a dependency update is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Measure a rendering regression (local development)

Use the same document and viewport on both revisions, keep raw timings, and report regressions as well as improvements.

### Scope and ownership

The performance team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Use the same input on both revisions so the comparison remains useful.

#### Required evidence

Separate cold attachment from warm edits and scrolling.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Include a short reproduction.

### Handoff

Record whether measure a rendering regression is complete, blocked, or waiting for an owner to confirm the result.

## Prepare an incident handoff (local development)

Summarize the impact, list the actions already taken, and identify the next safe experiment instead of asking the next responder to restart the investigation.

### Scope and ownership

The incident response team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

#### Required evidence

Link the timeline and note which mitigation is still active.

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

Record whether prepare an incident handoff is complete, blocked, or waiting for an owner to confirm the result.

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

### Scope and ownership

The operations team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Include a short reproduction.

#### Required evidence

Specify the rollback trigger and who can approve extending the window.

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

Record whether schedule a maintenance window is complete, blocked, or waiting for an owner to confirm the result.

## Test an offline workflow (local development)

Disable network access and exercise a locally cached project to ensure setup does not silently depend on downloading tools.

### Scope and ownership

The quality engineering team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

#### Required evidence

Missing optional dependencies should produce actionable diagnostics.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

### Handoff

Record whether test an offline workflow is complete, blocked, or waiting for an owner to confirm the result.

## Tune a queue consumer (local development)

Bound concurrency, retain failed messages for inspection, and observe downstream load before increasing the worker count.

### Scope and ownership

The messaging team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Keep the change small.

#### Required evidence

Check that retries cannot enqueue the same side effect indefinitely.

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

Record whether tune a queue consumer is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Verify an access policy (local development)

Test a permitted action and a denied action with separate identities; a successful administrator request does not prove the policy is correct.

### Scope and ownership

The identity team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Use the same input on both revisions so the comparison remains useful.

#### Required evidence

Use temporary test identities rather than another person’s account.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Include a short reproduction.

### Handoff

Record whether verify an access policy is complete, blocked, or waiting for an owner to confirm the result.

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

### Scope and ownership

The infrastructure team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.

#### Required evidence

Preserve state and diagnostic artifacts until ownership is confirmed.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Keep the change small.

### Handoff

Record whether clean up a stale environment is complete, blocked, or waiting for an owner to confirm the result.

### Follow-up

Link the remaining work to the change request and identify the person who can safely resume it.

## Check a search index (local development)

Compare source records with indexed documents, inspect tokenization for representative queries, and repair only the affected partition.

### Scope and ownership

The search team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Include a short reproduction.

#### Required evidence

Keep query examples short enough to inspect without exposing user data.

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

Record whether check a search index is complete, blocked, or waiting for an owner to confirm the result.

## Review a feature rollout (local development)

Enable the feature for a small cohort, compare error rates with the control group, and keep a fast path to disable the change.

### Scope and ownership

The product platform team owns this procedure. Confirm the target environment before changing shared state.

### Preparation

Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.

#### Required evidence

Avoid comparing cohorts with different traffic patterns.

#### Execution

Apply one change at a time and compare the observed result with the expected behavior.

##### Failure handling

If the check fails, preserve the diagnostic message and stop before attempting a broader change.

###### Rollback boundary

Revert only the change covered by this procedure. Do not remove unrelated work or private configuration.

##### Verification

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

### Handoff

Record whether review a feature rollout is complete, blocked, or waiting for an owner to confirm the result.

# Engineering operations handbook: shared staging

## Bootstrap a workstation (shared staging)

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
