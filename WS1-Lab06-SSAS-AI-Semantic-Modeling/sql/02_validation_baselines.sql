SET NOCOUNT ON;
GO

/* SQL baseline for KPI parity checks */
WITH Prod AS
(
    SELECT
        m.MachineCode,
        SUM(pe.GoodCount) AS TotalGood,
        SUM(pe.RejectCount) AS TotalReject,
        SUM(pe.GoodCount + pe.RejectCount) AS TotalProduced,
        SUM(CAST(m.NominalPartsPerHour / 60.0 AS DECIMAL(18,4)) * 3.0) AS IdealOutput,
        COUNT(*) * 3.0 AS PlannedMinutes
    FROM dbo.ProductionEvents pe
    JOIN dbo.Machines m ON m.MachineId = pe.MachineId
    GROUP BY m.MachineCode
), Dt AS
(
    SELECT
        m.MachineCode,
        SUM(DATEDIFF(MINUTE, d.StartTime, d.EndTime)) AS DowntimeMinutes
    FROM dbo.DowntimeEvents d
    JOIN dbo.Machines m ON m.MachineId = d.MachineId
    GROUP BY m.MachineCode
)
SELECT
    p.MachineCode,
    p.TotalGood,
    p.TotalReject,
    CAST((p.PlannedMinutes - ISNULL(d.DowntimeMinutes, 0.0)) / NULLIF(p.PlannedMinutes, 0.0) AS DECIMAL(10,4)) AS AvailabilityPct,
    CAST(p.TotalProduced / NULLIF(p.IdealOutput, 0.0) AS DECIMAL(10,4)) AS PerformancePct,
    CAST(1.0 * p.TotalGood / NULLIF(p.TotalProduced, 0.0) AS DECIMAL(10,4)) AS QualityPct,
    CAST(
        ((p.PlannedMinutes - ISNULL(d.DowntimeMinutes, 0.0)) / NULLIF(p.PlannedMinutes, 0.0))
        * (p.TotalProduced / NULLIF(p.IdealOutput, 0.0))
        * (1.0 * p.TotalGood / NULLIF(p.TotalProduced, 0.0))
        AS DECIMAL(10,4)
    ) AS OeePct
FROM Prod p
LEFT JOIN Dt d ON d.MachineCode = p.MachineCode
ORDER BY p.MachineCode;
GO