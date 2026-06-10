# Lab 3: MCP + SQL Agents + Skills

## Objective
Ground Copilot on live SQL context and enforce repeatable SQL review behavior with custom agents and skill files.

## Tools
- SSMS 22.7.0
- VS 2026 (brief usage)
- NuGet MCP Server
- mcp-sqlserver-server (local TypeScript server)

## Part A: NuGet MCP Server (quick grounding)
1. Enable NuGet MCP Server in VS Copilot tools.
2. Prompt examples:
   - "Find the latest stable version of Microsoft.Data.SqlClient and summarize breaking changes risk for SQL Server workloads."
   - "Recommend stable package versions for mssql and related dependencies."
3. Capture one reusable dependency-audit prompt.

## Part B: Build and register mcp-sqlserver-server
1. Open `mcp-sqlserver-server`.
2. Run:
   - `npm install`
   - `npm run build`
3. Set environment variable `SQL_CONNECTION_STRING`.
4. Register server in Copilot MCP settings (stdio command: `node dist/index.js`).

## Part C: Live DB querying from chat
Use prompts that force real grounding:
- "Using MCP tool output only, list machines in fault state for more than 10 minutes."
- "Return alarm counts by severity for the current shift and include the SQL used."
- "Find the top downtime reason in the last 24 hours by total minutes."

## Part D: SQL agent and skills
1. Invoke custom agent: `.github/agents/tsql-reviewer.agent.md`.
2. Invoke workshop skills:
   - `.github/skills/workshop1-ai-ssms/SKILL.md`
   - `.github/skills/workshop1-completeness-gate/SKILL.md`
   - `.github/skills/sql-optimization-review/SKILL.md`
   - `.github/skills/sql-security-hardening/SKILL.md`
3. Ask the agent to review one reporting procedure and one tuning candidate query.

## Deliverables
- MCP registration config snapshot
- One live DB query transcript with grounded answer
- One agent review report with findings and fixes
- One saved prompt for each: dependency audit, live query, SQL review

## Validation
- Copilot responses reference actual schema/data returned via MCP.
- Agent findings produce at least one accepted SQL improvement.
- Skill-driven review output is reproducible across two different SQL files.
