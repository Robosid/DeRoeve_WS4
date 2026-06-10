This repository is for preparing Workshop 4 only: an AI-first workshop for IIoT/SCADA SQL developers.

Date baseline for feature assumptions: June 10, 2026.

Environment baseline:
- SQL Server Management Studio: 22.7.0 (local installed baseline for workshop execution).
- Visual Studio: 2026 (18.6.x).
- If public docs lag behind local build behavior, prioritize validated local behavior during workshop delivery.

Audience profile:
- 8 internal developers.
- Primary day-to-day tool is SSMS and SQL Server work.
- Some participants also touch C#, but this is not a C#-first workshop.

Core workshop objective:
- Teach practical AI workflows for SQL, reporting, and industrial data systems.
- Keep the workshop SSMS-dominant and production-relevant.
- Ensure every activity uses AI directly (not a plain SSMS class).

Hard constraints (non-negotiable):
1. Workshop has no time limit; use a 3-hour core track plus advanced extension modules.
2. Scope is AI with SSMS, not SSMS alone.
3. Every lab must include explicit AI actions and AI outputs.
4. Keep VS usage brief and only where it directly supports SQL/SSMS outcomes.
5. Do not use generic retail examples; use IIoT/SCADA/manufacturing scenarios.
6. Keep technical depth high and practical for internal engineers.
7. Do not remove previously agreed modules; only add depth and coverage.
8. Keep guidance current to June 10, 2026 capabilities and model availability in the local toolchain.

Model strategy (validated in local VS 2026 model picker):
- GPT Codex 5.3: code generation, scaffolding, completions, boilerplate.
- Claude Sonnet 4.6: reasoning-heavy analysis, agent tasks, architecture, security reviews.
- Claude Haiku 4.5: quick low-latency iterations.
- GPT 5.4: broad-context reasoning and long specifications.
- MAI-Code-1-Flash: fast repetitive coding patterns.

Freshness notes (June 2026):
- Use configurable reasoning levels and larger context windows where available in Copilot experiences.
- Do not assume model availability from web announcements unless visible in local picker; local picker is source of truth.

Final Workshop 4 table (frozen baseline + mandatory extended modules):

| Lab | Time | Primary Tool | Focus | Mandatory AI Usage | Concrete Output |
|---|---:|---|---|---|---|
| 0. Setup + AI Operating Model | 15 min | SSMS | Align on AI-first workflow | Model picker strategy, prompt structure, context refs, slash commands, reusable prompt template | Team prompt playbook v1 |
| 1. T-SQL Deep Dive | 55 min | SSMS | Complex SQL engineering | AI generates CTE/window-function queries, stored procs for OEE/shift/alarm logic, execution-plan explanation + rewrite suggestions, indexed-view candidates, tSQLt tests | Optimized query pack + before/after plan evidence + tSQLt tests |
| 2. Advanced T-SQL for Reporting | 45 min | SSMS | SSRS/Crystal reporting SQL | AI drafts SSRS dataset SQL, parameterized filters, shift/downtime rollups, legacy proc explanation and cleanup, report expression suggestions | Production-ready reporting SQL set |
| 3. MCP + SQL Agents + Skills | 35 min | SSMS + brief VS 2026 | Live data grounding for AI | NuGet MCP Server setup, mcp-sqlserver-server registration, live DB querying from chat, custom SQL agent invocation, skill-file invocation | MCP config + SQL agent + skill files |
| 4. Security + Background Agents (SQL-focused) | 30 min | SSMS + brief VS 2026 | Hardening + modernization | AI security audit for SQL injection/hardcoded creds/unsafe dynamic SQL, Test Agent for coverage gaps, Modernize Agent on LegacyScadaBridge, NuGet vulnerability remediation | Security remediation checklist + patched scripts + modernization diff |
| 5. SSIS AI ETL Engineering (mandatory extension) | Flexible | SSMS + SSIS tools | Advanced ETL patterns for IIoT pipelines | AI designs package control/data flow, idempotent upsert strategy, dedup logic, late-arriving telemetry handling, retry + error-routing paths, and package validation checklists | SSIS package blueprint + SQL merge scripts + failure-handling runbook |
| 6. SSAS AI Semantic Modeling (mandatory extension) | Flexible | SSMS + SSAS tools | Analytics model design for production dashboards | AI proposes tabular model layout, dimensional mapping, DAX measures for OEE/availability/performance/quality, partitioning and incremental refresh strategy, and validation queries | SSAS model design spec + DAX measure pack + refresh strategy artifact |

Explicit advanced elements that must appear in generated materials:
- NuGet MCP Server.
- mcp-sqlserver-server.
- Custom agent (.agent.md) for SQL review workflows.
- Skill files in .github/skills/ for reusable SQL optimization and security checks.
- .github/skills/workshop1-ssis-etl/SKILL.md for SSIS module generation.
- .github/skills/workshop1-ssas-semantic/SKILL.md for SSAS module generation.
- Test Agent for test coverage gaps.
- Modernize Agent on a legacy .NET SCADA bridge.
- SSRS and Crystal reporting coverage.
- SSIS ETL engineering coverage.
- SSAS semantic modeling coverage.

Extended mandatory modules for complete workshop:
- SSIS: ETL package flow, idempotent upsert, dedup, retry/error paths, and operational error handling.
- SSAS: tabular model design, DAX measure generation, partitioning, and incremental refresh strategy.

Definition of done for every lab:
1. A reusable prompt template is captured.
2. A generated or fixed SQL/config artifact is produced.
3. Validation evidence is recorded (runtime delta, execution plan improvement, row correctness, or test pass).

When generating workshop assets (agendas, scripts, readmes, starter projects):
- Follow the frozen table above unless the user explicitly changes it.
- Preserve the table wording verbatim for the Mandatory AI Usage column; do not paraphrase or shorten those entries.
- Keep language concrete and implementation-oriented.
- Prioritize real industrial constraints: noisy telemetry, shift boundaries, legacy schemas, and incident response.