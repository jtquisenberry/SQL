USE [tempdb]

DECLARE @TempDrive nvarchar(260) = N''
DECLARE @DBDataDrive nvarchar(260) = N''
DECLARE @DBLogsDrive nvarchar(260) = N''

SELECT @TempDrive = SUBSTRING(physical_name, 1, 1)	  
FROM tempdb.sys.database_files;

SELECT @DBDataDrive = SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultDataPath')),1,1)
SELECT @DBLogsDrive = SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultLogPath')),1,1)

SELECT @TempDrive as TempDrive
SELECT @DBDataDrive as DBDataDrive
SELECT @DBLogsDrive as DBLogsDrive


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

SELECT 
	  [Drive]
	, AvailableMBs
	, AvailableGBs=CAST(AvailableMBs/1024 as decimal(20,2))
	, TotalMBs
	, TotalGBs = CAST(TotalMBs/1024 as decimal(20,2))
	, UsedMBs = TotalMBs - AvailableMBs
	, UsedGBs = CAST((TotalMBs - AvailableMBs)/1024 as decimal(20,2))
FROM cteDriveSpace
--WHERE [Drive] like ''+@TempDrive+':\%'