SET NOCOUNT ON;
GO

/*
Lab 0 standalone query for prompt drills.
This script is self-contained and does not depend on workshop tables.
*/
WITH Telemetry AS
(
    SELECT *
    FROM (VALUES
        (N'A-PRESS-01', DATEADD(MINUTE, -35, SYSUTCDATETIME()), 120, 3, CAST(85.2 AS DECIMAL(6,2)), 2),
        (N'A-PRESS-01', DATEADD(MINUTE, -20, SYSUTCDATETIME()), 118, 5, CAST(86.1 AS DECIMAL(6,2)), 3),
        (N'A-PRESS-01', DATEADD(MINUTE, -10, SYSUTCDATETIME()), 122, 2, CAST(84.9 AS DECIMAL(6,2)), 1),
        (N'B-WELD-02',  DATEADD(MINUTE, -30, SYSUTCDATETIME()), 96,  7, CAST(91.3 AS DECIMAL(6,2)), 4),
        (N'B-WELD-02',  DATEADD(MINUTE, -12, SYSUTCDATETIME()), 101, 4, CAST(89.7 AS DECIMAL(6,2)), 2),
        (N'C-PACK-03',  DATEADD(MINUTE, -25, SYSUTCDATETIME()), 140, 1, CAST(78.4 AS DECIMAL(6,2)), 1)
    ) AS v(MachineCode, EventTime, GoodCount, RejectCount, TemperatureC, AlarmSeverity)
)
SELECT
    t.MachineCode,
    CAST(t.EventTime AS DATE) AS EventDate,
    SUM(t.GoodCount) AS TotalGood,
    SUM(t.RejectCount) AS TotalReject,
    CAST(SUM(t.RejectCount) * 100.0 / NULLIF(SUM(t.GoodCount + t.RejectCount), 0) AS DECIMAL(10,2)) AS RejectPct,
    CAST(AVG(t.TemperatureC) AS DECIMAL(10,2)) AS AvgTempC,
    SUM(CASE WHEN t.AlarmSeverity >= 3 THEN 1 ELSE 0 END) AS Sev3PlusAlarms
FROM Telemetry t
WHERE CONVERT(DATE, t.EventTime) = CONVERT(DATE, SYSUTCDATETIME())
GROUP BY t.MachineCode, CAST(t.EventTime AS DATE)
ORDER BY t.MachineCode;
GO
