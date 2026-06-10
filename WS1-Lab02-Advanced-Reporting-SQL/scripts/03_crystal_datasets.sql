SET NOCOUNT ON;
GO

/* Crystal dataset: flattened daily report */
DECLARE @TargetDate DATE = CAST(SYSUTCDATETIME() AS DATE);

SELECT
    ps.ShiftName,
    ps.LineCode,
    ps.MachineCode,
    ps.TotalGood,
    ps.TotalReject,
    ps.RejectPct,
    ISNULL(ds.DowntimeMinutes, 0) AS DowntimeMinutes,
    ISNULL(ds.UnplannedMinutes, 0) AS UnplannedMinutes
FROM dbo.vw_ShiftProductionSummary ps
LEFT JOIN dbo.vw_ShiftDowntimeSummary ds
    ON ds.LineCode = ps.LineCode
   AND ds.MachineCode = ps.MachineCode
   AND ds.ShiftName = ps.ShiftName
WHERE CAST(ps.ShiftStart AS DATE) = @TargetDate
ORDER BY ps.ShiftName, ps.LineCode, ps.MachineCode;
GO

/* Crystal dataset: top alarms */
SELECT TOP (20)
    a.LineCode,
    a.MachineCode,
    a.ShiftName,
    a.AlarmHour,
    a.AlarmCount,
    a.MaxSeverity
FROM dbo.vw_ShiftAlarmSummary a
ORDER BY a.AlarmCount DESC, a.MaxSeverity DESC, a.LineCode, a.MachineCode;
GO

/* Legacy reporting proc cleanup target */
IF OBJECT_ID('dbo.usp_LegacyDailyReport', 'P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_LegacyDailyReport AS BEGIN SELECT 1; END');
GO

ALTER PROCEDURE dbo.usp_LegacyDailyReport
    @ReportDate NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    -- Intentionally weak legacy pattern for AI cleanup exercise.
    DECLARE @sql NVARCHAR(MAX) = N'
    SELECT *
    FROM dbo.vw_ShiftProductionSummary
    WHERE CONVERT(NVARCHAR(30), ShiftStart, 23) = ''''' + @ReportDate + N'''''';

    EXEC (@sql);
END;
GO