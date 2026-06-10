SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.vw_ShiftProductionSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_ShiftProductionSummary;
IF OBJECT_ID('dbo.vw_ShiftDowntimeSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_ShiftDowntimeSummary;
IF OBJECT_ID('dbo.vw_ShiftAlarmSummary', 'V') IS NOT NULL DROP VIEW dbo.vw_ShiftAlarmSummary;
GO

CREATE VIEW dbo.vw_ShiftProductionSummary
AS
SELECT
    l.LineCode,
    m.MachineCode,
    s.ShiftName,
    s.ShiftStart,
    s.ShiftEnd,
    SUM(pe.GoodCount) AS TotalGood,
    SUM(pe.RejectCount) AS TotalReject,
    CAST(SUM(pe.RejectCount) * 100.0 / NULLIF(SUM(pe.GoodCount + pe.RejectCount), 0) AS DECIMAL(10,2)) AS RejectPct
FROM dbo.ProductionEvents pe
JOIN dbo.Machines m ON m.MachineId = pe.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId
JOIN dbo.Shifts s ON pe.EventTime >= s.ShiftStart AND pe.EventTime < s.ShiftEnd
GROUP BY l.LineCode, m.MachineCode, s.ShiftName, s.ShiftStart, s.ShiftEnd;
GO

CREATE VIEW dbo.vw_ShiftDowntimeSummary
AS
SELECT
    l.LineCode,
    m.MachineCode,
    s.ShiftName,
    SUM(DATEDIFF(MINUTE, d.StartTime, d.EndTime)) AS DowntimeMinutes,
    SUM(CASE WHEN d.IsPlanned = 1 THEN DATEDIFF(MINUTE, d.StartTime, d.EndTime) ELSE 0 END) AS PlannedMinutes,
    SUM(CASE WHEN d.IsPlanned = 0 THEN DATEDIFF(MINUTE, d.StartTime, d.EndTime) ELSE 0 END) AS UnplannedMinutes
FROM dbo.DowntimeEvents d
JOIN dbo.Machines m ON m.MachineId = d.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId
JOIN dbo.Shifts s ON d.StartTime < s.ShiftEnd AND d.EndTime > s.ShiftStart
GROUP BY l.LineCode, m.MachineCode, s.ShiftName;
GO

CREATE VIEW dbo.vw_ShiftAlarmSummary
AS
SELECT
    l.LineCode,
    m.MachineCode,
    s.ShiftName,
    DATEPART(HOUR, a.AlarmTime) AS AlarmHour,
    COUNT(*) AS AlarmCount,
    MAX(a.Severity) AS MaxSeverity
FROM dbo.AlarmEvents a
JOIN dbo.Machines m ON m.MachineId = a.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId
JOIN dbo.Shifts s ON a.AlarmTime >= s.ShiftStart AND a.AlarmTime < s.ShiftEnd
GROUP BY l.LineCode, m.MachineCode, s.ShiftName, DATEPART(HOUR, a.AlarmTime);
GO