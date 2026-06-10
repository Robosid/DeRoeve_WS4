# Lab 2: Advanced T-SQL for Reporting

## Objective
Produce AI-assisted SQL datasets for SSRS and Crystal Reports that are production-safe and maintainable.

## Tools
- SSMS 22.7.0
- Copilot Chat in SSMS

## Setup
Run scripts in this order:
1. `scripts/01_reporting_views.sql`
2. `scripts/02_ssrs_datasets.sql`
3. `scripts/03_crystal_datasets.sql`

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
- "Draft SSRS dataset SQL for shift production with filters for date range, line, and machine, preserving index-friendly predicates."
- "Create Crystal Report dataset SQL with stable sort order and null-safe presentation fields."
- "Explain this legacy reporting proc and rewrite for readability, maintainability, and performance."

## Deliverables
- Production-ready reporting SQL set
- Cleaned legacy procedure
- Report expression suggestion pack

## Validation
- Dataset row counts reconcile to source tables.
- Parameter combinations return expected slices.
- Report sorting and grouping are deterministic.
