# Lab 1: T-SQL Deep Dive

## Objective
Use AI to engineer and optimize production-grade SQL for OEE, shifts, alarms, and downtime.

## Tools
- SSMS 22.7.0
- SQL Server instance
- Copilot Chat in SSMS

## AI-first flow (majority AI work)
1. AI/chat work (majority):
  - Run Prompt Starter #1, Prompt Starter #2, and Prompt Starter #3 in Copilot Chat.
  - Refine at least one response to improve correctness or performance.
2. Manual execution work (supporting validation):
  - Run setup and validation scripts in SSMS and optional tSQLt execution.

## Setup
Run scripts in this order:
1. `scripts/01_schema.sql`
2. `scripts/02_seed_data.sql`
3. `scripts/03_challenges.sql`
4. Generate Challenge B output in chat or run fallback `scripts/06_oee_proc_reference.sql`
5. `scripts/04_validation.sql`
6. Optional (if tSQLt installed): `scripts/05_tsqlt_reference_tests.sql`

## How to perform the key steps
1. Execute `scripts/01_schema.sql`, `scripts/02_seed_data.sql`, and `scripts/03_challenges.sql` in order.
2. For Challenge A, ask Copilot for both readability-first and performance-first rewrites, then compare trade-offs.
3. For Challenge B, prompt Copilot to generate `dbo.usp_GetOeeByShift` using the input/output contract in `scripts/03_challenges.sql`.
4. If AI output is missing or weak, run fallback `scripts/06_oee_proc_reference.sql`.
5. Execute `scripts/04_validation.sql` and confirm OEE proc exists plus smoke output returns rows for a valid window.
6. If tSQLt is installed, execute `scripts/05_tsqlt_reference_tests.sql` and run `EXEC tSQLt.Run 'testWorkshopScada';`.

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
- Prompt Starter #1: "AI generates CTE/window-function queries for this challenge; return two versions with trade-offs and validation SQL."
- Prompt Starter #2: "Generate a stored procedure for OEE by shift using this schema and include robust parameter validation."
- Prompt Starter #3: "Explain this execution plan and provide a rewritten query plus index recommendations ranked by expected gain."

## Prompt Playbook (when and how to fill)
1. Before running Prompt Starter #1 on Challenge A or Challenge C, fill section 2) Query Tuning Prompt.
2. Before running Prompt Starter #2 for `dbo.usp_GetOeeByShift`, fill section 3) Stored Procedure Prompt.
3. If you run Prompt Starter #3, update section 2) Query Tuning Prompt with the final rewrite request that produced the accepted SQL.
4. After validation, fill Validation Step with exact commands and outcomes from `scripts/04_validation.sql`, and optional `EXEC tSQLt.Run 'testWorkshopScada';`.

## Deliverables
- Optimized query pack (before and after)
- Stored procedure pack
- tSQLt test scripts
- Validation evidence from `scripts/04_validation.sql`

## Validation
- Runtime and/or logical read improvement recorded.
- Result parity between baseline and optimized query confirmed.
- Tests pass for normal and edge scenarios.
