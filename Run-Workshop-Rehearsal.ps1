[CmdletBinding()]
param(
    [string]$SqlServer = "localhost",
    [string]$DatabaseName = ("WorkshopRehearsal_{0}" -f (Get-Date -Format "yyyyMMdd")),
    [switch]$SkipMcp,
    [switch]$SkipLegacyBuild,
    [switch]$KeepBuildArtifacts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$stepResults = New-Object System.Collections.Generic.List[object]

function Add-StepResult {
    param(
        [string]$Step,
        [bool]$Passed,
        [string]$Details
    )

    $stepResults.Add([pscustomobject]@{
        Step = $Step
        Status = if ($Passed) { "PASS" } else { "FAIL" }
        Details = $Details
    }) | Out-Null
}

function Invoke-CheckedCommand {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [string]$WorkingDirectory = $repoRoot,
        [switch]$Quiet
    )

    Push-Location $WorkingDirectory
    try {
        if (-not $Quiet) {
            Write-Host (">> {0} {1}" -f $FilePath, ($Arguments -join " ")) -ForegroundColor DarkGray
        }

        if ($Quiet) {
            & $FilePath @Arguments *> $null
        } else {
            & $FilePath @Arguments
        }

        if ($LASTEXITCODE -ne 0) {
            throw ("Command failed ({0}): {1} {2}" -f $LASTEXITCODE, $FilePath, ($Arguments -join " "))
        }
    }
    finally {
        Pop-Location
    }
}

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$Script
    )

    Write-Host ("`n=== {0} ===" -f $Name) -ForegroundColor Cyan

    try {
        & $Script
        Add-StepResult -Step $Name -Passed $true -Details "Completed"
    }
    catch {
        Add-StepResult -Step $Name -Passed $false -Details $_.Exception.Message
        throw
    }
}

function Write-Summary {
    Write-Host "`n=== Rehearsal Summary ===" -ForegroundColor Cyan
    $stepResults | Format-Table -AutoSize | Out-String | Write-Host

    $failed = @($stepResults | Where-Object { $_.Status -eq "FAIL" })
    if ($failed.Count -gt 0) {
        Write-Host "REHEARSAL_RESULT: FAIL" -ForegroundColor Red
        exit 1
    }

    Write-Host "REHEARSAL_RESULT: PASS" -ForegroundColor Green
    exit 0
}

try {
    Invoke-Step -Name "Tooling check" -Script {
        foreach ($tool in @("sqlcmd", "node", "npm", "dotnet")) {
            $cmd = Get-Command $tool -ErrorAction SilentlyContinue
            if ($null -eq $cmd) {
                throw ("Required command not found: {0}" -f $tool)
            }

            Write-Host ("Found {0}: {1}" -f $tool, $cmd.Source)
        }
    }

    Invoke-Step -Name "Create clean rehearsal database" -Script {
        $createDbQuery = @"
IF DB_ID(N'$DatabaseName') IS NOT NULL
BEGIN
    ALTER DATABASE [$DatabaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$DatabaseName];
END;
CREATE DATABASE [$DatabaseName];
"@

        Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", "master", "-Q", $createDbQuery)
    }

    Invoke-Step -Name "Run SQL scripts" -Script {
        $sqlScripts = @(
            "WS1-Lab01-TSql-Deep-Dive/scripts/01_schema.sql",
            "WS1-Lab01-TSql-Deep-Dive/scripts/02_seed_data.sql",
            "WS1-Lab01-TSql-Deep-Dive/scripts/03_challenges.sql",
            "WS1-Lab01-TSql-Deep-Dive/scripts/06_oee_proc_reference.sql",
            "WS1-Lab01-TSql-Deep-Dive/scripts/04_validation.sql",
            "WS1-Lab01-TSql-Deep-Dive/scripts/05_tsqlt_reference_tests.sql",
            "WS1-Lab02-Advanced-Reporting-SQL/scripts/01_reporting_views.sql",
            "WS1-Lab02-Advanced-Reporting-SQL/scripts/02_ssrs_datasets.sql",
            "WS1-Lab02-Advanced-Reporting-SQL/scripts/03_crystal_datasets.sql",
            "WS1-Lab04-Security-Background-Agents/sql/01_insecure_starter.sql",
            "WS1-Lab04-Security-Background-Agents/sql/03_fixed_reference.sql",
            "WS1-Lab05-SSIS-AI-ETL-Engineering/sql/01_staging_tables.sql",
            "WS1-Lab05-SSIS-AI-ETL-Engineering/sql/02_merge_upsert.sql",
            "WS1-Lab05-SSIS-AI-ETL-Engineering/sql/03_error_handling.sql",
            "WS1-Lab06-SSAS-AI-Semantic-Modeling/sql/01_semantic_source_views.sql",
            "WS1-Lab06-SSAS-AI-Semantic-Modeling/sql/02_validation_baselines.sql"
        )

        foreach ($relativePath in $sqlScripts) {
            $fullPath = Join-Path $repoRoot $relativePath
            if (-not (Test-Path $fullPath)) {
                throw ("Missing script: {0}" -f $relativePath)
            }

            Write-Host ("Running script: {0}" -f $relativePath)
            Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", $DatabaseName, "-i", $fullPath) -Quiet
        }
    }

    Invoke-Step -Name "Run SQL smoke tests" -Script {
        $oeeSmoke = @"
DECLARE @ShiftStart DATETIME2 = DATEADD(HOUR, -8, SYSUTCDATETIME());
DECLARE @ShiftEnd DATETIME2 = SYSUTCDATETIME();
EXEC dbo.usp_GetOeeByShift @ShiftStart = @ShiftStart, @ShiftEnd = @ShiftEnd, @LineCode = NULL;
"@

        $securitySmoke = @"
EXEC dbo.usp_DeviceLookup_Secure @MachineCode = N'A-PRESS-01', @SortColumn = N'EventTime';
EXEC dbo.usp_DeviceLookup_Secure @MachineCode = N'A-PRESS-01', @SortColumn = N'EventTime; DROP TABLE dbo.Machines --';
"@

        $telemetrySmoke = @"
INSERT INTO dbo.TelemetryStaging(MessageId, MachineCode, EventTime, TemperatureDegC, PressureBar, QualityFlag, SourceFileName)
VALUES
    (N'MSG-1', N'A-PRESS-01', SYSUTCDATETIME(), 85.2, 2.1, 1, N'rehearsal.csv'),
    (N'', N'A-PRESS-01', SYSUTCDATETIME(), 81.0, 2.0, 1, N'rehearsal.csv');

EXEC dbo.usp_ProcessTelemetryBatch @SourceFileName = N'rehearsal.csv';

SELECT
    (SELECT COUNT(*) FROM dbo.TelemetryFact WHERE MessageId = N'MSG-1') AS TelemetryFactInserted,
    (SELECT COUNT(*) FROM dbo.TelemetryRejects WHERE SourceFileName = N'rehearsal.csv') AS RejectRows;
"@

        $summaryQuery = @"
SELECT
    DB_NAME() AS DbName,
    (SELECT COUNT(*) FROM dbo.Machines) AS Machines,
    (SELECT COUNT(*) FROM dbo.ProductionEvents) AS ProductionEvents,
    (SELECT COUNT(*) FROM dbo.AlarmEvents) AS AlarmEvents,
    (SELECT COUNT(*) FROM dbo.TelemetryFact) AS TelemetryFact;
"@

        Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", $DatabaseName, "-Q", $oeeSmoke)
        Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", $DatabaseName, "-Q", $securitySmoke)
        Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", $DatabaseName, "-Q", $telemetrySmoke)
        Invoke-CheckedCommand -FilePath "sqlcmd" -Arguments @("-S", $SqlServer, "-E", "-b", "-d", $DatabaseName, "-Q", $summaryQuery)
    }

    if (-not $SkipMcp) {
        Invoke-Step -Name "Build MCP SQL server" -Script {
            $mcpPath = Join-Path $repoRoot "WS1-Lab03-MCP-SQL-Agents-Skills/mcp-sqlserver-server"
            Invoke-CheckedCommand -FilePath "npm" -Arguments @("install") -WorkingDirectory $mcpPath
            Invoke-CheckedCommand -FilePath "npm" -Arguments @("run", "build") -WorkingDirectory $mcpPath
        }

        Invoke-Step -Name "Smoke start MCP SQL server" -Script {
            $mcpPath = Join-Path $repoRoot "WS1-Lab03-MCP-SQL-Agents-Skills/mcp-sqlserver-server"
            $stdoutLog = Join-Path $env:TEMP "mcp-rehearsal-stdout.log"
            $stderrLog = Join-Path $env:TEMP "mcp-rehearsal-stderr.log"

            if (Test-Path $stdoutLog) { Remove-Item -Force $stdoutLog }
            if (Test-Path $stderrLog) { Remove-Item -Force $stderrLog }

            $previousConnectionString = $env:SQL_CONNECTION_STRING
            $env:SQL_CONNECTION_STRING = "Server=$SqlServer;Database=$DatabaseName;Integrated Security=true;TrustServerCertificate=true"

            try {
                $proc = Start-Process -FilePath "node" -ArgumentList "dist/index.js" -WorkingDirectory $mcpPath -PassThru -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog

                $null = Wait-Process -Id $proc.Id -Timeout 2 -ErrorAction SilentlyContinue
                $proc.Refresh()

                if ($proc.HasExited) {
                    $stderr = ""
                    if (Test-Path $stderrLog) {
                        $stderr = Get-Content -Path $stderrLog -Raw
                    }

                    if ([string]::IsNullOrWhiteSpace($stderr)) {
                        $stderr = "No stderr output captured."
                    }

                    throw ("MCP server exited early (code {0}). {1}" -f $proc.ExitCode, $stderr.Trim())
                }

                Stop-Process -Id $proc.Id -Force
            }
            finally {
                if ($null -ne $previousConnectionString) {
                    $env:SQL_CONNECTION_STRING = $previousConnectionString
                }
                else {
                    Remove-Item Env:SQL_CONNECTION_STRING -ErrorAction SilentlyContinue
                }
            }
        }
    }

    if (-not $SkipLegacyBuild) {
        Invoke-Step -Name "Build LegacyScadaBridge" -Script {
            $legacyPath = Join-Path $repoRoot "WS1-Lab04-Security-Background-Agents/LegacyScadaBridge"
            Invoke-CheckedCommand -FilePath "dotnet" -Arguments @("restore", "-p:RestoreSources=https://api.nuget.org/v3/index.json") -WorkingDirectory $legacyPath
            Invoke-CheckedCommand -FilePath "dotnet" -Arguments @("build", "-c", "Debug", "-p:RestoreSources=https://api.nuget.org/v3/index.json") -WorkingDirectory $legacyPath
        }
    }
}
catch {
    Write-Host ("`nRehearsal failed: {0}" -f $_.Exception.Message) -ForegroundColor Red
}
finally {
    if (-not $KeepBuildArtifacts) {
        Write-Host "`nCleaning transient build artifacts..." -ForegroundColor DarkGray

        $cleanupPaths = @(
            "WS1-Lab03-MCP-SQL-Agents-Skills/mcp-sqlserver-server/node_modules",
            "WS1-Lab03-MCP-SQL-Agents-Skills/mcp-sqlserver-server/dist",
            "WS1-Lab04-Security-Background-Agents/LegacyScadaBridge/bin",
            "WS1-Lab04-Security-Background-Agents/LegacyScadaBridge/obj"
        )

        foreach ($relativePath in $cleanupPaths) {
            $fullPath = Join-Path $repoRoot $relativePath
            if (Test-Path $fullPath) {
                Remove-Item -Path $fullPath -Recurse -Force
            }
        }
    }

    Write-Summary
}
