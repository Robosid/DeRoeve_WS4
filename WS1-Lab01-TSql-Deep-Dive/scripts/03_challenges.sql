SET NOCOUNT ON;
GO

/*
Challenge A: Rewrite this query using CTE + window functions for clarity and performance.
Goal: shift-level good/reject totals + reject percentage by machine.
*/
SELECT
    m.MachineCode,
    s.ShiftName,
    SUM(pe.GoodCount) AS TotalGood,
    SUM(pe.RejectCount) AS TotalReject,
    CAST(SUM(pe.RejectCount) * 100.0 / NULLIF(SUM(pe.GoodCount + pe.RejectCount), 0) AS DECIMAL(10,2)) AS RejectPct
FROM dbo.ProductionEvents pe
JOIN dbo.Machines m ON m.MachineId = pe.MachineId
JOIN dbo.Shifts s ON pe.EventTime >= s.ShiftStart AND pe.EventTime < s.ShiftEnd
GROUP BY m.MachineCode, s.ShiftName
ORDER BY m.MachineCode, s.ShiftName;
GO

/*
Challenge B: Generate a stored procedure for OEE by shift.
Expected input:
- @ShiftStart DATETIME2
- @ShiftEnd DATETIME2
- @LineCode NVARCHAR(20) = NULL
Expected output columns:
- LineCode, MachineCode, AvailabilityPct, PerformancePct, QualityPct, OEEPct
*/
PRINT 'Use Copilot to generate dbo.usp_GetOeeByShift';
GO

/*
Challenge C: Explain and tune this intentionally weak pattern.
Issues:
- Date conversion in predicate can break index usage
- Broad SELECT list and no line filter
*/
SELECT *
FROM dbo.ProductionEvents pe
WHERE CONVERT(DATE, pe.EventTime) = CONVERT(DATE, SYSUTCDATETIME());
GO

/*
Challenge D: tSQLt test generation target proc
After creating dbo.usp_GetOeeByShift, generate tSQLt tests for:
- Valid shift range
- Empty range
- Null @LineCode behavior
*/
PRINT 'Use /tests to generate tSQLt tests for dbo.usp_GetOeeByShift';
GO