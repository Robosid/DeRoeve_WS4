---
name: workshop1-ssis-etl
description: 'Create and review SSIS-focused AI workshop content for IIoT/SCADA pipelines. Use for ETL package design, idempotent upsert, deduplication, retry/error routing, and operational runbooks in Workshop 4.'
argument-hint: 'Provide source tables, target tables, load cadence, and failure scenarios.'
user-invocable: true
---

# Workshop 4 SSIS ETL Module

## Purpose
Provide a repeatable AI-first lab flow for SSIS ETL work in industrial telemetry/reporting pipelines.

## When to Use
- Designing SSIS package control/data flows.
- Defining merge/upsert strategies for telemetry facts.
- Handling duplicate and late-arriving device events.
- Building retry/error-routing and operational troubleshooting paths.

## Required Procedure
1. Prompt Copilot to design the package topology.
2. Generate package flow artifacts and SQL merge scripts.
3. Validate with row-count reconciliation and duplicate handling checks.
4. Prompt Copilot for failure-mode hardening (timeouts, malformed rows, deadlocks).
5. Save reusable prompt templates.

## Mandatory Technical Coverage
- Idempotent upsert strategy.
- Deduplication logic.
- Late-arriving telemetry handling.
- Retry strategy and dead-letter/error tables.
- Observability checkpoints (load stats, reject counts, duration).

## Required Outputs
- SSIS package blueprint (control and data flow).
- SQL scripts for staging and merge.
- Error-handling runbook.
- Validation evidence (row parity and failure-path tests).
