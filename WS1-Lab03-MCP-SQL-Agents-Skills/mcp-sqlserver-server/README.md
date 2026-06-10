# mcp-sqlserver-server

## Purpose
Provide live SQL query tools to Copilot through MCP for Workshop 4.

## Prerequisites
- Node.js 20+
- SQL Server access
- Environment variable `SQL_CONNECTION_STRING`

## Setup
1. `npm install`
2. `npm run build`
3. `npm start`

## MCP Registration (example)
Use a stdio MCP entry pointing to:
- command: `node`
- args: `dist/index.js`
- cwd: this folder
- env: `SQL_CONNECTION_STRING`

## Exposed Tools
- `query_machine_status`
- `query_alarm_summary`
- `query_downtime_summary`
