# Workshop 4: AI with SSMS for IIoT/SCADA SQL Teams

## Baseline
- Date baseline: June 10, 2026
- SQL Server Management Studio: 22.7.0
- Visual Studio: 2026 (18.6.x)
- If public documentation lags local behavior, this workshop follows validated local behavior.

## Audience
- 8 internal developers
- SSMS-first workflow (SQL Server day-to-day)
- Some participants also write C#, but this is not a C#-first workshop

## Workshop Goal
Build practical, reusable AI workflows for SQL engineering, reporting, ETL, semantic modeling, and industrial system hardening in IIoT/SCADA environments.

## Frozen Workshop Table

| Lab | Time | Primary Tool | Focus | Mandatory AI Usage | Concrete Output |
|---|---:|---|---|---|---|
| 0. Setup + AI Operating Model | 15 min | SSMS | Align on AI-first workflow | Model picker strategy, prompt structure, context refs, slash commands, reusable prompt template | Team prompt playbook v1 |
| 1. T-SQL Deep Dive | 55 min | SSMS | Complex SQL engineering | AI generates CTE/window-function queries, stored procs for OEE/shift/alarm logic, execution-plan explanation + rewrite suggestions, indexed-view candidates, tSQLt tests | Optimized query pack + before/after plan evidence + tSQLt tests |
| 2. Advanced T-SQL for Reporting | 45 min | SSMS | SSRS/Crystal reporting SQL | AI drafts SSRS dataset SQL, parameterized filters, shift/downtime rollups, legacy proc explanation and cleanup, report expression suggestions | Production-ready reporting SQL set |
| 3. MCP + SQL Agents + Skills | 35 min | SSMS + brief VS 2026 | Live data grounding for AI | NuGet MCP Server setup, mcp-sqlserver-server registration, live DB querying from chat, custom SQL agent invocation, skill-file invocation | MCP config + SQL agent + skill files |
| 4. Security + Background Agents (SQL-focused) | 30 min | SSMS + brief VS 2026 | Hardening + modernization | AI security audit for SQL injection/hardcoded creds/unsafe dynamic SQL, Test Agent for coverage gaps, Modernize Agent on LegacyScadaBridge, NuGet vulnerability remediation | Security remediation checklist + patched scripts + modernization diff |
| 5. SSIS AI ETL Engineering (mandatory extension) | Flexible | SSMS + SSIS tools | Advanced ETL patterns for IIoT pipelines | AI designs package control/data flow, idempotent upsert strategy, dedup logic, late-arriving telemetry handling, retry + error-routing paths, and package validation checklists | SSIS package blueprint + SQL merge scripts + failure-handling runbook |
| 6. SSAS AI Semantic Modeling (mandatory extension) | Flexible | SSMS + SSAS tools | Analytics model design for production dashboards | AI proposes tabular model layout, dimensional mapping, DAX measures for OEE/availability/performance/quality, partitioning and incremental refresh strategy, and validation queries | SSAS model design spec + DAX measure pack + refresh strategy artifact |

## Model Strategy (Local Picker)
- GPT Codex 5.3: code generation, scaffolding, completions, boilerplate
- Claude Sonnet 4.6: reasoning-heavy analysis, agent tasks, architecture, security review
- Claude Haiku 4.5: fast iterations and lightweight rewrites
- GPT 5.4: broad-context reasoning and long specifications
- MAI-Code-1-Flash: fast repetitive coding patterns

## Lab Deliverables Rule (mandatory)
Every lab must produce:
1. Reusable prompt template
2. Generated/fixed SQL/config/code artifact
3. Validation evidence (runtime delta, plan improvement, row correctness, or test pass)

## Repository Map
- WS1-Lab00-Setup-AI-Operating-Model: operating model + prompt baseline
- WS1-Lab01-TSql-Deep-Dive: schema, seed data, query/proc optimization exercises
- WS1-Lab02-Advanced-Reporting-SQL: SSRS and Crystal reporting SQL exercises
- WS1-Lab03-MCP-SQL-Agents-Skills: NuGet MCP, mcp-sqlserver-server, SQL agent and skills
- WS1-Lab04-Security-Background-Agents: SQL hardening + Test/Modernize agent workflows
- WS1-Lab05-SSIS-AI-ETL-Engineering: ETL flow, idempotent upsert, retry/error handling
- WS1-Lab06-SSAS-AI-Semantic-Modeling: semantic model, DAX, partition/refresh strategy

## Prerequisites Checklist
- SSMS 22.7.0 installed and signed into Copilot
- VS 2026 18.6.x with Copilot enabled
- SQL Server instance (local or shared)
- Node.js 20+ for MCP server module
- NuGet feed access for MCP server package and dependency restore

## How to Use This Pack
1. Start with Lab 0 and capture the team prompt playbook.
2. Run Labs 1 to 4 as the core track.
3. Run Labs 5 and 6 as mandatory extended modules for complete coverage.
4. At the end of each lab, save outputs in each lab folder under a local `outputs` folder.

## Completeness Verification
Use the workshop completeness gate skill at the end of content updates:
- .github/skills/workshop1-completeness-gate/SKILL.md
