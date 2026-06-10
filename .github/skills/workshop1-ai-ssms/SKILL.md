---
name: workshop1-ai-ssms
description: 'Generate and update Workshop 4 (AI with SSMS) materials for IIoT/SCADA SQL developers. Use for agendas, lab guides, prompts, starter scripts, and instructor flows. Trigger on: ssms workshop, sql copilot workshop, iiot/scada workshop, workshop 4, ai with ssms, t-sql lab, reporting sql lab, mcp sql lab, background agents sql.'
argument-hint: 'State the deliverable you want: agenda, lab guide, scripts, prompts, or full workshop pack.'
user-invocable: true
---

# Workshop 4: AI with SSMS

## Purpose
Create practical, advanced workshop content for an SSMS-dominant audience while keeping every module AI-first.

## Audience and Scope
- Audience: 8 IIoT/SCADA SQL developers.
- Primary tool: SSMS.
- VS usage: brief and only where directly tied to SQL outcomes.
- Duration target: no time limit. Use 3-hour core track plus mandatory extended modules.
- Baseline versions: SSMS 22.7.0 (local), VS 2026 18.6.x, feature currency date June 10, 2026.

## Required Baseline
Use the frozen table from [.github/copilot-instructions.md](../../copilot-instructions.md).

## When to Use
- Building Workshop 4 agenda and sequence.
- Writing lab instructions for SSMS/T-SQL/reporting.
- Creating AI prompt packs for SQL tasks.
- Creating or revising MCP + agent + skill exercises.
- Regenerating workshop artifacts after scope changes.

## Mandatory Lab Flow
1. Setup + AI operating model.
2. T-SQL deep dive.
3. Advanced T-SQL for SSRS/Crystal reporting.
4. MCP + SQL agents + skill files.
5. Security + background agents.
6. SSIS AI ETL engineering.
7. SSAS AI semantic modeling.

## Mandatory Advanced Elements
- NuGet MCP Server.
- mcp-sqlserver-server.
- SQL custom agent (.agent.md).
- Skill files in .github/skills/.
- .github/skills/workshop1-ssis-etl/SKILL.md.
- .github/skills/workshop1-ssas-semantic/SKILL.md.
- Test Agent for coverage gaps.
- Modernize Agent on LegacyScadaBridge.
- SSRS and Crystal dataset SQL coverage.
- SSIS ETL package design, idempotent upsert, retry/error routing.
- SSAS tabular model design, DAX measures, partitioning strategy.

## AI-First Rule
Every lab must include:
1. Prompt Copilot.
2. Generate output.
3. Validate output (plan/runtime/tests/rows).
4. Refine with follow-up prompt.
5. Save reusable prompt pattern.

## Required Outputs Per Lab
- Prompt template.
- SQL/config/code artifact.
- Validation evidence.

## Content Quality Rules
- Use industrial scenarios only (IIoT telemetry, alarms, shifts, downtime).
- Avoid generic examples.
- Keep instructions actionable and implementation-level.
- Include concrete acceptance criteria for each lab.
- Do not remove previously agreed modules; add depth without regression.
- Resolve feature/version ambiguity by preferring validated local tool behavior over older public docs.
