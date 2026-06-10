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
2. Review insecure patterns and exploit paths.
3. Open `LegacyScadaBridge` in VS for modernization pass.
4. If restore fails due HTTP NuGet feed policy, run:
	- `dotnet restore -p:RestoreSources="https://api.nuget.org/v3/index.json"`

## Exercises
1. SQL security audit
- Prompt: "Perform a SQL security audit for injection, hardcoded credentials, and unsafe dynamic SQL. Return fixes with patched SQL."
- Use skill: `.github/skills/sql-security-hardening/SKILL.md`

2. Coverage gaps
- Run Test Agent against patched SQL and related integration checks.
- Fill missing edge cases (malformed identifiers, empty filters, high cardinality input).

3. Modernization
- Run Modernize Agent on `LegacyScadaBridge`.
- Review generated diff and accept safe upgrades.

4. NuGet vulnerability remediation
- Scan dependencies in legacy bridge and apply safe upgrades.

## Deliverables
- Security remediation checklist
- Patched SQL scripts
- Test gap report and added tests
- Modernization diff summary for LegacyScadaBridge

## Validation
- Injection payloads fail safely.
- Dynamic SQL paths are parameterized.
- Added tests pass.
- Modernized code compiles after accepted changes.
