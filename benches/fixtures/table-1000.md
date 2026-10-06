# Service readiness inventory

Review component ownership, readiness, and representative latency measurements. Each bounded table has six columns with mixed formatting and alignment.

## Bootstrap a workstation (local development)

Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Bootstrap a workstation** | Developer experience | **Ready** | 1.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-2` | Review a configuration change | Editor tooling | In review | 14.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-3` | **Deploy the documentation site** | Documentation | `disabled` | 27.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Rotate an API credential | Security | Needs follow-up | 40.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Verify the executable on PATH matches the documented version.

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

Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Deploy the documentation site** | Documentation | `disabled` | 15.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-2` | Rotate an API credential | Security | Needs follow-up | 28.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-3` | **Warm the application cache** | Application platform | Verified | 41.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Inspect a failed background job | Data operations | Scheduled | 54.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-5` | **Validate a release candidate** | Release engineering | **Ready** | 67.0 | Verify the version string and the included runtime dependencies. |
| `notification service-6` | Restore a service backup | Reliability | In review | 80.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Check a page with a table, a code example, and a nested checklist.

## Rotate an API credential (local development)

Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Rotate an API credential** | Security | Needs follow-up | 22.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-2` | Warm the application cache | Application platform | Verified | 35.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-3` | **Inspect a failed background job** | Data operations | Scheduled | 48.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Validate a release candidate | Release engineering | **Ready** | 61.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-5` | **Restore a service backup** | Reliability | In review | 74.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-6` | Investigate slow requests | Observability | `disabled` | 87.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Configure a development proxy** | Networking | Needs follow-up | 100.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Never paste credentials into logs, terminal recordings, or bug reports.

## Warm the application cache (local development)

Load frequently requested records gradually rather than creating a burst of concurrent calls immediately after deployment.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Warm the application cache** | Application platform | Verified | 29.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-2` | Inspect a failed background job | Data operations | Scheduled | 42.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-3` | **Validate a release candidate** | Release engineering | **Ready** | 55.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Restore a service backup | Reliability | In review | 68.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-5` | **Investigate slow requests** | Observability | `disabled` | 81.0 | Capture the request shape without recording personal information. |
| `gateway-6` | Configure a development proxy | Networking | Needs follow-up | 94.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Migrate a persisted setting** | Storage | Verified | 107.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-8` | Triage an editor notification | Support | Scheduled | 120.0 | Include the editor version and the relevant plugin revision. |

The latency column describes the local development rehearsal, not a service-level guarantee. Record hit rate and eviction count before increasing the capacity.

## Inspect a failed background job (local development)

Locate the original input, distinguish a transient failure from invalid data, and retry only work that is safe to repeat.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Inspect a failed background job** | Data operations | Scheduled | 36.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-2` | Validate a release candidate | Release engineering | **Ready** | 49.0 | Verify the version string and the included runtime dependencies. |
| `notification service-3` | **Restore a service backup** | Reliability | In review | 62.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Investigate slow requests | Observability | `disabled` | 75.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-5` | **Configure a development proxy** | Networking | Needs follow-up | 88.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-6` | Migrate a persisted setting | Storage | Verified | 101.0 | `not measured` until the rehearsal finishes |
| `cache-7` | **Triage an editor notification** | Support | Scheduled | 114.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-8` | Audit a dependency update | Maintenance | **Ready** | 127.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-9` | **Measure a rendering regression** | Performance | In review | 140.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Retain the job identifier when reporting an error to another team.

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

Restore into an isolated environment, check representative records, and measure recovery time before declaring the backup usable.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Restore a service backup** | Reliability | In review | 50.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-2` | Investigate slow requests | Observability | `disabled` | 63.0 | Capture the request shape without recording personal information. |
| `gateway-3` | **Configure a development proxy** | Networking | Needs follow-up | 76.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Migrate a persisted setting | Storage | Verified | 89.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-5` | **Triage an editor notification** | Support | Scheduled | 102.0 | Include the editor version and the relevant plugin revision. |
| `scheduler-6` | Audit a dependency update | Maintenance | **Ready** | 115.0 | `not measured` until the rehearsal finishes |
| `indexer-7` | **Measure a rendering regression** | Performance | In review | 128.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-8` | Prepare an incident handoff | Incident response | `disabled` | 141.0 | Link the timeline and note which mitigation is still active. |
| `notification service-9` | **Export a support bundle** | Privacy | Needs follow-up | 154.0 | `not measured` until the rehearsal finishes |
| `editor-10` | Schedule a maintenance window | Operations | Verified | 167.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-11` | **Test an offline workflow** | Quality engineering | Scheduled | 180.0 | Missing optional dependencies should produce actionable diagnostics. |

The latency column describes the local development rehearsal, not a service-level guarantee. Do not overwrite the production dataset during a recovery exercise.

## Investigate slow requests (local development)

Compare median and tail latency, isolate the expensive stage, and check whether the regression occurs only under concurrency.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Investigate slow requests** | Observability | `disabled` | 57.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-2` | Configure a development proxy | Networking | Needs follow-up | 70.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-3` | **Migrate a persisted setting** | Storage | Verified | 83.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Triage an editor notification | Support | Scheduled | 96.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-5` | **Audit a dependency update** | Maintenance | **Ready** | 109.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-6` | Measure a rendering regression | Performance | In review | 122.0 | `not measured` until the rehearsal finishes |
| `exporter-7` | **Prepare an incident handoff** | Incident response | `disabled` | 135.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-8` | Export a support bundle | Privacy | Needs follow-up | 148.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-9` | **Schedule a maintenance window** | Operations | Verified | 161.0 | `not measured` until the rehearsal finishes |
| `gateway-10` | Test an offline workflow | Quality engineering | Scheduled | 174.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-11` | **Tune a queue consumer** | Messaging | **Ready** | 187.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-12` | Verify an access policy | Identity | In review | 200.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Capture the request shape without recording personal information.

## Configure a development proxy (local development)

Bind the listener to the local interface, preserve the original request headers, and make upstream failures visible to the caller.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Configure a development proxy** | Networking | Needs follow-up | 64.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |
| `worker-2` | Migrate a persisted setting | Storage | Verified | 77.0 | Keep a rollback copy until the new reader has been exercised. |
| `cache-3` | **Triage an editor notification** | Support | Scheduled | 90.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Audit a dependency update | Maintenance | **Ready** | 103.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-5` | **Measure a rendering regression** | Performance | In review | 116.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-6` | Prepare an incident handoff | Incident response | `disabled` | 129.0 | `not measured` until the rehearsal finishes |
| `notification service-7` | **Export a support bundle** | Privacy | Needs follow-up | 142.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-8` | Schedule a maintenance window | Operations | Verified | 155.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-9` | **Test an offline workflow** | Quality engineering | Scheduled | 168.0 | `not measured` until the rehearsal finishes |
| `worker-10` | Tune a queue consumer | Messaging | **Ready** | 181.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-11` | **Verify an access policy** | Identity | In review | 194.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-12` | Publish a compatibility note | Community | `disabled` | 207.0 | `not measured` until the rehearsal finishes |
| `indexer-13` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 220.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Confirm the proxy does not accidentally expose a private service.

## Migrate a persisted setting (local development)

Read the old representation, validate each value, and write the new format atomically so interruption cannot leave a partial document.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Migrate a persisted setting** | Storage | Verified | 71.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-2` | Triage an editor notification | Support | Scheduled | 84.0 | Include the editor version and the relevant plugin revision. |
| `scheduler-3` | **Audit a dependency update** | Maintenance | **Ready** | 97.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Measure a rendering regression | Performance | In review | 110.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-5` | **Prepare an incident handoff** | Incident response | `disabled` | 123.0 | Link the timeline and note which mitigation is still active. |
| `notification service-6` | Export a support bundle | Privacy | Needs follow-up | 136.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Schedule a maintenance window** | Operations | Verified | 149.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-8` | Test an offline workflow | Quality engineering | Scheduled | 162.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-9` | **Tune a queue consumer** | Messaging | **Ready** | 175.0 | `not measured` until the rehearsal finishes |
| `cache-10` | Verify an access policy | Identity | In review | 188.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-11` | **Publish a compatibility note** | Community | `disabled` | 201.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-12` | Clean up a stale environment | Infrastructure | Needs follow-up | 214.0 | `not measured` until the rehearsal finishes |
| `exporter-13` | **Check a search index** | Search | Verified | 227.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-14` | Review a feature rollout | Product platform | Scheduled | 240.0 | Avoid comparing cohorts with different traffic patterns. |

The latency column describes the local development rehearsal, not a service-level guarantee. Keep a rollback copy until the new reader has been exercised.

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

Read the release notes, compare configuration defaults, and run representative documents through the updated parser before publishing.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Audit a dependency update** | Maintenance | **Ready** | 85.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-2` | Measure a rendering regression | Performance | In review | 98.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-3` | **Prepare an incident handoff** | Incident response | `disabled` | 111.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Export a support bundle | Privacy | Needs follow-up | 124.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-5` | **Schedule a maintenance window** | Operations | Verified | 137.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-6` | Test an offline workflow | Quality engineering | Scheduled | 150.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Tune a queue consumer** | Messaging | **Ready** | 163.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-8` | Verify an access policy | Identity | In review | 176.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-9` | **Publish a compatibility note** | Community | `disabled` | 189.0 | `not measured` until the rehearsal finishes |
| `indexer-10` | Clean up a stale environment | Infrastructure | Needs follow-up | 202.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-11` | **Check a search index** | Search | Verified | 215.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-12` | Review a feature rollout | Product platform | Scheduled | 228.0 | `not measured` until the rehearsal finishes |
| `editor-13` | **Bootstrap a workstation** | Developer experience | **Ready** | 1.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-14` | Review a configuration change | Editor tooling | In review | 14.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-15` | **Deploy the documentation site** | Documentation | `disabled` | 27.0 | `not measured` until the rehearsal finishes |
| `cache-16` | Rotate an API credential | Security | Needs follow-up | 40.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Pin the previous version so the rollout can be reversed quickly.

## Measure a rendering regression (local development)

Use the same document and viewport on both revisions, keep raw timings, and report regressions as well as improvements.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Measure a rendering regression** | Performance | In review | 92.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-2` | Prepare an incident handoff | Incident response | `disabled` | 105.0 | Link the timeline and note which mitigation is still active. |
| `notification service-3` | **Export a support bundle** | Privacy | Needs follow-up | 118.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Schedule a maintenance window | Operations | Verified | 131.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-5` | **Test an offline workflow** | Quality engineering | Scheduled | 144.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-6` | Tune a queue consumer | Messaging | **Ready** | 157.0 | `not measured` until the rehearsal finishes |
| `cache-7` | **Verify an access policy** | Identity | In review | 170.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-8` | Publish a compatibility note | Community | `disabled` | 183.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-9` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 196.0 | `not measured` until the rehearsal finishes |
| `exporter-10` | Check a search index | Search | Verified | 209.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-11` | **Review a feature rollout** | Product platform | Scheduled | 222.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-12` | Bootstrap a workstation | Developer experience | **Ready** | 235.0 | `not measured` until the rehearsal finishes |
| `gateway-13` | **Review a configuration change** | Editor tooling | In review | 8.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-14` | Deploy the documentation site | Documentation | `disabled` | 21.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-15` | **Rotate an API credential** | Security | Needs follow-up | 34.0 | `not measured` until the rehearsal finishes |
| `scheduler-16` | Warm the application cache | Application platform | Verified | 47.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-17` | **Inspect a failed background job** | Data operations | Scheduled | 60.0 | Retain the job identifier when reporting an error to another team. |

The latency column describes the local development rehearsal, not a service-level guarantee. Separate cold attachment from warm edits and scrolling.

## Prepare an incident handoff (local development)

Summarize the impact, list the actions already taken, and identify the next safe experiment instead of asking the next responder to restart the investigation.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Prepare an incident handoff** | Incident response | `disabled` | 99.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-2` | Export a support bundle | Privacy | Needs follow-up | 112.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-3` | **Schedule a maintenance window** | Operations | Verified | 125.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Test an offline workflow | Quality engineering | Scheduled | 138.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-5` | **Tune a queue consumer** | Messaging | **Ready** | 151.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-6` | Verify an access policy | Identity | In review | 164.0 | `not measured` until the rehearsal finishes |
| `scheduler-7` | **Publish a compatibility note** | Community | `disabled` | 177.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-8` | Clean up a stale environment | Infrastructure | Needs follow-up | 190.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-9` | **Check a search index** | Search | Verified | 203.0 | `not measured` until the rehearsal finishes |
| `notification service-10` | Review a feature rollout | Product platform | Scheduled | 216.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-11` | **Bootstrap a workstation** | Developer experience | **Ready** | 229.0 | Verify the executable on PATH matches the documented version. |
| `gateway-12` | Review a configuration change | Editor tooling | In review | 2.0 | `not measured` until the rehearsal finishes |
| `worker-13` | **Deploy the documentation site** | Documentation | `disabled` | 15.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-14` | Rotate an API credential | Security | Needs follow-up | 28.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-15` | **Warm the application cache** | Application platform | Verified | 41.0 | `not measured` until the rehearsal finishes |
| `indexer-16` | Inspect a failed background job | Data operations | Scheduled | 54.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-17` | **Validate a release candidate** | Release engineering | **Ready** | 67.0 | Verify the version string and the included runtime dependencies. |
| `notification service-18` | Restore a service backup | Reliability | In review | 80.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Link the timeline and note which mitigation is still active.

## Export a support bundle (local development)

Collect only the required diagnostic fields, redact private paths, and inspect the archive before sharing it outside the team.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Export a support bundle** | Privacy | Needs follow-up | 106.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-2` | Schedule a maintenance window | Operations | Verified | 119.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-3` | **Test an offline workflow** | Quality engineering | Scheduled | 132.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Tune a queue consumer | Messaging | **Ready** | 145.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Exclude document contents unless the owner explicitly approves sharing.

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

Disable network access and exercise a locally cached project to ensure setup does not silently depend on downloading tools.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Test an offline workflow** | Quality engineering | Scheduled | 120.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-2` | Tune a queue consumer | Messaging | **Ready** | 133.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-3` | **Verify an access policy** | Identity | In review | 146.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Publish a compatibility note | Community | `disabled` | 159.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-5` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 172.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-6` | Check a search index | Search | Verified | 185.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Missing optional dependencies should produce actionable diagnostics.

## Tune a queue consumer (local development)

Bound concurrency, retain failed messages for inspection, and observe downstream load before increasing the worker count.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Tune a queue consumer** | Messaging | **Ready** | 127.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-2` | Verify an access policy | Identity | In review | 140.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-3` | **Publish a compatibility note** | Community | `disabled` | 153.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Clean up a stale environment | Infrastructure | Needs follow-up | 166.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-5` | **Check a search index** | Search | Verified | 179.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-6` | Review a feature rollout | Product platform | Scheduled | 192.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Bootstrap a workstation** | Developer experience | **Ready** | 205.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |

The latency column describes the local development rehearsal, not a service-level guarantee. Check that retries cannot enqueue the same side effect indefinitely.

## Verify an access policy (local development)

Test a permitted action and a denied action with separate identities; a successful administrator request does not prove the policy is correct.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Verify an access policy** | Identity | In review | 134.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-2` | Publish a compatibility note | Community | `disabled` | 147.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-3` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 160.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Check a search index | Search | Verified | 173.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-5` | **Review a feature rollout** | Product platform | Scheduled | 186.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-6` | Bootstrap a workstation | Developer experience | **Ready** | 199.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Review a configuration change** | Editor tooling | In review | 212.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-8` | Deploy the documentation site | Documentation | `disabled` | 225.0 | Check a page with a table, a code example, and a nested checklist. |

The latency column describes the local development rehearsal, not a service-level guarantee. Use temporary test identities rather than another person’s account.

## Publish a compatibility note (local development)

Describe the supported versions, include a small working configuration, and distinguish known limitations from unsupported behavior.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Publish a compatibility note** | Community | `disabled` | 141.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-2` | Clean up a stale environment | Infrastructure | Needs follow-up | 154.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-3` | **Check a search index** | Search | Verified | 167.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Review a feature rollout | Product platform | Scheduled | 180.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-5` | **Bootstrap a workstation** | Developer experience | **Ready** | 193.0 | Verify the executable on PATH matches the documented version. |
| `gateway-6` | Review a configuration change | Editor tooling | In review | 206.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Deploy the documentation site** | Documentation | `disabled` | 219.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-8` | Rotate an API credential | Security | Needs follow-up | 232.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-9` | **Warm the application cache** | Application platform | Verified | 5.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Link to the migration instructions and the issue tracking the limitation.

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

Compare source records with indexed documents, inspect tokenization for representative queries, and repair only the affected partition.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Check a search index** | Search | Verified | 155.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-2` | Review a feature rollout | Product platform | Scheduled | 168.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-3` | **Bootstrap a workstation** | Developer experience | **Ready** | 181.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Review a configuration change | Editor tooling | In review | 194.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-5` | **Deploy the documentation site** | Documentation | `disabled` | 207.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-6` | Rotate an API credential | Security | Needs follow-up | 220.0 | `not measured` until the rehearsal finishes |
| `scheduler-7` | **Warm the application cache** | Application platform | Verified | 233.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-8` | Inspect a failed background job | Data operations | Scheduled | 6.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-9` | **Validate a release candidate** | Release engineering | **Ready** | 19.0 | `not measured` until the rehearsal finishes |
| `notification service-10` | Restore a service backup | Reliability | In review | 32.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-11` | **Investigate slow requests** | Observability | `disabled` | 45.0 | Capture the request shape without recording personal information. |

The latency column describes the local development rehearsal, not a service-level guarantee. Keep query examples short enough to inspect without exposing user data.

## Review a feature rollout (local development)

Enable the feature for a small cohort, compare error rates with the control group, and keep a fast path to disable the change.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Review a feature rollout** | Product platform | Scheduled | 162.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-2` | Bootstrap a workstation | Developer experience | **Ready** | 175.0 | Verify the executable on PATH matches the documented version. |
| `gateway-3` | **Review a configuration change** | Editor tooling | In review | 188.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Deploy the documentation site | Documentation | `disabled` | 201.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-5` | **Rotate an API credential** | Security | Needs follow-up | 214.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-6` | Warm the application cache | Application platform | Verified | 227.0 | `not measured` until the rehearsal finishes |
| `indexer-7` | **Inspect a failed background job** | Data operations | Scheduled | 240.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-8` | Validate a release candidate | Release engineering | **Ready** | 13.0 | Verify the version string and the included runtime dependencies. |
| `notification service-9` | **Restore a service backup** | Reliability | In review | 26.0 | `not measured` until the rehearsal finishes |
| `editor-10` | Investigate slow requests | Observability | `disabled` | 39.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-11` | **Configure a development proxy** | Networking | Needs follow-up | 52.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-12` | Migrate a persisted setting | Storage | Verified | 65.0 | `not measured` until the rehearsal finishes |

The latency column describes the local development rehearsal, not a service-level guarantee. Avoid comparing cohorts with different traffic patterns.

# Service readiness inventory: shared staging

## Bootstrap a workstation (shared staging)

Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Bootstrap a workstation** | Developer experience | **Ready** | 169.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-2` | Review a configuration change | Editor tooling | In review | 182.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-3` | **Deploy the documentation site** | Documentation | `disabled` | 195.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Rotate an API credential | Security | Needs follow-up | 208.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-5` | **Warm the application cache** | Application platform | Verified | 221.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-6` | Inspect a failed background job | Data operations | Scheduled | 234.0 | `not measured` until the rehearsal finishes |
| `exporter-7` | **Validate a release candidate** | Release engineering | **Ready** | 7.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-8` | Restore a service backup | Reliability | In review | 20.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-9` | **Investigate slow requests** | Observability | `disabled` | 33.0 | `not measured` until the rehearsal finishes |
| `gateway-10` | Configure a development proxy | Networking | Needs follow-up | 46.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |
| `worker-11` | **Migrate a persisted setting** | Storage | Verified | 59.0 | Keep a rollback copy until the new reader has been exercised. |
| `cache-12` | Triage an editor notification | Support | Scheduled | 72.0 | `not measured` until the rehearsal finishes |
| `scheduler-13` | **Audit a dependency update** | Maintenance | **Ready** | 85.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Verify the executable on PATH matches the documented version.

## Review a configuration change (shared staging)

Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Review a configuration change** | Editor tooling | In review | 176.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-2` | Deploy the documentation site | Documentation | `disabled` | 189.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-3` | **Rotate an API credential** | Security | Needs follow-up | 202.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Warm the application cache | Application platform | Verified | 215.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-5` | **Inspect a failed background job** | Data operations | Scheduled | 228.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-6` | Validate a release candidate | Release engineering | **Ready** | 1.0 | `not measured` until the rehearsal finishes |
| `notification service-7` | **Restore a service backup** | Reliability | In review | 14.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-8` | Investigate slow requests | Observability | `disabled` | 27.0 | Capture the request shape without recording personal information. |
| `gateway-9` | **Configure a development proxy** | Networking | Needs follow-up | 40.0 | `not measured` until the rehearsal finishes |
| `worker-10` | Migrate a persisted setting | Storage | Verified | 53.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-11` | **Triage an editor notification** | Support | Scheduled | 66.0 | Include the editor version and the relevant plugin revision. |
| `scheduler-12` | Audit a dependency update | Maintenance | **Ready** | 79.0 | `not measured` until the rehearsal finishes |
| `indexer-13` | **Measure a rendering regression** | Performance | In review | 92.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-14` | Prepare an incident handoff | Incident response | `disabled` | 105.0 | Link the timeline and note which mitigation is still active. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Compare the effective configuration with the checked-in defaults.

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

Create a replacement credential with the minimum permissions, update the consumer, and revoke the old credential only after a successful request.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Rotate an API credential** | Security | Needs follow-up | 190.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-2` | Warm the application cache | Application platform | Verified | 203.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-3` | **Inspect a failed background job** | Data operations | Scheduled | 216.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Validate a release candidate | Release engineering | **Ready** | 229.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-5` | **Restore a service backup** | Reliability | In review | 2.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-6` | Investigate slow requests | Observability | `disabled` | 15.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Configure a development proxy** | Networking | Needs follow-up | 28.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |
| `worker-8` | Migrate a persisted setting | Storage | Verified | 41.0 | Keep a rollback copy until the new reader has been exercised. |
| `cache-9` | **Triage an editor notification** | Support | Scheduled | 54.0 | `not measured` until the rehearsal finishes |
| `scheduler-10` | Audit a dependency update | Maintenance | **Ready** | 67.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-11` | **Measure a rendering regression** | Performance | In review | 80.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-12` | Prepare an incident handoff | Incident response | `disabled` | 93.0 | `not measured` until the rehearsal finishes |
| `notification service-13` | **Export a support bundle** | Privacy | Needs follow-up | 106.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-14` | Schedule a maintenance window | Operations | Verified | 119.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-15` | **Test an offline workflow** | Quality engineering | Scheduled | 132.0 | `not measured` until the rehearsal finishes |
| `worker-16` | Tune a queue consumer | Messaging | **Ready** | 145.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Never paste credentials into logs, terminal recordings, or bug reports.

## Warm the application cache (shared staging)

Load frequently requested records gradually rather than creating a burst of concurrent calls immediately after deployment.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Warm the application cache** | Application platform | Verified | 197.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-2` | Inspect a failed background job | Data operations | Scheduled | 210.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-3` | **Validate a release candidate** | Release engineering | **Ready** | 223.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Restore a service backup | Reliability | In review | 236.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-5` | **Investigate slow requests** | Observability | `disabled` | 9.0 | Capture the request shape without recording personal information. |
| `gateway-6` | Configure a development proxy | Networking | Needs follow-up | 22.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Migrate a persisted setting** | Storage | Verified | 35.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-8` | Triage an editor notification | Support | Scheduled | 48.0 | Include the editor version and the relevant plugin revision. |
| `scheduler-9` | **Audit a dependency update** | Maintenance | **Ready** | 61.0 | `not measured` until the rehearsal finishes |
| `indexer-10` | Measure a rendering regression | Performance | In review | 74.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-11` | **Prepare an incident handoff** | Incident response | `disabled` | 87.0 | Link the timeline and note which mitigation is still active. |
| `notification service-12` | Export a support bundle | Privacy | Needs follow-up | 100.0 | `not measured` until the rehearsal finishes |
| `editor-13` | **Schedule a maintenance window** | Operations | Verified | 113.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-14` | Test an offline workflow | Quality engineering | Scheduled | 126.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-15` | **Tune a queue consumer** | Messaging | **Ready** | 139.0 | `not measured` until the rehearsal finishes |
| `cache-16` | Verify an access policy | Identity | In review | 152.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-17` | **Publish a compatibility note** | Community | `disabled` | 165.0 | Link to the migration instructions and the issue tracking the limitation. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Record hit rate and eviction count before increasing the capacity.

## Inspect a failed background job (shared staging)

Locate the original input, distinguish a transient failure from invalid data, and retry only work that is safe to repeat.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Inspect a failed background job** | Data operations | Scheduled | 204.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-2` | Validate a release candidate | Release engineering | **Ready** | 217.0 | Verify the version string and the included runtime dependencies. |
| `notification service-3` | **Restore a service backup** | Reliability | In review | 230.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Investigate slow requests | Observability | `disabled` | 3.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-5` | **Configure a development proxy** | Networking | Needs follow-up | 16.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-6` | Migrate a persisted setting | Storage | Verified | 29.0 | `not measured` until the rehearsal finishes |
| `cache-7` | **Triage an editor notification** | Support | Scheduled | 42.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-8` | Audit a dependency update | Maintenance | **Ready** | 55.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-9` | **Measure a rendering regression** | Performance | In review | 68.0 | `not measured` until the rehearsal finishes |
| `exporter-10` | Prepare an incident handoff | Incident response | `disabled` | 81.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-11` | **Export a support bundle** | Privacy | Needs follow-up | 94.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-12` | Schedule a maintenance window | Operations | Verified | 107.0 | `not measured` until the rehearsal finishes |
| `gateway-13` | **Test an offline workflow** | Quality engineering | Scheduled | 120.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-14` | Tune a queue consumer | Messaging | **Ready** | 133.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-15` | **Verify an access policy** | Identity | In review | 146.0 | `not measured` until the rehearsal finishes |
| `scheduler-16` | Publish a compatibility note | Community | `disabled` | 159.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-17` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 172.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-18` | Check a search index | Search | Verified | 185.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Retain the job identifier when reporting an error to another team.

## Validate a release candidate (shared staging)

Run the smoke suite against the packaged artifact, not just the development checkout, and document any known limitations.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Validate a release candidate** | Release engineering | **Ready** | 211.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-2` | Restore a service backup | Reliability | In review | 224.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-3` | **Investigate slow requests** | Observability | `disabled` | 237.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Configure a development proxy | Networking | Needs follow-up | 10.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Verify the version string and the included runtime dependencies.

## Restore a service backup (shared staging)

Restore into an isolated environment, check representative records, and measure recovery time before declaring the backup usable.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Restore a service backup** | Reliability | In review | 218.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-2` | Investigate slow requests | Observability | `disabled` | 231.0 | Capture the request shape without recording personal information. |
| `gateway-3` | **Configure a development proxy** | Networking | Needs follow-up | 4.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Migrate a persisted setting | Storage | Verified | 17.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-5` | **Triage an editor notification** | Support | Scheduled | 30.0 | Include the editor version and the relevant plugin revision. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Do not overwrite the production dataset during a recovery exercise.

## Investigate slow requests (shared staging)

Compare median and tail latency, isolate the expensive stage, and check whether the regression occurs only under concurrency.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Investigate slow requests** | Observability | `disabled` | 225.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-2` | Configure a development proxy | Networking | Needs follow-up | 238.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-3` | **Migrate a persisted setting** | Storage | Verified | 11.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Triage an editor notification | Support | Scheduled | 24.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-5` | **Audit a dependency update** | Maintenance | **Ready** | 37.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-6` | Measure a rendering regression | Performance | In review | 50.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Capture the request shape without recording personal information.

## Configure a development proxy (shared staging)

Bind the listener to the local interface, preserve the original request headers, and make upstream failures visible to the caller.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Configure a development proxy** | Networking | Needs follow-up | 232.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |
| `worker-2` | Migrate a persisted setting | Storage | Verified | 5.0 | Keep a rollback copy until the new reader has been exercised. |
| `cache-3` | **Triage an editor notification** | Support | Scheduled | 18.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Audit a dependency update | Maintenance | **Ready** | 31.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-5` | **Measure a rendering regression** | Performance | In review | 44.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-6` | Prepare an incident handoff | Incident response | `disabled` | 57.0 | `not measured` until the rehearsal finishes |
| `notification service-7` | **Export a support bundle** | Privacy | Needs follow-up | 70.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Confirm the proxy does not accidentally expose a private service.

## Migrate a persisted setting (shared staging)

Read the old representation, validate each value, and write the new format atomically so interruption cannot leave a partial document.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Migrate a persisted setting** | Storage | Verified | 239.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-2` | Triage an editor notification | Support | Scheduled | 12.0 | Include the editor version and the relevant plugin revision. |
| `scheduler-3` | **Audit a dependency update** | Maintenance | **Ready** | 25.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Measure a rendering regression | Performance | In review | 38.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-5` | **Prepare an incident handoff** | Incident response | `disabled` | 51.0 | Link the timeline and note which mitigation is still active. |
| `notification service-6` | Export a support bundle | Privacy | Needs follow-up | 64.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Schedule a maintenance window** | Operations | Verified | 77.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-8` | Test an offline workflow | Quality engineering | Scheduled | 90.0 | Missing optional dependencies should produce actionable diagnostics. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Keep a rollback copy until the new reader has been exercised.

## Triage an editor notification (shared staging)

Collect the exact action that triggered the message, inspect the active buffer settings, and reduce the configuration to the smallest reproduction.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Triage an editor notification** | Support | Scheduled | 6.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-2` | Audit a dependency update | Maintenance | **Ready** | 19.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-3` | **Measure a rendering regression** | Performance | In review | 32.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Prepare an incident handoff | Incident response | `disabled` | 45.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-5` | **Export a support bundle** | Privacy | Needs follow-up | 58.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-6` | Schedule a maintenance window | Operations | Verified | 71.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Test an offline workflow** | Quality engineering | Scheduled | 84.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-8` | Tune a queue consumer | Messaging | **Ready** | 97.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-9` | **Verify an access policy** | Identity | In review | 110.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Include the editor version and the relevant plugin revision.

## Audit a dependency update (shared staging)

Read the release notes, compare configuration defaults, and run representative documents through the updated parser before publishing.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Audit a dependency update** | Maintenance | **Ready** | 13.0 | See [runbook](https://example.com/runbooks/13) before changing defaults. |
| `indexer-2` | Measure a rendering regression | Performance | In review | 26.0 | Separate cold attachment from warm edits and scrolling. |
| `exporter-3` | **Prepare an incident handoff** | Incident response | `disabled` | 39.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Export a support bundle | Privacy | Needs follow-up | 52.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-5` | **Schedule a maintenance window** | Operations | Verified | 65.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-6` | Test an offline workflow | Quality engineering | Scheduled | 78.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Tune a queue consumer** | Messaging | **Ready** | 91.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-8` | Verify an access policy | Identity | In review | 104.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-9` | **Publish a compatibility note** | Community | `disabled` | 117.0 | `not measured` until the rehearsal finishes |
| `indexer-10` | Clean up a stale environment | Infrastructure | Needs follow-up | 130.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Pin the previous version so the rollout can be reversed quickly.

## Measure a rendering regression (shared staging)

Use the same document and viewport on both revisions, keep raw timings, and report regressions as well as improvements.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Measure a rendering regression** | Performance | In review | 20.0 | See [runbook](https://example.com/runbooks/14) before changing defaults. |
| `exporter-2` | Prepare an incident handoff | Incident response | `disabled` | 33.0 | Link the timeline and note which mitigation is still active. |
| `notification service-3` | **Export a support bundle** | Privacy | Needs follow-up | 46.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Schedule a maintenance window | Operations | Verified | 59.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-5` | **Test an offline workflow** | Quality engineering | Scheduled | 72.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-6` | Tune a queue consumer | Messaging | **Ready** | 85.0 | `not measured` until the rehearsal finishes |
| `cache-7` | **Verify an access policy** | Identity | In review | 98.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-8` | Publish a compatibility note | Community | `disabled` | 111.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-9` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 124.0 | `not measured` until the rehearsal finishes |
| `exporter-10` | Check a search index | Search | Verified | 137.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-11` | **Review a feature rollout** | Product platform | Scheduled | 150.0 | Avoid comparing cohorts with different traffic patterns. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Separate cold attachment from warm edits and scrolling.

## Prepare an incident handoff (shared staging)

Summarize the impact, list the actions already taken, and identify the next safe experiment instead of asking the next responder to restart the investigation.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Prepare an incident handoff** | Incident response | `disabled` | 27.0 | See [runbook](https://example.com/runbooks/15) before changing defaults. |
| `notification service-2` | Export a support bundle | Privacy | Needs follow-up | 40.0 | Exclude document contents unless the owner explicitly approves sharing. |
| `editor-3` | **Schedule a maintenance window** | Operations | Verified | 53.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Test an offline workflow | Quality engineering | Scheduled | 66.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-5` | **Tune a queue consumer** | Messaging | **Ready** | 79.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-6` | Verify an access policy | Identity | In review | 92.0 | `not measured` until the rehearsal finishes |
| `scheduler-7` | **Publish a compatibility note** | Community | `disabled` | 105.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-8` | Clean up a stale environment | Infrastructure | Needs follow-up | 118.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-9` | **Check a search index** | Search | Verified | 131.0 | `not measured` until the rehearsal finishes |
| `notification service-10` | Review a feature rollout | Product platform | Scheduled | 144.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-11` | **Bootstrap a workstation** | Developer experience | **Ready** | 157.0 | Verify the executable on PATH matches the documented version. |
| `gateway-12` | Review a configuration change | Editor tooling | In review | 170.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Link the timeline and note which mitigation is still active.

## Export a support bundle (shared staging)

Collect only the required diagnostic fields, redact private paths, and inspect the archive before sharing it outside the team.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Export a support bundle** | Privacy | Needs follow-up | 34.0 | See [runbook](https://example.com/runbooks/16) before changing defaults. |
| `editor-2` | Schedule a maintenance window | Operations | Verified | 47.0 | Specify the rollback trigger and who can approve extending the window. |
| `gateway-3` | **Test an offline workflow** | Quality engineering | Scheduled | 60.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Tune a queue consumer | Messaging | **Ready** | 73.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-5` | **Verify an access policy** | Identity | In review | 86.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-6` | Publish a compatibility note | Community | `disabled` | 99.0 | `not measured` until the rehearsal finishes |
| `indexer-7` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 112.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-8` | Check a search index | Search | Verified | 125.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-9` | **Review a feature rollout** | Product platform | Scheduled | 138.0 | `not measured` until the rehearsal finishes |
| `editor-10` | Bootstrap a workstation | Developer experience | **Ready** | 151.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-11` | **Review a configuration change** | Editor tooling | In review | 164.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-12` | Deploy the documentation site | Documentation | `disabled` | 177.0 | `not measured` until the rehearsal finishes |
| `cache-13` | **Rotate an API credential** | Security | Needs follow-up | 190.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Exclude document contents unless the owner explicitly approves sharing.

## Schedule a maintenance window (shared staging)

Confirm ownership, list the affected integrations, and communicate the expected interruption before changing the service.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Schedule a maintenance window** | Operations | Verified | 41.0 | See [runbook](https://example.com/runbooks/17) before changing defaults. |
| `gateway-2` | Test an offline workflow | Quality engineering | Scheduled | 54.0 | Missing optional dependencies should produce actionable diagnostics. |
| `worker-3` | **Tune a queue consumer** | Messaging | **Ready** | 67.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Verify an access policy | Identity | In review | 80.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-5` | **Publish a compatibility note** | Community | `disabled` | 93.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-6` | Clean up a stale environment | Infrastructure | Needs follow-up | 106.0 | `not measured` until the rehearsal finishes |
| `exporter-7` | **Check a search index** | Search | Verified | 119.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-8` | Review a feature rollout | Product platform | Scheduled | 132.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-9` | **Bootstrap a workstation** | Developer experience | **Ready** | 145.0 | `not measured` until the rehearsal finishes |
| `gateway-10` | Review a configuration change | Editor tooling | In review | 158.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-11` | **Deploy the documentation site** | Documentation | `disabled` | 171.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-12` | Rotate an API credential | Security | Needs follow-up | 184.0 | `not measured` until the rehearsal finishes |
| `scheduler-13` | **Warm the application cache** | Application platform | Verified | 197.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-14` | Inspect a failed background job | Data operations | Scheduled | 210.0 | Retain the job identifier when reporting an error to another team. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Specify the rollback trigger and who can approve extending the window.

## Test an offline workflow (shared staging)

Disable network access and exercise a locally cached project to ensure setup does not silently depend on downloading tools.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Test an offline workflow** | Quality engineering | Scheduled | 48.0 | See [runbook](https://example.com/runbooks/18) before changing defaults. |
| `worker-2` | Tune a queue consumer | Messaging | **Ready** | 61.0 | Check that retries cannot enqueue the same side effect indefinitely. |
| `cache-3` | **Verify an access policy** | Identity | In review | 74.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Publish a compatibility note | Community | `disabled` | 87.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-5` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 100.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-6` | Check a search index | Search | Verified | 113.0 | `not measured` until the rehearsal finishes |
| `notification service-7` | **Review a feature rollout** | Product platform | Scheduled | 126.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-8` | Bootstrap a workstation | Developer experience | **Ready** | 139.0 | Verify the executable on PATH matches the documented version. |
| `gateway-9` | **Review a configuration change** | Editor tooling | In review | 152.0 | `not measured` until the rehearsal finishes |
| `worker-10` | Deploy the documentation site | Documentation | `disabled` | 165.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-11` | **Rotate an API credential** | Security | Needs follow-up | 178.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-12` | Warm the application cache | Application platform | Verified | 191.0 | `not measured` until the rehearsal finishes |
| `indexer-13` | **Inspect a failed background job** | Data operations | Scheduled | 204.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-14` | Validate a release candidate | Release engineering | **Ready** | 217.0 | Verify the version string and the included runtime dependencies. |
| `notification service-15` | **Restore a service backup** | Reliability | In review | 230.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Missing optional dependencies should produce actionable diagnostics.

## Tune a queue consumer (shared staging)

Bound concurrency, retain failed messages for inspection, and observe downstream load before increasing the worker count.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Tune a queue consumer** | Messaging | **Ready** | 55.0 | See [runbook](https://example.com/runbooks/19) before changing defaults. |
| `cache-2` | Verify an access policy | Identity | In review | 68.0 | Use temporary test identities rather than another person’s account. |
| `scheduler-3` | **Publish a compatibility note** | Community | `disabled` | 81.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Clean up a stale environment | Infrastructure | Needs follow-up | 94.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-5` | **Check a search index** | Search | Verified | 107.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-6` | Review a feature rollout | Product platform | Scheduled | 120.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Bootstrap a workstation** | Developer experience | **Ready** | 133.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-8` | Review a configuration change | Editor tooling | In review | 146.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-9` | **Deploy the documentation site** | Documentation | `disabled` | 159.0 | `not measured` until the rehearsal finishes |
| `cache-10` | Rotate an API credential | Security | Needs follow-up | 172.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-11` | **Warm the application cache** | Application platform | Verified | 185.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-12` | Inspect a failed background job | Data operations | Scheduled | 198.0 | `not measured` until the rehearsal finishes |
| `exporter-13` | **Validate a release candidate** | Release engineering | **Ready** | 211.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |
| `notification service-14` | Restore a service backup | Reliability | In review | 224.0 | Do not overwrite the production dataset during a recovery exercise. |
| `editor-15` | **Investigate slow requests** | Observability | `disabled` | 237.0 | `not measured` until the rehearsal finishes |
| `gateway-16` | Configure a development proxy | Networking | Needs follow-up | 10.0 | See [runbook](https://example.com/runbooks/10) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Check that retries cannot enqueue the same side effect indefinitely.

## Verify an access policy (shared staging)

Test a permitted action and a denied action with separate identities; a successful administrator request does not prove the policy is correct.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `cache-1` | **Verify an access policy** | Identity | In review | 62.0 | See [runbook](https://example.com/runbooks/20) before changing defaults. |
| `scheduler-2` | Publish a compatibility note | Community | `disabled` | 75.0 | Link to the migration instructions and the issue tracking the limitation. |
| `indexer-3` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 88.0 | `not measured` until the rehearsal finishes |
| `exporter-4` | Check a search index | Search | Verified | 101.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-5` | **Review a feature rollout** | Product platform | Scheduled | 114.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-6` | Bootstrap a workstation | Developer experience | **Ready** | 127.0 | `not measured` until the rehearsal finishes |
| `gateway-7` | **Review a configuration change** | Editor tooling | In review | 140.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-8` | Deploy the documentation site | Documentation | `disabled` | 153.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-9` | **Rotate an API credential** | Security | Needs follow-up | 166.0 | `not measured` until the rehearsal finishes |
| `scheduler-10` | Warm the application cache | Application platform | Verified | 179.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-11` | **Inspect a failed background job** | Data operations | Scheduled | 192.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-12` | Validate a release candidate | Release engineering | **Ready** | 205.0 | `not measured` until the rehearsal finishes |
| `notification service-13` | **Restore a service backup** | Reliability | In review | 218.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-14` | Investigate slow requests | Observability | `disabled` | 231.0 | Capture the request shape without recording personal information. |
| `gateway-15` | **Configure a development proxy** | Networking | Needs follow-up | 4.0 | `not measured` until the rehearsal finishes |
| `worker-16` | Migrate a persisted setting | Storage | Verified | 17.0 | See [runbook](https://example.com/runbooks/11) before changing defaults. |
| `cache-17` | **Triage an editor notification** | Support | Scheduled | 30.0 | Include the editor version and the relevant plugin revision. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Use temporary test identities rather than another person’s account.

## Publish a compatibility note (shared staging)

Describe the supported versions, include a small working configuration, and distinguish known limitations from unsupported behavior.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `scheduler-1` | **Publish a compatibility note** | Community | `disabled` | 69.0 | See [runbook](https://example.com/runbooks/21) before changing defaults. |
| `indexer-2` | Clean up a stale environment | Infrastructure | Needs follow-up | 82.0 | Preserve state and diagnostic artifacts until ownership is confirmed. |
| `exporter-3` | **Check a search index** | Search | Verified | 95.0 | `not measured` until the rehearsal finishes |
| `notification service-4` | Review a feature rollout | Product platform | Scheduled | 108.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-5` | **Bootstrap a workstation** | Developer experience | **Ready** | 121.0 | Verify the executable on PATH matches the documented version. |
| `gateway-6` | Review a configuration change | Editor tooling | In review | 134.0 | `not measured` until the rehearsal finishes |
| `worker-7` | **Deploy the documentation site** | Documentation | `disabled` | 147.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-8` | Rotate an API credential | Security | Needs follow-up | 160.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-9` | **Warm the application cache** | Application platform | Verified | 173.0 | `not measured` until the rehearsal finishes |
| `indexer-10` | Inspect a failed background job | Data operations | Scheduled | 186.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-11` | **Validate a release candidate** | Release engineering | **Ready** | 199.0 | Verify the version string and the included runtime dependencies. |
| `notification service-12` | Restore a service backup | Reliability | In review | 212.0 | `not measured` until the rehearsal finishes |
| `editor-13` | **Investigate slow requests** | Observability | `disabled` | 225.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-14` | Configure a development proxy | Networking | Needs follow-up | 238.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-15` | **Migrate a persisted setting** | Storage | Verified | 11.0 | `not measured` until the rehearsal finishes |
| `cache-16` | Triage an editor notification | Support | Scheduled | 24.0 | See [runbook](https://example.com/runbooks/12) before changing defaults. |
| `scheduler-17` | **Audit a dependency update** | Maintenance | **Ready** | 37.0 | Pin the previous version so the rollout can be reversed quickly. |
| `indexer-18` | Measure a rendering regression | Performance | In review | 50.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Link to the migration instructions and the issue tracking the limitation.

## Clean up a stale environment (shared staging)

List the resources first, confirm they are no longer referenced, and remove only the environment covered by the change request.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `indexer-1` | **Clean up a stale environment** | Infrastructure | Needs follow-up | 76.0 | See [runbook](https://example.com/runbooks/22) before changing defaults. |
| `exporter-2` | Check a search index | Search | Verified | 89.0 | Keep query examples short enough to inspect without exposing user data. |
| `notification service-3` | **Review a feature rollout** | Product platform | Scheduled | 102.0 | `not measured` until the rehearsal finishes |
| `editor-4` | Bootstrap a workstation | Developer experience | **Ready** | 115.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Preserve state and diagnostic artifacts until ownership is confirmed.

## Check a search index (shared staging)

Compare source records with indexed documents, inspect tokenization for representative queries, and repair only the affected partition.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `exporter-1` | **Check a search index** | Search | Verified | 83.0 | See [runbook](https://example.com/runbooks/23) before changing defaults. |
| `notification service-2` | Review a feature rollout | Product platform | Scheduled | 96.0 | Avoid comparing cohorts with different traffic patterns. |
| `editor-3` | **Bootstrap a workstation** | Developer experience | **Ready** | 109.0 | `not measured` until the rehearsal finishes |
| `gateway-4` | Review a configuration change | Editor tooling | In review | 122.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-5` | **Deploy the documentation site** | Documentation | `disabled` | 135.0 | Check a page with a table, a code example, and a nested checklist. |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Keep query examples short enough to inspect without exposing user data.

## Review a feature rollout (shared staging)

Enable the feature for a small cohort, compare error rates with the control group, and keep a fast path to disable the change.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `notification service-1` | **Review a feature rollout** | Product platform | Scheduled | 90.0 | See [runbook](https://example.com/runbooks/24) before changing defaults. |
| `editor-2` | Bootstrap a workstation | Developer experience | **Ready** | 103.0 | Verify the executable on PATH matches the documented version. |
| `gateway-3` | **Review a configuration change** | Editor tooling | In review | 116.0 | `not measured` until the rehearsal finishes |
| `worker-4` | Deploy the documentation site | Documentation | `disabled` | 129.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-5` | **Rotate an API credential** | Security | Needs follow-up | 142.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-6` | Warm the application cache | Application platform | Verified | 155.0 | `not measured` until the rehearsal finishes |

The latency column describes the shared staging rehearsal, not a service-level guarantee. Avoid comparing cohorts with different traffic patterns.

# Service readiness inventory: release rehearsal

## Bootstrap a workstation (release rehearsal)

Install the editor, inspect the runtime path, and open a small project before enabling optional integrations.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `editor-1` | **Bootstrap a workstation** | Developer experience | **Ready** | 97.0 | See [runbook](https://example.com/runbooks/1) before changing defaults. |
| `gateway-2` | Review a configuration change | Editor tooling | In review | 110.0 | Compare the effective configuration with the checked-in defaults. |
| `worker-3` | **Deploy the documentation site** | Documentation | `disabled` | 123.0 | `not measured` until the rehearsal finishes |
| `cache-4` | Rotate an API credential | Security | Needs follow-up | 136.0 | See [runbook](https://example.com/runbooks/4) before changing defaults. |
| `scheduler-5` | **Warm the application cache** | Application platform | Verified | 149.0 | Record hit rate and eviction count before increasing the capacity. |
| `indexer-6` | Inspect a failed background job | Data operations | Scheduled | 162.0 | `not measured` until the rehearsal finishes |
| `exporter-7` | **Validate a release candidate** | Release engineering | **Ready** | 175.0 | See [runbook](https://example.com/runbooks/7) before changing defaults. |

The latency column describes the release rehearsal rehearsal, not a service-level guarantee. Verify the executable on PATH matches the documented version.

## Review a configuration change (release rehearsal)

Keep local overrides separate from shared defaults so a teammate can reproduce the behavior without copying private files.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `gateway-1` | **Review a configuration change** | Editor tooling | In review | 104.0 | See [runbook](https://example.com/runbooks/2) before changing defaults. |
| `worker-2` | Deploy the documentation site | Documentation | `disabled` | 117.0 | Check a page with a table, a code example, and a nested checklist. |
| `cache-3` | **Rotate an API credential** | Security | Needs follow-up | 130.0 | `not measured` until the rehearsal finishes |
| `scheduler-4` | Warm the application cache | Application platform | Verified | 143.0 | See [runbook](https://example.com/runbooks/5) before changing defaults. |
| `indexer-5` | **Inspect a failed background job** | Data operations | Scheduled | 156.0 | Retain the job identifier when reporting an error to another team. |
| `exporter-6` | Validate a release candidate | Release engineering | **Ready** | 169.0 | `not measured` until the rehearsal finishes |
| `notification service-7` | **Restore a service backup** | Reliability | In review | 182.0 | See [runbook](https://example.com/runbooks/8) before changing defaults. |
| `editor-8` | Investigate slow requests | Observability | `disabled` | 195.0 | Capture the request shape without recording personal information. |

The latency column describes the release rehearsal rehearsal, not a service-level guarantee. Compare the effective configuration with the checked-in defaults.

## Deploy the documentation site (release rehearsal)

Build the static pages in a clean checkout, publish the artifact, and verify that internal links still resolve.

| Component | Responsibility | Owner | Status | p95 (ms) | Notes |
| :--- | :--- | :---: | :--- | ---: | :--- |
| `worker-1` | **Deploy the documentation site** | Documentation | `disabled` | 111.0 | See [runbook](https://example.com/runbooks/3) before changing defaults. |
| `cache-2` | Rotate an API credential | Security | Needs follow-up | 124.0 | Never paste credentials into logs, terminal recordings, or bug reports. |
| `scheduler-3` | **Warm the application cache** | Application platform | Verified | 137.0 | `not measured` until the rehearsal finishes |
| `indexer-4` | Inspect a failed background job | Data operations | Scheduled | 150.0 | See [runbook](https://example.com/runbooks/6) before changing defaults. |
| `exporter-5` | **Validate a release candidate** | Release engineering | **Ready** | 163.0 | Verify the version string and the included runtime dependencies. |
| `notification service-6` | Restore a service backup | Reliability | In review | 176.0 | `not measured` until the rehearsal finishes |
| `editor-7` | **Investigate slow requests** | Observability | `disabled` | 189.0 | See [runbook](https://example.com/runbooks/9) before changing defaults. |
| `gateway-8` | Configure a development proxy | Networking | Needs follow-up | 202.0 | Confirm the proxy does not accidentally expose a private service. |
| `worker-9` | **Migrate a persisted setting** | Storage | Verified | 215.0 | `not measured` until the rehearsal finishes |

The latency column describes the release rehearsal rehearsal, not a service-level guarantee. Check a page with a table, a code example, and a nested checklist.
