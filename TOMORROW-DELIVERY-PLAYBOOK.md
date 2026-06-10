# Tomorrow Delivery Playbook (Workshop 4)

## Validation status before session
- Validated on this machine on 2026-06-10.
- One-click rehearsal command returned PASS.
- Command: .\Run-Workshop-Rehearsal.ps1

## Repo setup and ownership
1. Participants must have a local copy of this workshop repo before labs begin.
   - Preferred: clone from your internal source.
   - Alternative: copy the prepared workshop folder from a shared drive or USB.
2. The full rehearsal command .\Run-Workshop-Rehearsal.ps1 is instructor-only by default.
3. Participants do not need to run the full rehearsal unless you explicitly ask them to troubleshoot their machine.

## Instructor pre-flight (T-45 to T-10)
1. Open SSMS and connect to local SQL Server.
	- Server type: Database Engine
	- Server name: localhost
	- Authentication: Windows Authentication
	- Click Connect
	- This was validated against local instance: DRIPORT143 (service: MSSQLSERVER)
2. Open VS 2026 for Lab 3 and Lab 4 folders.
3. Run .\Run-Workshop-Rehearsal.ps1 from repo root (instructor machine only).
4. Confirm final line says REHEARSAL_RESULT: PASS.
5. Keep these fallback files ready:
- WS1-Lab01-TSql-Deep-Dive/scripts/06_oee_proc_reference.sql
- WS1-Lab04-Security-Background-Agents/README.md (NuGet restore fallback)
- WS1-Lab01-TSql-Deep-Dive/scripts/05_tsqlt_reference_tests.sql (safe skip when tSQLt absent)

## Opening script (first 5 minutes)
Tell participants:
1. This is AI with SSMS for real IIoT and SCADA work, not a generic SSMS class.
2. Every lab must produce three things: reusable prompt, artifact, and validation evidence.
3. We prioritize production-safe SQL behavior and measurable verification.
4. VS usage is intentionally brief and only where SQL outcomes require it.

## Participant operating rules
Tell participants to do this in every lab:
1. Keep prompts concrete with schema and constraints.
2. Ask AI for two outputs when useful: readability-first and performance-first.
3. Validate every AI output before accepting it.
4. Save outputs in each lab folder under outputs.

## Core track run-of-show (3 hours)

### Lab 0 (15 min)
You do:
1. Show model picker routing by task type.
2. Demonstrate context references and slash commands.
3. Run one prompt and one follow-up refinement.
Participants do:
1. Complete one prompt drill.
2. Save one reusable prompt in the team playbook.
Success check:
- Team prompt playbook captured and reusable.

### Lab 1 (55 min)
You do:
1. Run setup scripts 01, 02, 03.
2. Demonstrate Challenge B AI generation for OEE procedure.
3. If needed, run fallback script 06 to keep flow stable.
4. Run validation script 04 and discuss parity and stats.
Participants do:
1. Generate CTE and window-function alternatives.
2. Generate and validate one procedure.
3. Capture before and after evidence.
Success check:
- OEE proc exists and validation output is sensible.

### Lab 2 (45 min)
You do:
1. Run reporting scripts 01 to 03.
2. Show parameterized SSRS and Crystal dataset patterns.
3. Demonstrate cleanup of legacy reporting SQL anti-patterns.
Participants do:
1. Produce one SSRS dataset and one Crystal dataset.
2. Test multiple parameter combinations.
3. Save expression suggestions for reporting.
Success check:
- Dataset outputs reconcile and sorting is deterministic.

### Lab 3 (35 min, brief VS)
You do:
1. Build MCP server with npm install and npm run build.
2. Set SQL_CONNECTION_STRING and register MCP server.
3. Demonstrate one grounded query from chat output.
Participants do:
1. Run one grounded alarm or downtime query.
2. Run one custom agent review using SQL skills.
3. Save transcript evidence.
Success check:
- Chat response clearly references real DB output.

### Lab 4 (30 min, brief VS)
You do:
1. Run insecure starter SQL and explain exploit paths.
2. Demonstrate secure rewrite and allow-list sort handling.
3. Build LegacyScadaBridge with secure restore source when needed.
Participants do:
1. Run security audit prompts.
2. Patch dynamic SQL and verify payloads fail safely.
3. Review modernization output and note accepted changes.
Success check:
- Secure procedure behaves correctly and project compiles.

## Mandatory extension modules (after core)

### Lab 5 SSIS AI ETL Engineering
You do:
1. Run staging, merge, and error-handling scripts.
2. Demonstrate dedup and replay-safe behavior.
Participants do:
1. Produce package blueprint and failure runbook.
2. Validate idempotent upsert behavior.
Success check:
- Replay does not duplicate target rows.

### Lab 6 SSAS AI Semantic Modeling
You do:
1. Run semantic source views and baseline validation SQL.
2. Demonstrate DAX to SQL parity workflow.
Participants do:
1. Produce model layout and DAX KPI measures.
2. Validate parity for OEE, Availability, Performance, Quality.
Success check:
- KPI parity evidence is captured.

## What to say when something breaks
1. If OEE proc is missing, run Lab 1 fallback script 06 and continue.
2. If tSQLt is not installed, continue with script 05 safe-skip behavior.
3. If NuGet restore is blocked by HTTP source policy, run:
- dotnet restore -p:RestoreSources="https://api.nuget.org/v3/index.json"
4. If MCP server compile fails, run npm install then npm run build again.

## End-of-day close
Tell participants to submit:
1. One reusable prompt pack.
2. One validated SQL artifact per lab.
3. One evidence snapshot per lab (plan, runtime, row parity, or test result).

Reference files:
- README.md
- REHEARSAL-CHECKLIST.md
- Run-Workshop-Rehearsal.ps1
