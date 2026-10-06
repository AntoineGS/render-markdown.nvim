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

### Preparation

Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

#### Required evidence

Check a page with a table, a code example, and a nested checklist.

### Handoff

Link the published artifact and identify who will verify the production deployment.
