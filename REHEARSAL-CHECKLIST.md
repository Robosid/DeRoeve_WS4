# Trainer Rehearsal Checklist (Validated on 2026-06-10)

Use this exact sequence to verify Workshop 4 before delivery.

## Fast Path (One Command)
Run from repo root:
- `./Run-Workshop-Rehearsal.ps1`

Optional flags:
- `./Run-Workshop-Rehearsal.ps1 -SkipMcp`
- `./Run-Workshop-Rehearsal.ps1 -SkipLegacyBuild`
- `./Run-Workshop-Rehearsal.ps1 -DatabaseName WorkshopRehearsal_Custom`

## 1) SQL End-to-End Rehearsal
1. Ensure local SQL Server is reachable on `localhost` with Windows auth.
2. Create a clean rehearsal database:
   - `sqlcmd -S localhost -E -b -d master -Q "IF DB_ID('WorkshopRehearsal_20260610') IS NOT NULL BEGIN ALTER DATABASE [WorkshopRehearsal_20260610] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [WorkshopRehearsal_20260610]; END; CREATE DATABASE [WorkshopRehearsal_20260610];"`
3. Run scripts in order against `WorkshopRehearsal_20260610`:
   - `WS1-Lab01-TSql-Deep-Dive/scripts/01_schema.sql`
   - `WS1-Lab01-TSql-Deep-Dive/scripts/02_seed_data.sql`
   - `WS1-Lab01-TSql-Deep-Dive/scripts/03_challenges.sql`
   - `WS1-Lab01-TSql-Deep-Dive/scripts/06_oee_proc_reference.sql` (fallback for Challenge B)
   - `WS1-Lab01-TSql-Deep-Dive/scripts/04_validation.sql`
   - `WS1-Lab01-TSql-Deep-Dive/scripts/05_tsqlt_reference_tests.sql` (safe skip when tSQLt absent)
   - `WS1-Lab02-Advanced-Reporting-SQL/scripts/01_reporting_views.sql`
   - `WS1-Lab02-Advanced-Reporting-SQL/scripts/02_ssrs_datasets.sql`
   - `WS1-Lab02-Advanced-Reporting-SQL/scripts/03_crystal_datasets.sql`
   - `WS1-Lab04-Security-Background-Agents/sql/01_insecure_starter.sql`
   - `WS1-Lab04-Security-Background-Agents/sql/03_fixed_reference.sql`
   - `WS1-Lab05-SSIS-AI-ETL-Engineering/sql/01_staging_tables.sql`
   - `WS1-Lab05-SSIS-AI-ETL-Engineering/sql/02_merge_upsert.sql`
   - `WS1-Lab05-SSIS-AI-ETL-Engineering/sql/03_error_handling.sql`
   - `WS1-Lab06-SSAS-AI-Semantic-Modeling/sql/01_semantic_source_views.sql`
   - `WS1-Lab06-SSAS-AI-Semantic-Modeling/sql/02_validation_baselines.sql`
4. Smoke-test key procedures:
   - `dbo.usp_GetOeeByShift`
   - `dbo.usp_DeviceLookup_Secure`
   - `dbo.usp_ProcessTelemetryBatch`

## 2) Lab 3 MCP Server Build + Startup
1. In `WS1-Lab03-MCP-SQL-Agents-Skills/mcp-sqlserver-server`:
   - `npm install`
   - `npm run build`
2. Start with env var:
   - `set SQL_CONNECTION_STRING=Server=localhost;Database=WorkshopRehearsal_20260610;Integrated Security=true;TrustServerCertificate=true`
   - `node dist/index.js`
3. Stop process after startup smoke-test.

## 3) Lab 4 Legacy Bridge Build
1. In `WS1-Lab04-Security-Background-Agents/LegacyScadaBridge`:
   - `dotnet restore -p:RestoreSources="https://api.nuget.org/v3/index.json"`
   - `dotnet build -c Debug -p:RestoreSources="https://api.nuget.org/v3/index.json"`
2. Expect vulnerability warnings (intentional for remediation exercise), but build should succeed.

## Expected Outcomes
- SQL scripts execute cleanly in a fresh database.
- `OeeProcObjectId` is not null after fallback proc script.
- MCP server compiles and starts without runtime exception.
- Legacy bridge compiles with warning-only output.
