SET NOCOUNT ON;
GO

/* SSRS Dataset: Shift Production */
DECLARE @FromDate DATE = CAST(SYSUTCDATETIME() AS DATE);
DECLARE @ToDate DATE = CAST(SYSUTCDATETIME() AS DATE);
DECLARE @LineCode NVARCHAR(20) = NULL;

SELECT
    ps.LineCode,
    ps.MachineCode,
    ps.ShiftName,
    ps.ShiftStart,
    ps.ShiftEnd,
    ps.TotalGood,
    ps.TotalReject,
    ps.RejectPct
FROM dbo.vw_ShiftProductionSummary ps
WHERE CAST(ps.ShiftStart AS DATE) BETWEEN @FromDate AND @ToDate
  AND (@LineCode IS NULL OR ps.LineCode = @LineCode)
ORDER BY ps.ShiftStart, ps.LineCode, ps.MachineCode;
GO

/* SSRS Dataset: Downtime by Shift */
DECLARE @ShiftName NVARCHAR(20) = NULL;

SELECT
    ds.LineCode,
    ds.MachineCode,
    ds.ShiftName,
    ds.DowntimeMinutes,
    ds.PlannedMinutes,
    ds.UnplannedMinutes
FROM dbo.vw_ShiftDowntimeSummary ds
WHERE (@ShiftName IS NULL OR ds.ShiftName = @ShiftName)
ORDER BY ds.LineCode, ds.MachineCode;
GO

/* SSRS Dataset: Alarm Heatmap */
SELECT
    a.LineCode,
    a.MachineCode,
    a.ShiftName,
    a.AlarmHour,
    a.AlarmCount,
    a.MaxSeverity
FROM dbo.vw_ShiftAlarmSummary a
ORDER BY a.ShiftName, a.AlarmHour, a.LineCode, a.MachineCode;
GO