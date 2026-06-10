SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.vw_FactProduction', 'V') IS NOT NULL DROP VIEW dbo.vw_FactProduction;
IF OBJECT_ID('dbo.vw_FactDowntime', 'V') IS NOT NULL DROP VIEW dbo.vw_FactDowntime;
IF OBJECT_ID('dbo.vw_FactAlarms', 'V') IS NOT NULL DROP VIEW dbo.vw_FactAlarms;
GO

CREATE VIEW dbo.vw_FactProduction
AS
SELECT
    CAST(pe.EventTime AS DATE) AS EventDate,
    m.MachineCode,
    l.LineCode,
    pe.GoodCount,
    pe.RejectCount,
    CAST(3 AS INT) AS WindowMinutes,
    CAST(m.NominalPartsPerHour / 60.0 AS DECIMAL(10,4)) AS IdealPartsPerMinute
FROM dbo.ProductionEvents pe
JOIN dbo.Machines m ON m.MachineId = pe.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId;
GO

CREATE VIEW dbo.vw_FactDowntime
AS
SELECT
    CAST(d.StartTime AS DATE) AS EventDate,
    m.MachineCode,
    l.LineCode,
    DATEDIFF(MINUTE, d.StartTime, d.EndTime) AS DowntimeMinutes,
    d.IsPlanned,
    d.ReasonCode
FROM dbo.DowntimeEvents d
JOIN dbo.Machines m ON m.MachineId = d.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId;
GO

CREATE VIEW dbo.vw_FactAlarms
AS
SELECT
    CAST(a.AlarmTime AS DATE) AS EventDate,
    m.MachineCode,
    l.LineCode,
    a.Severity,
    a.AlarmCode
FROM dbo.AlarmEvents a
JOIN dbo.Machines m ON m.MachineId = a.MachineId
JOIN dbo.Lines l ON l.LineId = m.LineId;
GO