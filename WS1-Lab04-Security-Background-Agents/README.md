# Lab 4: Security + Background Agents (SQL-focused)

## Objective
Harden SQL and legacy bridge code using AI-assisted security review, Test Agent, and Modernize Agent.

## Tools
- SSMS 22.7.0
- VS 2026 (brief)
- Test Agent
- Modernize Agent

## Setup
1. Run `sql/01_insecure_starter.sql`.
2. Run `sql/02_security_fix_targets.sql` to load hardening targets and negative payloads.
3. Review insecure patterns and exploit paths.
4. Open `LegacyScadaBridge` in VS for modernization pass.
5. If restore fails due HTTP NuGet feed policy, run:
	- `dotnet restore -p:RestoreSources="https://api.nuget.org/v3/index.json"`

## AI-first flow (majority AI work)
1. AI/chat and agent work (majority):
	- Run Security Audit Prompt #1, Secure Rewrite Prompt #2, and Verification Prompt #3 in Copilot Chat.
	- Run Test Agent for coverage gaps and Modernize Agent for `LegacyScadaBridge` review.
	- Agent identity note: Test Agent and Modernize Agent are built-in VS 2026 Copilot agents (selected from the agent picker), not repo agent files.
2. Repo custom agent note:
	- `.github/agents/tsql-reviewer.agent.md` is the custom SQL reviewer used in Lab 3.
3. Manual execution work (supporting validation):
	- Execute setup scripts and run generated SQL in an SSMS New Query window.
	- Execute payload tests and build commands to validate AI-generated fixes.

## Exercises
1. SQL security audit
- Security Audit Prompt #1: "Perform a SQL security audit for injection, hardcoded credentials, and unsafe dynamic SQL. Return fixes with patched SQL."
- Secure Rewrite Prompt #2: "Rewrite dbo.usp_LegacyDeviceLookup as dbo.usp_DeviceLookup_Secure using strict allow-list sort handling, QUOTENAME for identifier safety, and sp_executesql parameterization for data values. Return full CREATE OR ALTER PROCEDURE SQL."
- Verification Prompt #3: "Generate an SSMS execution checklist and SQL test batch to validate allow-list sort behavior, malicious sort payload handling, and expected safe fallback behavior for dbo.usp_DeviceLookup_Secure."
- Use skill: `.github/skills/sql-security-hardening/SKILL.md`

2. Coverage gaps
- Run Test Agent against patched SQL and related integration checks.
- Fill missing edge cases (malformed identifiers, empty filters, high cardinality input).

3. Modernization
- Run Modernize Agent on `LegacyScadaBridge`.
- Review generated diff and accept safe upgrades.

4. NuGet vulnerability remediation
- Scan dependencies in legacy bridge and apply safe upgrades.

## How to perform the key steps
1. Execute `sql/01_insecure_starter.sql` and `sql/02_security_fix_targets.sql` in SSMS.
2. In Copilot Chat, run Security Audit Prompt #1.
3. In Copilot Chat, run Secure Rewrite Prompt #2 and generate `dbo.usp_DeviceLookup_Secure`.
4. In Copilot Chat, run Verification Prompt #3 and capture the generated test checklist.
5. Apply secure patterns from AI output (or use `sql/03_fixed_reference.sql` as baseline reference).
6. Run all T-SQL commands below in an SSMS query window (New Query), not in Copilot chat.
7. Demonstrate allow-list sort handling with accepted inputs:
	- `DECLARE @MachineCode NVARCHAR(50) = (SELECT TOP (1) MachineCode FROM dbo.Machines ORDER BY MachineCode);`
	- `EXEC dbo.usp_DeviceLookup_Secure @MachineCode=@MachineCode, @SortColumn=N'EventTime';`
	- `EXEC dbo.usp_DeviceLookup_Secure @MachineCode=@MachineCode, @SortColumn=N'GoodCount';`
	- `EXEC dbo.usp_DeviceLookup_Secure @MachineCode=@MachineCode, @SortColumn=N'RejectCount';`
8. Demonstrate malicious sort payload handling (payload from `sql/02_security_fix_targets.sql`):
	- `DECLARE @MachineCode NVARCHAR(50) = (SELECT TOP (1) MachineCode FROM dbo.Machines ORDER BY MachineCode);`
	- `EXEC dbo.usp_DeviceLookup_Secure @MachineCode=@MachineCode, @SortColumn=N'EventTime; EXEC xp_cmdshell ''whoami'' --';`
9. Confirm injected text is not executed and secure output remains stable (safe default sort behavior is acceptable).
	- Quick SQL block (copy-paste in one shot into SSMS New Query):

```sql
DECLARE @MachineCode NVARCHAR(50) =
(
	SELECT TOP (1) MachineCode
	FROM dbo.Machines
	ORDER BY MachineCode
);

PRINT N'Allowed sort tests';
EXEC dbo.usp_DeviceLookup_Secure @MachineCode = @MachineCode, @SortColumn = N'EventTime';
EXEC dbo.usp_DeviceLookup_Secure @MachineCode = @MachineCode, @SortColumn = N'GoodCount';
EXEC dbo.usp_DeviceLookup_Secure @MachineCode = @MachineCode, @SortColumn = N'RejectCount';

PRINT N'Malicious payload test';
EXEC dbo.usp_DeviceLookup_Secure
	@MachineCode = @MachineCode,
	@SortColumn = N'EventTime; EXEC xp_cmdshell ''whoami'' --';
```
10. In VS Copilot Chat (Agent mode), select built-in **Test Agent** and run:
	- "Review the patched SQL and integration behavior for `dbo.usp_DeviceLookup_Secure`. Return missing tests for malformed identifiers, empty filters, and high-cardinality inputs, plus a minimal execution checklist."
11. In VS Copilot Chat (Agent mode), select built-in **Modernize Agent** and run:
	- "Review `LegacyScadaBridge` for safe modernization opportunities (nullable handling, outdated APIs, dependency updates, and logging hardening). Return a change list with risk level and rollback notes."
12. Build `LegacyScadaBridge`; if restore is blocked, use the documented NuGet restore fallback command.
13. Record accepted patches, coverage-gap findings, and modernization decisions.

## Prompt Playbook (when and how to fill)
1. Before Security Audit Prompt #1 and Secure Rewrite Prompt #2, fill section 5) Security Review Prompt.
2. Before Verification Prompt #3, Test Agent, or Modernize Agent runs, fill section 6) Agent Prompt with exact task and scope.
3. After patched SQL is accepted, update section 5) with the final prompt text and required fix type applied.
4. In Validation Step, record agent used (Test Agent or Modernize Agent), malicious payload test outcomes, coverage-gap status, and build/test status for accepted changes.

## Deliverables
- Security remediation checklist
- Patched SQL scripts
- AI transcript pack for Prompt #1, Prompt #2, and Prompt #3
- Test gap report and added tests
- Modernization diff summary for LegacyScadaBridge

## Validation
- Injection payloads fail safely.
- Dynamic SQL paths are parameterized.
- Prompt #1, #2, and #3 were each run and evidence was saved.
- Added tests pass.
- Modernized code compiles after accepted changes.
