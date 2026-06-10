SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.DeviceUsers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeviceUsers
    (
        DeviceUserId INT IDENTITY(1,1) PRIMARY KEY,
        UserName NVARCHAR(100) NOT NULL,
        DisplayName NVARCHAR(120) NOT NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        IsActive BIT NOT NULL DEFAULT (1)
    );
END;
GO

IF OBJECT_ID('dbo.usp_LegacyDeviceLookup', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.usp_LegacyDeviceLookup AS BEGIN SELECT 1; END');
GO

ALTER PROCEDURE dbo.usp_LegacyDeviceLookup
    @MachineCode NVARCHAR(50),
    @OrderBy NVARCHAR(50) = N'EventTime'
AS
BEGIN
    SET NOCOUNT ON;

    -- Intentional anti-pattern for workshop hardening.
    DECLARE @Sql NVARCHAR(MAX) = N'
      SELECT TOP 200 *
      FROM dbo.ProductionEvents pe
      JOIN dbo.Machines m ON m.MachineId = pe.MachineId
      WHERE m.MachineCode = ''''' + @MachineCode + N'''''
      ORDER BY ' + @OrderBy + N' DESC';

    EXEC(@Sql);
END;
GO

-- Intentional insecure secret for AI detection exercise.
IF EXISTS
(
    SELECT 1
    FROM sys.extended_properties ep
    JOIN sys.tables t ON t.object_id = ep.major_id
    JOIN sys.schemas s ON s.schema_id = t.schema_id
    WHERE ep.name = N'LegacyBridgePassword'
      AND s.name = N'dbo'
      AND t.name = N'DeviceUsers'
)
BEGIN
    EXEC sys.sp_dropextendedproperty
        @name = N'LegacyBridgePassword',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'DeviceUsers';
END;

EXEC sys.sp_addextendedproperty
    @name = N'LegacyBridgePassword',
    @value = N'P@ssw0rd!123',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'DeviceUsers';
GO