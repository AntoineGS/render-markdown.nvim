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
