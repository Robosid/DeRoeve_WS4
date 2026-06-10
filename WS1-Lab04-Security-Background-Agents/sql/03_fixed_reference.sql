SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.usp_DeviceLookup_Secure', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_DeviceLookup_Secure;
GO

CREATE PROCEDURE dbo.usp_DeviceLookup_Secure
    @MachineCode NVARCHAR(50),
    @SortColumn NVARCHAR(20) = N'EventTime'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Sql NVARCHAR(MAX);
    DECLARE @SafeSortColumn NVARCHAR(20);

    SET @SafeSortColumn = CASE @SortColumn
        WHEN N'EventTime' THEN N'EventTime'
        WHEN N'GoodCount' THEN N'GoodCount'
        WHEN N'RejectCount' THEN N'RejectCount'
        ELSE N'EventTime'
    END;

    SET @Sql = N'
        SELECT TOP (200)
            pe.ProductionEventId,
            pe.EventTime,
            pe.GoodCount,
            pe.RejectCount,
            m.MachineCode
        FROM dbo.ProductionEvents pe
        JOIN dbo.Machines m ON m.MachineId = pe.MachineId
        WHERE m.MachineCode = @P_MachineCode
        ORDER BY ' + QUOTENAME(@SafeSortColumn) + N' DESC;';

    EXEC sp_executesql
        @Sql,
        N'@P_MachineCode NVARCHAR(50)',
        @P_MachineCode = @MachineCode;
END;
GO