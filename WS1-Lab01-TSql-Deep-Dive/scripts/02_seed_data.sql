SET NOCOUNT ON;
GO

INSERT INTO dbo.Lines(LineCode, PlantArea)
VALUES ('LINE-A', 'Packaging'), ('LINE-B', 'Assembly');
GO

INSERT INTO dbo.Machines(LineId, MachineCode, NominalPartsPerHour, IsCritical)
SELECT l.LineId, v.MachineCode, v.NominalPartsPerHour, v.IsCritical
FROM dbo.Lines l
JOIN (VALUES
    ('LINE-A', 'A-PRESS-01', 600, 1),
    ('LINE-A', 'A-FILL-01', 800, 0),
    ('LINE-B', 'B-WELD-01', 450, 1),
    ('LINE-B', 'B-PACK-01', 700, 0)
) v(LineCode, MachineCode, NominalPartsPerHour, IsCritical) ON v.LineCode = l.LineCode;
GO

DECLARE @d DATE = CAST(SYSUTCDATETIME() AS DATE);
INSERT INTO dbo.Shifts(ShiftName, ShiftStart, ShiftEnd)
VALUES
('Shift-1', DATEADD(HOUR, 6, CAST(@d AS DATETIME2)), DATEADD(HOUR, 14, CAST(@d AS DATETIME2))),
('Shift-2', DATEADD(HOUR, 14, CAST(@d AS DATETIME2)), DATEADD(HOUR, 22, CAST(@d AS DATETIME2))),
('Shift-3', DATEADD(HOUR, 22, DATEADD(DAY, -1, CAST(@d AS DATETIME2))), DATEADD(HOUR, 6, CAST(@d AS DATETIME2)));
GO

;WITH n AS
(
    SELECT TOP (240) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.all_objects
)
INSERT INTO dbo.ProductionEvents(MachineId, EventTime, GoodCount, RejectCount)
SELECT
    m.MachineId,
    DATEADD(MINUTE, rn * 3, DATEADD(HOUR, 6, CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2))),
    8 + (rn % 5),
    CASE WHEN rn % 17 = 0 THEN 1 ELSE 0 END
FROM dbo.Machines m
CROSS JOIN n;
GO

INSERT INTO dbo.DowntimeEvents(MachineId, StartTime, EndTime, ReasonCode, IsPlanned)
SELECT m.MachineId,
       DATEADD(MINUTE, 30, DATEADD(HOUR, 8, CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2))),
       DATEADD(MINUTE, 55, DATEADD(HOUR, 8, CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2))),
       'JAM',
       0
FROM dbo.Machines m
WHERE m.IsCritical = 1;
GO

INSERT INTO dbo.AlarmEvents(MachineId, AlarmTime, Severity, AlarmCode, MessageText)
SELECT m.MachineId,
       DATEADD(MINUTE, 10 + m.MachineId, DATEADD(HOUR, 9, CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2))),
       CASE WHEN m.IsCritical = 1 THEN 4 ELSE 2 END,
       CONCAT('ALM-', m.MachineId),
       'Simulated alarm event for workshop'
FROM dbo.Machines m;
GO