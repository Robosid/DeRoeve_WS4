SET NOCOUNT ON;
GO

/* Reference tSQLt tests for dbo.usp_GetOeeByShift */
-- Requires tSQLt installed in target database.

IF SCHEMA_ID('tSQLt') IS NULL OR OBJECT_ID('tSQLt.NewTestClass', 'P') IS NULL
BEGIN
    PRINT 'tSQLt is not installed in this database. Skipping test script execution.';
END
ELSE
BEGIN
    IF OBJECT_ID('testWorkshopScada.[test usp_GetOeeByShift returns rows for valid shift]', 'P') IS NOT NULL
        DROP PROCEDURE testWorkshopScada.[test usp_GetOeeByShift returns rows for valid shift];

    IF OBJECT_ID('testWorkshopScada.[test usp_GetOeeByShift handles empty range]', 'P') IS NOT NULL
        DROP PROCEDURE testWorkshopScada.[test usp_GetOeeByShift handles empty range];

    IF SCHEMA_ID('testWorkshopScada') IS NULL
        EXEC tSQLt.NewTestClass 'testWorkshopScada';

    DECLARE @CreateTestValid NVARCHAR(MAX) = N'
CREATE PROCEDURE testWorkshopScada.[test usp_GetOeeByShift returns rows for valid shift]
AS
BEGIN
    DECLARE @ShiftStart DATETIME2 = DATEADD(HOUR, -8, SYSUTCDATETIME());
    DECLARE @ShiftEnd DATETIME2 = SYSUTCDATETIME();

    CREATE TABLE #actual
    (
        LineCode NVARCHAR(20),
        MachineCode NVARCHAR(20),
        AvailabilityPct DECIMAL(10,4),
        PerformancePct DECIMAL(10,4),
        QualityPct DECIMAL(10,4),
        OEEPct DECIMAL(10,4)
    );

    INSERT INTO #actual
    EXEC dbo.usp_GetOeeByShift @ShiftStart = @ShiftStart, @ShiftEnd = @ShiftEnd, @LineCode = NULL;

    EXEC tSQLt.AssertTrue @Condition = CASE WHEN EXISTS (SELECT 1 FROM #actual) THEN 1 ELSE 0 END,
                          @Message = ''Expected at least one OEE row for valid shift window.'';
END;
';

    EXEC(@CreateTestValid);

    DECLARE @CreateTestEmpty NVARCHAR(MAX) = N'
CREATE PROCEDURE testWorkshopScada.[test usp_GetOeeByShift handles empty range]
AS
BEGIN
    DECLARE @ShiftStart DATETIME2 = DATEADD(DAY, -3650, SYSUTCDATETIME());
    DECLARE @ShiftEnd DATETIME2 = DATEADD(DAY, -3649, SYSUTCDATETIME());

    CREATE TABLE #actual
    (
        LineCode NVARCHAR(20),
        MachineCode NVARCHAR(20),
        AvailabilityPct DECIMAL(10,4),
        PerformancePct DECIMAL(10,4),
        QualityPct DECIMAL(10,4),
        OEEPct DECIMAL(10,4)
    );

    INSERT INTO #actual
    EXEC dbo.usp_GetOeeByShift @ShiftStart = @ShiftStart, @ShiftEnd = @ShiftEnd, @LineCode = NULL;

    EXEC tSQLt.AssertEquals 0, (SELECT COUNT(*) FROM #actual),
                           ''Expected zero rows for historical empty shift range.'';
END;
';

    EXEC(@CreateTestEmpty);

    PRINT 'tSQLt reference tests created in schema testWorkshopScada.';
END;
GO