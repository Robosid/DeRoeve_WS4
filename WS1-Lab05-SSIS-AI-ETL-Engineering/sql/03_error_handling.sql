SET NOCOUNT ON;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ProcessTelemetryBatch
    @SourceFileName NVARCHAR(260)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Reject malformed rows.
        INSERT INTO dbo.TelemetryRejects(SourceFileName, MessageId, RejectReason, PayloadSnapshot)
        SELECT
            @SourceFileName,
            s.MessageId,
            CASE
                WHEN s.MessageId IS NULL OR LTRIM(RTRIM(s.MessageId)) = '' THEN 'Missing message id'
                WHEN s.EventTime IS NULL THEN 'Missing event time'
                WHEN s.MachineCode IS NULL OR LTRIM(RTRIM(s.MachineCode)) = '' THEN 'Missing machine code'
                ELSE 'Unknown quality issue'
            END,
            CONCAT('Machine=', s.MachineCode, '; Time=', CONVERT(NVARCHAR(30), s.EventTime, 126))
        FROM dbo.TelemetryStaging s
        WHERE s.SourceFileName = @SourceFileName
          AND (
                s.MessageId IS NULL OR LTRIM(RTRIM(s.MessageId)) = ''
                OR s.EventTime IS NULL
                OR s.MachineCode IS NULL OR LTRIM(RTRIM(s.MachineCode)) = ''
              );

        -- Merge valid rows.
        ;WITH ValidRows AS
        (
            SELECT *
            FROM dbo.TelemetryStaging s
            WHERE s.SourceFileName = @SourceFileName
              AND s.MessageId IS NOT NULL AND LTRIM(RTRIM(s.MessageId)) <> ''
              AND s.EventTime IS NOT NULL
              AND s.MachineCode IS NOT NULL AND LTRIM(RTRIM(s.MachineCode)) <> ''
        )
        MERGE dbo.TelemetryFact AS t
        USING ValidRows AS s
        ON t.MessageId = s.MessageId
        WHEN MATCHED THEN
            UPDATE SET
                t.MachineCode = s.MachineCode,
                t.EventTime = s.EventTime,
                t.TemperatureDegC = s.TemperatureDegC,
                t.PressureBar = s.PressureBar,
                t.QualityFlag = s.QualityFlag,
                t.LastUpdatedAt = SYSUTCDATETIME()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (MessageId, MachineCode, EventTime, TemperatureDegC, PressureBar, QualityFlag, LastUpdatedAt)
            VALUES (s.MessageId, s.MachineCode, s.EventTime, s.TemperatureDegC, s.PressureBar, s.QualityFlag, SYSUTCDATETIME());
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.TelemetryRejects(SourceFileName, RejectReason, PayloadSnapshot)
        VALUES (@SourceFileName, ERROR_MESSAGE(), 'Batch level failure');

        THROW;
    END CATCH
END;
GO