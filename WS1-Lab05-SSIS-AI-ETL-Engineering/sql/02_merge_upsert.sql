SET NOCOUNT ON;
GO

/* Dedup before merge: keep newest ingest per message */
;WITH Dedup AS
(
    SELECT
        s.*,
        ROW_NUMBER() OVER (PARTITION BY s.MessageId ORDER BY s.IngestedAt DESC, s.StagingId DESC) AS rn
    FROM dbo.TelemetryStaging s
)
MERGE dbo.TelemetryFact AS t
USING (
    SELECT *
    FROM Dedup
    WHERE rn = 1
) AS s
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
GO