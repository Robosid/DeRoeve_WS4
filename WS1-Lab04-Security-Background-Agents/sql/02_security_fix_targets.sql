SET NOCOUNT ON;
GO

/*
Fix targets:
1) Eliminate dynamic ORDER BY concatenation risk.
2) Parameterize machine filter safely.
3) Restrict sortable columns to a known allow-list.
4) Remove hardcoded or discoverable credentials.
5) Add minimal audit logging for suspicious requests.
*/

PRINT 'Use Copilot to generate dbo.usp_DeviceLookup_Secure and deprecate dbo.usp_LegacyDeviceLookup.';
GO

/* Suggested negative test payloads */
DECLARE @Payloads TABLE (Payload NVARCHAR(200));
INSERT INTO @Payloads(Payload)
VALUES
(N'''''; DROP TABLE dbo.Machines;--'),
(N''' OR 1=1 --'),
(N'EventTime; EXEC xp_cmdshell ''whoami'' --');

SELECT * FROM @Payloads;
GO