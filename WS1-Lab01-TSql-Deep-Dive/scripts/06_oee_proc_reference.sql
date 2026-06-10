SET NOCOUNT ON;
GO

/*
Instructor fallback reference implementation for Challenge B.
Use this only when AI-generated output is unavailable during delivery.
*/
CREATE OR ALTER PROCEDURE dbo.usp_GetOeeByShift
    @ShiftStart DATETIME2,
    @ShiftEnd DATETIME2,
    @LineCode NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @ShiftStart IS NULL OR @ShiftEnd IS NULL OR @ShiftStart >= @ShiftEnd
        THROW 50001, 'Invalid shift window: @ShiftStart must be before @ShiftEnd.', 1;

    ;WITH Prod AS
    (
        SELECT
            l.LineCode,
            m.MachineCode,
            SUM(pe.GoodCount) AS TotalGood,
            SUM(pe.RejectCount) AS TotalReject,
            SUM(pe.GoodCount + pe.RejectCount) AS TotalProduced,
            COUNT_BIG(*) * 3.0 AS PlannedMinutes,
            SUM(CAST(m.NominalPartsPerHour AS DECIMAL(18,4)) / 60.0 * 3.0) AS IdealOutput
        FROM dbo.ProductionEvents pe
        JOIN dbo.Machines m ON m.MachineId = pe.MachineId
        JOIN dbo.Lines l ON l.LineId = m.LineId
        WHERE pe.EventTime >= @ShiftStart
          AND pe.EventTime < @ShiftEnd
          AND (@LineCode IS NULL OR l.LineCode = @LineCode)
        GROUP BY l.LineCode, m.MachineCode
    ),
    Dt AS
    (
        SELECT
            l.LineCode,
            m.MachineCode,
            SUM(DATEDIFF(MINUTE, d.StartTime, d.EndTime)) AS DowntimeMinutes
        FROM dbo.DowntimeEvents d
        JOIN dbo.Machines m ON m.MachineId = d.MachineId
        JOIN dbo.Lines l ON l.LineId = m.LineId
        WHERE d.StartTime < @ShiftEnd
          AND d.EndTime > @ShiftStart
          AND (@LineCode IS NULL OR l.LineCode = @LineCode)
        GROUP BY l.LineCode, m.MachineCode
    ),
    Kpi AS
    (
        SELECT
            p.LineCode,
            p.MachineCode,
            CAST((p.PlannedMinutes - ISNULL(d.DowntimeMinutes, 0.0)) / NULLIF(p.PlannedMinutes, 0.0) AS DECIMAL(10,4)) AS AvailabilityPct,
            CAST(p.TotalProduced / NULLIF(p.IdealOutput, 0.0) AS DECIMAL(10,4)) AS PerformancePct,
            CAST(1.0 * p.TotalGood / NULLIF(p.TotalProduced, 0.0) AS DECIMAL(10,4)) AS QualityPct
        FROM Prod p
        LEFT JOIN Dt d
            ON d.LineCode = p.LineCode
           AND d.MachineCode = p.MachineCode
    )
    SELECT
        k.LineCode,
        k.MachineCode,
        k.AvailabilityPct,
        k.PerformancePct,
        k.QualityPct,
        CAST(k.AvailabilityPct * k.PerformancePct * k.QualityPct AS DECIMAL(10,4)) AS OEEPct
    FROM Kpi k
    ORDER BY k.LineCode, k.MachineCode;
END;
GO
