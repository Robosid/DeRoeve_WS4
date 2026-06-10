# Lab 3: MCP + SQL Agents + Skills

## Objective
Ground Copilot on live SQL context and enforce repeatable SQL review behavior with custom agents and skill files.

## Tools
- SSMS 22.7.0
- VS 2026 (brief usage)
- NuGet MCP Server
- mcp-sqlserver-server (local TypeScript server)

## AI-first flow (majority AI work)
1. AI/chat and agent work (majority):
   - Run Dependency Prompts, Live DB Prompts, Tuning Review Prompt #1, and Security Review Prompt #1 in Copilot Chat.
   - Invoke custom agent and skills for repeatable SQL review behavior.
2. Manual execution work (supporting validation):
   - Build/register `mcp-sqlserver-server` and verify grounded tool output.

## Part A: NuGet MCP Server (quick grounding)
1. Try to enable NuGet MCP Server in VS Copilot tools:
   - Open Copilot Chat in VS.
   - Open the tools picker (wrench/tools icon near the prompt) and enable NuGet MCP Server if listed.
   - This is NuGet MCP (package metadata grounding), not Azure MCP.
   - If your build does not expose tools/MCP toggles, skip Part A and continue with Part B.
   - If enabled, verify it by running one NuGet prompt and confirming tool-grounded package output.
2. Dependency Prompts:
   - Dependency Prompt #1: "Find the latest stable version of Microsoft.Data.SqlClient and summarize breaking changes risk for SQL Server workloads."
   - Dependency Prompt #2: "Recommend stable package versions for mssql and related dependencies."
3. Capture one reusable dependency-audit prompt.

## Part B: Build and register mcp-sqlserver-server
1. Open `mcp-sqlserver-server`.
2. Run:
   - `npm install`
   - `npm run build`
3. Set environment variable `SQL_CONNECTION_STRING`.
4. Register server in Copilot MCP settings (stdio command: `node dist/index.js`).

## Part C: Live DB querying from chat
Use these live DB prompts in VS Copilot Chat after MCP registration:
- Live DB Prompt #1: "Using MCP tool output only, list machines in fault state for more than 10 minutes."
- Live DB Prompt #2: "Return alarm counts by severity for the current shift and include the SQL used."
- Live DB Prompt #3: "Find the top downtime reason in the last 24 hours by total minutes."

## Part D: SQL agent and skills
1. Invoke custom agent: `.github/agents/tsql-reviewer.agent.md`.
2. Invoke workshop skills:
   - `.github/skills/workshop1-ai-ssms/SKILL.md`
   - `.github/skills/workshop1-completeness-gate/SKILL.md`
   - `.github/skills/sql-optimization-review/SKILL.md`
   - `.github/skills/sql-security-hardening/SKILL.md`
3. Ask the agent to review one reporting procedure and one tuning candidate query.

Default review targets:
1. Reporting procedure target: `WS1-Lab02-Advanced-Reporting-SQL/scripts/03_crystal_datasets.sql` -> `dbo.usp_LegacyDailyReport`.
2. Tuning candidate query target: `WS1-Lab01-TSql-Deep-Dive/scripts/03_challenges.sql` -> Challenge C query.

Agent Review Prompts:
- Tuning Review Prompt #1: "Use agent .github/agents/tsql-reviewer.agent.md with skill .github/skills/sql-optimization-review/SKILL.md. Review the SQL in my active editor for correctness and performance in an IIoT workload. Return findings by severity, rewritten SQL (readability-first and performance-first), index candidates, and validation SQL for row parity."
- Security Review Prompt #1: "Use agent .github/agents/tsql-reviewer.agent.md with skill .github/skills/sql-security-hardening/SKILL.md. Review the SQL in my active editor for SQL injection, unsafe dynamic SQL, and credential leakage. Return patched SQL and verification steps."

## Prompt Playbook (when and how to fill)
1. Before Dependency Prompt #1 or #2, fill section 6) Agent Prompt with task = dependency audit.
2. Before any Live DB prompt, fill section 6) Agent Prompt with task = grounded SQL query and required artifact = SQL used.
3. Before Tuning Review Prompt #1 or Security Review Prompt #1, fill section 6) Agent Prompt and specify the active target (`03_challenges.sql` Challenge C or `usp_LegacyDailyReport`).
4. In Validation Step, record tool-grounded output evidence, the target reviewed, and the accepted SQL fix or recommendation.

## How to perform the key steps
1. Open Copilot Chat in VS and try to enable NuGet MCP Server from the tools picker (wrench/tools icon).
2. If NuGet MCP is available, verify grounding by running: "Find the latest stable version of Microsoft.Data.SqlClient and summarize breaking changes risk for SQL Server workloads."
3. If NuGet MCP is not available in your build, skip the dependency-grounding step and continue.
4. Open `mcp-sqlserver-server` in a VS terminal.
5. Run `npm install` and then `npm run build`.
6. Set `SQL_CONNECTION_STRING` before launching the server.
   - PowerShell example: `$env:SQL_CONNECTION_STRING = "Server=localhost;Database=Workshop4_<YourName>_LabDB;Integrated Security=true;TrustServerCertificate=true"`
   - Command Prompt example: `set SQL_CONNECTION_STRING=Server=localhost;Database=Workshop4_<YourName>_LabDB;Integrated Security=true;TrustServerCertificate=true`
7. Register MCP server in Copilot MCP settings using stdio command `node dist/index.js`.
8. Run one grounded Live DB prompt in VS Copilot Chat and confirm the answer cites real rows/schema.
9. Open `WS1-Lab01-TSql-Deep-Dive/scripts/03_challenges.sql`, select Challenge C query, and run Tuning Review Prompt #1 in VS Copilot Chat.
10. Open `WS1-Lab02-Advanced-Reporting-SQL/scripts/03_crystal_datasets.sql`, select `dbo.usp_LegacyDailyReport`, and run Tuning Review Prompt #1.
11. If doing security-focused review, run Security Review Prompt #1 instead.
12. Save the review findings.

## Deliverables
- MCP registration config snapshot
- One live DB query transcript with grounded answer
- One agent review report with findings and fixes
- One saved prompt for each: dependency audit, live query, SQL review

## Validation
- Copilot responses reference actual schema/data returned via MCP.
- Agent findings produce at least one accepted SQL improvement.
- Skill-driven review output is reproducible across two different SQL files.
