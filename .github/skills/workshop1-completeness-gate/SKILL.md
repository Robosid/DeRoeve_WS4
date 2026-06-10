---
name: workshop1-completeness-gate
description: 'Review Workshop 4 content for omissions and regressions. Use when validating that all mandatory advanced AI elements are present: NuGet MCP Server, mcp-sqlserver-server, Test Agent, Modernize Agent, SSRS/Crystal, and AI-first outputs per lab.'
argument-hint: 'Provide the file(s) to validate and request a pass/fail checklist.'
user-invocable: true
---

# Workshop 4 Completeness Gate

## Purpose
Prevent missed requirements when creating or editing Workshop 4 content.

## Use Cases
- Final review before sharing plan with lead developer.
- Checking revised agendas after scope changes.
- Verifying generated lab instructions.

## Pass/Fail Checklist
Mark each item pass/fail with evidence.

### Scope and Audience
- Workshop is for the 8 IIoT/SCADA SQL developers.
- Format is AI with SSMS (not SSMS-only and not VS-heavy).
- No time-limit structure is allowed and should include at least the core modules plus extended modules.
- Baseline explicitly states June 10, 2026 currency and SSMS 22.7.0 local execution target.

### Lab Coverage
- Includes all of these modules:
  - Setup + AI operating model
  - T-SQL deep dive
  - Advanced T-SQL for SSRS/Crystal
  - MCP + SQL agents + skills
  - Security + background agents
  - SSIS AI ETL engineering
  - SSAS AI semantic modeling

### Mandatory Advanced Features
- NuGet MCP Server explicitly named.
- mcp-sqlserver-server explicitly named.
- Test Agent explicitly named.
- Modernize Agent explicitly named and tied to LegacyScadaBridge.
- Skill files explicitly included under .github/skills.
- .github/skills/workshop1-ssis-etl/SKILL.md explicitly present or referenced.
- .github/skills/workshop1-ssas-semantic/SKILL.md explicitly present or referenced.
- Custom SQL agent (.agent.md) included.
- SSIS module explicitly included with ETL and error-handling patterns.
- SSAS module explicitly included with DAX and refresh/partition strategy.
- No previously agreed module removed.
- Model/tool usage reflects locally validated availability; no unverified model claims.

### AI-First Evidence
For every lab, verify all 3 outputs exist:
- Prompt template.
- Generated/fixed artifact.
- Validation evidence.

### Technical Relevance
- Uses IIoT/SCADA scenarios (telemetry, shift reporting, alarms, downtime).
- No generic retail examples.
- Security framing for industrial systems is present.

## Output Format
Return:
1. Overall status: PASS or FAIL.
2. Failed checks with exact missing items.
3. Minimal fix list in priority order.
