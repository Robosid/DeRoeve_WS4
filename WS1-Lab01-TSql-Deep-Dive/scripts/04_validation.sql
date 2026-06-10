SET NOCOUNT ON;
GO

/* Validation 1: data sanity */
SELECT
    (SELECT COUNT(*) FROM dbo.Machines) AS MachineCount,
    (SELECT COUNT(*) FROM dbo.ProductionEvents) AS ProductionEventCount,
    (SELECT COUNT(*) FROM dbo.AlarmEvents) AS AlarmCount;
GO

/* Validation 2: OEE proc exists */
SELECT OBJECT_ID('dbo.usp_GetOeeByShift') AS OeeProcObjectId;
GO

/* Validation 2b: OEE proc smoke test */
IF OBJECT_ID('dbo.usp_GetOeeByShift', 'P') IS NOT NULL
BEGIN
  DECLARE @ShiftStart DATETIME2 = DATEADD(HOUR, -8, SYSUTCDATETIME());
  DECLARE @ShiftEnd DATETIME2 = SYSUTCDATETIME();

  EXEC dbo.usp_GetOeeByShift
    @ShiftStart = @ShiftStart,
    @ShiftEnd = @ShiftEnd,
    @LineCode = NULL;
END
ELSE
BEGIN
  PRINT 'OEE proc missing. Run AI-generated output for Challenge B or scripts/06_oee_proc_reference.sql.';
END;
GO

/* Validation 3: challenge C predicate rewrite check template */
-- Capture IO stats before and after rewrite manually in SSMS output.
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT COUNT(*) AS TodayRowsBaseline
FROM dbo.ProductionEvents pe
WHERE CONVERT(DATE, pe.EventTime) = CONVERT(DATE, SYSUTCDATETIME());

SELECT COUNT(*) AS TodayRowsSargable
FROM dbo.ProductionEvents pe
WHERE pe.EventTime >= CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2)
  AND pe.EventTime < DATEADD(DAY, 1, CAST(CAST(SYSUTCDATETIME() AS DATE) AS DATETIME2));

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

/* Validation 4: reporting parity sample */
SELECT TOP 20
    m.MachineCode,
    pe.EventTime,
    pe.GoodCount,
    pe.RejectCount
FROM dbo.ProductionEvents pe
JOIN dbo.Machines m ON m.MachineId = pe.MachineId
ORDER BY pe.EventTime DESC;
GO