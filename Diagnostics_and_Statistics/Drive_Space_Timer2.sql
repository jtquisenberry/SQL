
USE [tempdb]

-- BEGIN User Variables
DECLARE @LogTable nvarchar(max) = N'Drive_Space' --<--
-- END User Variables

SELECT @LogTable = REPLACE(REPLACE(REPLACE(@LogTable + N'_' + CONVERT(VARCHAR(20),DATEADD(HOUR, -8, GETUTCDATE()),120),' ', '_'),'-',''), ':','')

DECLARE @SqlCreateTable nvarchar(max)
SELECT @SqlCreateTable = 
N'
CREATE TABLE [tempdb].dbo.'+@LogTable+'
(
	  Drive nvarchar(max)
	, AvailableMBs decimal(10,2)
	, AvailableGBs decimal(10,2)
	, TotalMBs decimal(10,2)
	, TotalGBs decimal(10,2)
	, UsedMBs decimal(10,2)
	, UsedGBs decimal(10,2)
	, Contents nvarchar(25)
	, SampleTime datetime NULL
)
'
--PRINT @SqlCreateTable
EXECUTE sp_executesql @SqlCreateTable


DECLARE @TempDrive nvarchar(260) = N''
DECLARE @DBDataDrive nvarchar(260) = N''
DECLARE @DBLogsDrive nvarchar(260) = N''

SELECT @TempDrive = SUBSTRING(physical_name, 1, 1)	  
FROM tempdb.sys.database_files;

SELECT @DBDataDrive = SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultDataPath')),1,1)
SELECT @DBLogsDrive = SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultLogPath')),1,1)

DECLARE @SqlDoMonitoring nvarchar(max)
SELECT @SqlDoMonitoring = 
N'
;WITH cteDriveSpace AS 
( 
	SELECT DISTINCT
	    s.volume_mount_point [Drive],
	    CAST(s.available_bytes / 1048576.0 as decimal(20,2)) [AvailableMBs],
		CAST(s.total_bytes / 1048576.0 as decimal(20,2)) [TotalMBs]
	FROM 
	    sys.master_files f
	    CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.[file_id]) s
)

INSERT INTO [My_Diagnostics].dbo.'+@LogTable+'
	(Drive, AvailableMBs, AvailableGBs, TotalMBs, TotalGBs, UsedMBs, UsedGBs, Contents, SampleTime)
SELECT 
	  [Drive]
	, AvailableMBs
	, AvailableGBs=CAST(AvailableMBs/1024 as decimal(20,2))
	, TotalMBs
	, TotalGBs = CAST(TotalMBs/1024 as decimal(20,2))
	, UsedMBs = TotalMBs - AvailableMBs
	, UsedGBs = CAST((TotalMBs - AvailableMBs)/1024 as decimal(20,2))
	, CASE WHEN [Drive] like ''%'+@TempDrive+'%'' THEN ''TEMP'' WHEN [Drive] like ''%'+@DBDataDrive+'%'' THEN ''DATA'' WHEN [Drive] like ''%'+@DBLogsDrive+'%'' THEN ''LOGS'' END
	, DATEADD(HOUR, -8, GETUTCDATE())
FROM cteDriveSpace
'

--PRINT @SqlDoMonitoring

DECLARE @Counter int = 1
WHILE (@Counter <= 1440) -- Minutes per day
BEGIN
	EXECUTE sp_executesql @SqlDoMonitoring
	SELECT @Counter = @Counter + 1
	WAITFOR DELAY '00:01:00'
END

GO








