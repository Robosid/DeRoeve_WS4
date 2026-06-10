SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.RawTelemetry', 'U') IS NOT NULL DROP TABLE dbo.RawTelemetry;
IF OBJECT_ID('dbo.TelemetryStaging', 'U') IS NOT NULL DROP TABLE dbo.TelemetryStaging;
IF OBJECT_ID('dbo.TelemetryFact', 'U') IS NOT NULL DROP TABLE dbo.TelemetryFact;
IF OBJECT_ID('dbo.TelemetryRejects', 'U') IS NOT NULL DROP TABLE dbo.TelemetryRejects;
GO

CREATE TABLE dbo.RawTelemetry
(
    RawTelemetryId BIGINT IDENTITY(1,1) PRIMARY KEY,
    SourceFileName NVARCHAR(260) NOT NULL,
    PayloadText NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT (SYSUTCDATETIME())
);
GO

CREATE TABLE dbo.TelemetryStaging
(
    StagingId BIGINT IDENTITY(1,1) PRIMARY KEY,
    MessageId NVARCHAR(80) NOT NULL,
    MachineCode NVARCHAR(20) NOT NULL,
    EventTime DATETIME2 NOT NULL,
    TemperatureDegC DECIMAL(10,3) NULL,
    PressureBar DECIMAL(10,3) NULL,
    QualityFlag TINYINT NOT NULL,
    SourceFileName NVARCHAR(260) NOT NULL,
    IngestedAt DATETIME2 NOT NULL DEFAULT (SYSUTCDATETIME())
);
GO

CREATE TABLE dbo.TelemetryFact
(
    TelemetryFactId BIGINT IDENTITY(1,1) PRIMARY KEY,
    MessageId NVARCHAR(80) NOT NULL UNIQUE,
    MachineCode NVARCHAR(20) NOT NULL,
    EventTime DATETIME2 NOT NULL,
    TemperatureDegC DECIMAL(10,3) NULL,
    PressureBar DECIMAL(10,3) NULL,
    QualityFlag TINYINT NOT NULL,
    LastUpdatedAt DATETIME2 NOT NULL DEFAULT (SYSUTCDATETIME())
);
GO

CREATE TABLE dbo.TelemetryRejects
(
    RejectId BIGINT IDENTITY(1,1) PRIMARY KEY,
    SourceFileName NVARCHAR(260) NOT NULL,
    MessageId NVARCHAR(80) NULL,
    RejectReason NVARCHAR(200) NOT NULL,
    PayloadSnapshot NVARCHAR(2000) NULL,
    RejectedAt DATETIME2 NOT NULL DEFAULT (SYSUTCDATETIME())
);
GO
