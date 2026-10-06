# Operations task notebook

Use these grouped tasks during development, release rehearsal, and incident handoff. Groups include ordered steps, checkboxes, and nested notes.

## Bootstrap a workstation (local development)

Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

1. Confirm ownership.
   - Verify the executable on PATH matches the documented version.
   - Keep a link to the change request.
     - Treat missing evidence as an unresolved task, not an implicit success.
2. Capture the current state: Use the same input on both revisions so the comparison remains useful.

   Verify the executable on PATH matches the documented version. Keep the change small.

3. Check dependencies.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

## Review a configuration change (local development)

Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

- [x] Confirm ownership.
- [ ] Capture the current state: Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.
- [ ] Check dependencies.
  - Compare the effective configuration with the checked-in defaults.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
  - Stop if the affected owner cannot confirm the maintenance window.
    - Treat missing evidence as an unresolved task, not an implicit success.
- [x] Prepare a rollback: Include a short reproduction.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

## Deploy the documentation site (local development)

Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

- Confirm ownership.
- Capture the current state: If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.
  - Check a page with a table, a code example, and a nested checklist.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
  - Stop if the affected owner cannot confirm the maintenance window.

  Check a page with a table, a code example, and a nested checklist. Record the expected outcome before running the command; a successful exit code alone does not establish that the requested behavior occurred.

- Check dependencies.
- Prepare a rollback: Prefer a reversible change and confirm that the rollback can be performed with the credentials available during the maintenance window.
- Exercise the happy path.
  - Check a page with a table, a code example, and a nested checklist.
  - Keep a link to the change request.
  - Use a read-only check first.
  - Write down the observed version and active settings.
    - Treat missing evidence as an unresolved task, not an implicit success.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.

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
5. Exercise the happy path.
6. Exercise a denied action: If a dependency is unavailable, stop and explain what is missing instead of silently substituting a different tool or downloading an unreviewed package.
   - Record hit rate and eviction count before increasing the capacity.
   - Keep a link to the change request.
   - Use a read-only check first.
7. Inspect diagnostics.

Review the unchecked items at handoff; completed tasks should retain enough context to explain what was verified.
