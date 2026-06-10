# Lab 1: T-SQL Deep Dive

## Objective
Use AI to engineer and optimize production-grade SQL for OEE, shifts, alarms, and downtime.

## Tools
- SSMS 22.7.0
- SQL Server instance
- Copilot Chat in SSMS

## Setup
Run scripts in this order:
1. `scripts/01_schema.sql`
2. `scripts/02_seed_data.sql`
3. `scripts/03_challenges.sql`
4. Generate Challenge B output in chat or run fallback `scripts/06_oee_proc_reference.sql`
5. `scripts/04_validation.sql`
6. Optional (if tSQLt installed): `scripts/05_tsqlt_reference_tests.sql`

## Exercises
1. CTE and window-function optimization
- Prompt Copilot to refactor challenge query into:
  - readability-first version
  - performance-first version
- Compare execution plans and logical reads.

2. Stored procedure generation
- Generate stored procedures for:
  - OEE by shift and machine
  - alarm counts by severity and time bucket
  - downtime summary by reason code

3. Execution plan explanation and rewrite
- Use `/explain` on a heavy query plan.
- Ask for targeted rewrite with index candidates and indexed-view options.

4. tSQLt tests
- Use `/tests` to generate tSQLt tests for one stored procedure.
- Add at least one edge-case assertion (empty shift, null reason code, out-of-order timestamps).

## Prompt Starters
- "AI generates CTE/window-function queries for this challenge; return two versions with trade-offs and validation SQL."
- "Generate a stored procedure for OEE by shift using this schema and include robust parameter validation."
- "Explain this execution plan and provide a rewritten query plus index recommendations ranked by expected gain."

## Deliverables
- Optimized query pack (before and after)
- Stored procedure pack
- tSQLt test scripts
- Validation evidence from `scripts/04_validation.sql`

## Validation
- Runtime and/or logical read improvement recorded.
- Result parity between baseline and optimized query confirmed.
- Tests pass for normal and edge scenarios.
