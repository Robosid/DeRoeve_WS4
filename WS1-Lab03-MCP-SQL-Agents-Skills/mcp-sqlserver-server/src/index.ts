import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import sql from "mssql";
import { z } from "zod";

const connectionString = process.env.SQL_CONNECTION_STRING;
if (!connectionString) {
  throw new Error("SQL_CONNECTION_STRING environment variable is required.");
}

const server = new Server(
  { name: "mcp-sqlserver-server", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

const statusInputSchema = z.object({
  lineCode: z.string().optional(),
  minFaultMinutes: z.number().int().min(1).max(1440).default(10)
});

const alarmInputSchema = z.object({
  hoursBack: z.number().int().min(1).max(168).default(24)
});

const downtimeInputSchema = z.object({
  hoursBack: z.number().int().min(1).max(168).default(24)
});

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "query_machine_status",
        description: "Returns machines with fault durations above a threshold.",
        inputSchema: {
          type: "object",
          properties: {
            lineCode: { type: "string" },
            minFaultMinutes: { type: "integer", minimum: 1, maximum: 1440 }
          }
        }
      },
      {
        name: "query_alarm_summary",
        description: "Returns alarm counts by severity for a recent time window.",
        inputSchema: {
          type: "object",
          properties: {
            hoursBack: { type: "integer", minimum: 1, maximum: 168 }
          }
        }
      },
      {
        name: "query_downtime_summary",
        description: "Returns top downtime reasons for a recent time window.",
        inputSchema: {
          type: "object",
          properties: {
            hoursBack: { type: "integer", minimum: 1, maximum: 168 }
          }
        }
      }
    ]
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const pool = await sql.connect(connectionString);

  try {
    if (request.params.name === "query_machine_status") {
      const input = statusInputSchema.parse(request.params.arguments ?? {});
      const result = await pool
        .request()
        .input("lineCode", sql.NVarChar(20), input.lineCode ?? null)
        .input("minFaultMinutes", sql.Int, input.minFaultMinutes)
        .query(`
          SELECT
            l.LineCode,
            m.MachineCode,
            DATEDIFF(MINUTE, d.StartTime, ISNULL(d.EndTime, SYSUTCDATETIME())) AS FaultMinutes,
            d.ReasonCode
          FROM dbo.DowntimeEvents d
          JOIN dbo.Machines m ON m.MachineId = d.MachineId
          JOIN dbo.Lines l ON l.LineId = m.LineId
          WHERE d.IsPlanned = 0
            AND DATEDIFF(MINUTE, d.StartTime, ISNULL(d.EndTime, SYSUTCDATETIME())) >= @minFaultMinutes
            AND (@lineCode IS NULL OR l.LineCode = @lineCode)
          ORDER BY FaultMinutes DESC;
        `);

      return {
        content: [{ type: "text", text: JSON.stringify(result.recordset, null, 2) }]
      };
    }

    if (request.params.name === "query_alarm_summary") {
      const input = alarmInputSchema.parse(request.params.arguments ?? {});
      const result = await pool
        .request()
        .input("hoursBack", sql.Int, input.hoursBack)
        .query(`
          SELECT
            Severity,
            COUNT(*) AS AlarmCount
          FROM dbo.AlarmEvents
          WHERE AlarmTime >= DATEADD(HOUR, -@hoursBack, SYSUTCDATETIME())
          GROUP BY Severity
          ORDER BY Severity DESC;
        `);

      return {
        content: [{ type: "text", text: JSON.stringify(result.recordset, null, 2) }]
      };
    }

    if (request.params.name === "query_downtime_summary") {
      const input = downtimeInputSchema.parse(request.params.arguments ?? {});
      const result = await pool
        .request()
        .input("hoursBack", sql.Int, input.hoursBack)
        .query(`
          SELECT TOP (10)
            ReasonCode,
            SUM(DATEDIFF(MINUTE, StartTime, EndTime)) AS TotalMinutes,
            COUNT(*) AS EventCount
          FROM dbo.DowntimeEvents
          WHERE StartTime >= DATEADD(HOUR, -@hoursBack, SYSUTCDATETIME())
          GROUP BY ReasonCode
          ORDER BY TotalMinutes DESC;
        `);

      return {
        content: [{ type: "text", text: JSON.stringify(result.recordset, null, 2) }]
      };
    }

    return {
      content: [{ type: "text", text: `Unknown tool: ${request.params.name}` }],
      isError: true
    };
  } finally {
    await pool.close();
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
