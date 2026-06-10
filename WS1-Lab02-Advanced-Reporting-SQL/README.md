# Lab 2: Advanced T-SQL for Reporting

## Objective
Produce AI-assisted SQL datasets for SSRS and Crystal Reports that are production-safe and maintainable.

## Tools
- SSMS 22.7.0
- Copilot Chat in SSMS

## AI-first flow (majority AI work)
1. AI/chat work (majority):
  - Run Prompt Starter #1, Prompt Starter #2, and Prompt Starter #3 in Copilot Chat.
  - Ask AI for dataset refinements and expression suggestions.
2. Manual execution work (supporting validation):
  - Execute dataset SQL, rerun parameter combinations, and capture reconciliation checks.

## Setup
Run scripts in this order:
1. `scripts/01_reporting_views.sql`
2. `scripts/02_ssrs_datasets.sql`
3. `scripts/03_crystal_datasets.sql`

## How to perform the key steps
1. Execute setup scripts in order so views and datasets are available.
2. In `scripts/02_ssrs_datasets.sql`, change `@FromDate`, `@ToDate`, `@LineCode`, and `@ShiftName`, then rerun to show parameterized slicing.
3. Re-run the SSRS queries with at least two parameter combinations and compare row counts.
4. In `scripts/03_crystal_datasets.sql`, verify the flattened dataset is deterministic by rerunning and confirming stable ORDER BY output.
5. Verify null-safe projections in Crystal output (`ISNULL` columns for downtime fields) for rows without downtime matches.
6. Capture one reconciliation check between source views and rendered dataset output.

## Exercises
1. SSRS dataset generation
- Draft parameterized datasets for daily production report:
  - shift output
  - downtime by category
  - alarm trend by hour
- Include optional filters for line, machine, and shift.

2. Crystal dataset generation
- Build flattened datasets with deterministic sort order.
- Generate null-safe projections for display columns.

3. Legacy stored procedure cleanup
- Use AI to explain one legacy reporting procedure.
- Refactor to remove anti-patterns and simplify parameter handling.

4. Expression guidance
- Ask AI for report expression suggestions (formatting, percentages, KPI flags).

## Prompt Starters
- Prompt Starter #1: "Draft SSRS dataset SQL for shift production with filters for date range, line, and machine, preserving index-friendly predicates."
- Prompt Starter #2: "Create Crystal Report dataset SQL with stable sort order and null-safe presentation fields."
- Prompt Starter #3: "Explain this legacy reporting proc and rewrite for readability, maintainability, and performance."

## Prompt Playbook (when and how to fill)
1. Before Prompt Starter #1 and Prompt Starter #2, fill section 4) Reporting SQL Prompt.
2. Before Prompt Starter #3, fill section 3) Stored Procedure Prompt for legacy procedure cleanup.
3. After the accepted SQL is finalized, replace draft wording with the exact final prompt text that worked.
4. In Validation Step, record parameter sets used and reconciliation evidence (row counts or deterministic output checks).

## Deliverables
- Production-ready reporting SQL set
- Cleaned legacy procedure
- Report expression suggestion pack

## Validation
- Dataset row counts reconcile to source tables.
- Parameter combinations return expected slices.
- Report sorting and grouping are deterministic.
