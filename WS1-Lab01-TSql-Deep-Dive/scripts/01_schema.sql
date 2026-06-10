SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.AlarmEvents', 'U') IS NOT NULL DROP TABLE dbo.AlarmEvents;
IF OBJECT_ID('dbo.ProductionEvents', 'U') IS NOT NULL DROP TABLE dbo.ProductionEvents;
IF OBJECT_ID('dbo.DowntimeEvents', 'U') IS NOT NULL DROP TABLE dbo.DowntimeEvents;
IF OBJECT_ID('dbo.Shifts', 'U') IS NOT NULL DROP TABLE dbo.Shifts;
IF OBJECT_ID('dbo.Machines', 'U') IS NOT NULL DROP TABLE dbo.Machines;
IF OBJECT_ID('dbo.Lines', 'U') IS NOT NULL DROP TABLE dbo.Lines;
GO

CREATE TABLE dbo.Lines
(
    LineId INT IDENTITY(1,1) PRIMARY KEY,
    LineCode NVARCHAR(20) NOT NULL UNIQUE,
    PlantArea NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Machines
(
    MachineId INT IDENTITY(1,1) PRIMARY KEY,
    LineId INT NOT NULL REFERENCES dbo.Lines(LineId),
    MachineCode NVARCHAR(20) NOT NULL UNIQUE,
    NominalPartsPerHour INT NOT NULL,
    IsCritical BIT NOT NULL DEFAULT (0)
);
GO

CREATE TABLE dbo.Shifts
(
    ShiftId INT IDENTITY(1,1) PRIMARY KEY,
    ShiftName NVARCHAR(20) NOT NULL,
    ShiftStart DATETIME2 NOT NULL,
    ShiftEnd DATETIME2 NOT NULL
);
GO

CREATE TABLE dbo.ProductionEvents
(
    ProductionEventId BIGINT IDENTITY(1,1) PRIMARY KEY,
    MachineId INT NOT NULL REFERENCES dbo.Machines(MachineId),
    EventTime DATETIME2 NOT NULL,
    GoodCount INT NOT NULL,
    RejectCount INT NOT NULL,
    RecordedAt DATETIME2 NOT NULL DEFAULT (SYSUTCDATETIME())
);
GO

CREATE TABLE dbo.DowntimeEvents
(
    DowntimeEventId BIGINT IDENTITY(1,1) PRIMARY KEY,
    MachineId INT NOT NULL REFERENCES dbo.Machines(MachineId),
    StartTime DATETIME2 NOT NULL,
    EndTime DATETIME2 NOT NULL,
    ReasonCode NVARCHAR(40) NOT NULL,
    IsPlanned BIT NOT NULL DEFAULT (0)
);
GO

CREATE TABLE dbo.AlarmEvents
(
    AlarmEventId BIGINT IDENTITY(1,1) PRIMARY KEY,
    MachineId INT NOT NULL REFERENCES dbo.Machines(MachineId),
    AlarmTime DATETIME2 NOT NULL,
    Severity TINYINT NOT NULL,
    AlarmCode NVARCHAR(30) NOT NULL,
    MessageText NVARCHAR(200) NOT NULL
);
GO

CREATE INDEX IX_ProductionEvents_Machine_EventTime ON dbo.ProductionEvents(MachineId, EventTime);
CREATE INDEX IX_DowntimeEvents_Machine_Time ON dbo.DowntimeEvents(MachineId, StartTime, EndTime);
CREATE INDEX IX_AlarmEvents_Machine_Time ON dbo.AlarmEvents(MachineId, AlarmTime);
GO
