# Lab 5: SSIS AI ETL Engineering

## Objective
Design and harden an AI-assisted SSIS pattern for industrial telemetry ingestion with idempotent upsert, deduplication, and robust error handling.

## Tools
- SSMS 22.7.0
- SSIS tooling
- Copilot (SSMS + VS brief support)

## Setup
Run scripts in this order:
1. `sql/01_staging_tables.sql`
2. `sql/02_merge_upsert.sql`
3. `sql/03_error_handling.sql`

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
- "Design an SSIS package for IIoT telemetry with idempotent merge, dedup, and error-routing. Return control-flow and data-flow steps."
- "Harden this MERGE for replayed files and duplicate event IDs while preserving exactly-once semantics."
- "Generate an operational runbook for SSIS load failures with triage queries."

## Deliverables
- SSIS package blueprint
- SQL merge scripts
- Failure-handling runbook

## Validation
- Row parity between staging and target reconciles after dedup rules.
- Replaying the same batch does not duplicate target rows.
- Dead-letter table captures malformed rows with reason code.
