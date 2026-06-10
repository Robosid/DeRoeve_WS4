# Lab 5: SSIS AI ETL Engineering

## Objective
Design and harden an AI-assisted SSIS pattern for industrial telemetry ingestion with idempotent upsert, deduplication, and robust error handling.

## Tools
- SSMS 22.7.0
- SSIS tooling
- Copilot (SSMS + VS brief support)

## AI-first flow (majority AI work)
1. AI/chat work (majority):
  - Run Prompt Starter #1, Prompt Starter #2, and Prompt Starter #3 in Copilot Chat.
  - Refine merge-hardening and failure-runbook outputs with at least one follow-up.
2. Manual execution work (supporting validation):
  - Execute setup SQL and replay tests to validate deduplication and reject handling.

## Setup
Run scripts in this order:
1. `sql/01_staging_tables.sql`
2. `sql/02_merge_upsert.sql`
3. `sql/03_error_handling.sql`

## How to perform the key steps
1. Execute setup scripts in order to create staging, merge logic, and batch error handling procedure.
2. Prompt AI for package control flow plus data flow (landing, staging, quality checks, merge, reject path).
3. Load sample rows into `dbo.TelemetryStaging`, including duplicate `MessageId` values and one malformed row.
4. Run `EXEC dbo.usp_ProcessTelemetryBatch @SourceFileName = N'<batch-file-name>';`.
5. Re-run the same batch and confirm replay safety (no duplicate rows in `dbo.TelemetryFact`).
6. Verify malformed rows are captured in `dbo.TelemetryRejects` with clear reject reasons.
7. Save the final package blueprint and failure-handling runbook.

## Exercises
1. Package flow design
- Prompt AI to design control flow and data flow components for:
  - landing file ingest
  - staging load
  - quality checks
  - merge to fact table
  - reject/error branch

2. Idempotent upsert and dedup
- Use provided merge pattern and ask AI for edge-case hardening:
  - duplicate message ids
  - out-of-order event timestamps
  - replayed batch files

3. Late-arriving telemetry
- Ask AI to implement watermark logic and late-arrival policy.

4. Retry and error routing
- Ask AI to design retry policy and dead-letter handling with diagnostics.

## Prompt Starters
- Prompt Starter #1: "Design an SSIS package for IIoT telemetry with idempotent merge, dedup, and error-routing. Return control-flow and data-flow steps."
- Prompt Starter #2: "Harden this MERGE for replayed files and duplicate event IDs while preserving exactly-once semantics."
- Prompt Starter #3: "Generate an operational runbook for SSIS load failures with triage queries."

## Prompt Playbook (when and how to fill)
1. Before Prompt Starter #1 and Prompt Starter #3, fill section 6) Agent Prompt.
2. Before Prompt Starter #2, fill section 2) Query Tuning Prompt for the merge-hardening request.
3. If you change `dbo.usp_ProcessTelemetryBatch` contract expectations, fill section 3) Stored Procedure Prompt.
4. In Validation Step, record replay-safety results and reject-table evidence after rerunning the same batch.

## Deliverables
- SSIS package blueprint
- SQL merge scripts
- Failure-handling runbook

## Validation
- Row parity between staging and target reconciles after dedup rules.
- Replaying the same batch does not duplicate target rows.
- Dead-letter table captures malformed rows with reason code.
