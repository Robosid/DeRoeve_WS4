# tSQLt Install Guide for Workshop 4 Participants

SQL Server: localhost

## Choose your database first
Use the database where you ran Lab 1 setup scripts 01 and 02.

Recommended participant database naming:
- Workshop4_<YourName>_LabDB

Example:
- Workshop4_Sid_LabDB

Important:
- Do not assume WorkshopRehearsal_20260610. That was an instructor rehearsal database name from one machine/date.

## Prerequisites
- SSMS access to localhost
- Account with sysadmin rights on SQL Server
- tSQLt installer file downloaded and extracted (tSQLt.class.sql)

## Step 1: Enable required SQL settings
Open a new query in SSMS against master and run (replace YOUR_WORKSHOP_DB):

~~~sql
USE master;
GO
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;
GO

ALTER AUTHORIZATION ON DATABASE::[YOUR_WORKSHOP_DB] TO sa;
ALTER DATABASE [YOUR_WORKSHOP_DB] SET TRUSTWORTHY ON;
GO
~~~

## Step 2: Install tSQLt into your workshop database
1. In SSMS, change database context to YOUR_WORKSHOP_DB.
2. Open tSQLt.class.sql.
3. Execute the full file.

## Step 3: Verify install
Run:

~~~sql
USE [YOUR_WORKSHOP_DB];
GO
SELECT
  CASE
    WHEN SCHEMA_ID('tSQLt') IS NOT NULL THEN 'INSTALLED'
    ELSE 'NOT INSTALLED'
  END AS tSQLtStatus;
GO
~~~

## Step 4: Run Lab 1 reference tests
Run:
- scripts/05_tsqlt_reference_tests.sql

Then execute:

~~~sql
EXEC tSQLt.Run 'testWorkshopScada';
~~~

## If install is blocked
If permissions or policy prevent install, skip tSQLt for now and continue Lab 1.
You can still complete the lab using scripts 01 to 04 and validation output.
