
USE [tempdb]

-- BEGIN User Variables
DECLARE @DatabaseToMonitor nvarchar(max) = N'MyDB' --<--
-- END User Variables

DECLARE @LogTable nvarchar(max) = REPLACE(REPLACE(REPLACE(N'ENG_DIAG_' + @DatabaseToMonitor + N'_' + CONVERT(VARCHAR(20),DATEADD(HOUR, -8, GETUTCDATE()),120),' ', '_'),'-',''), ':','')

DECLARE @SqlCreateTable nvarchar(max)
SELECT @SqlCreateTable = 
N'
CREATE TABLE [tempdb].dbo.'+@LogTable+'
(
	  [Name] nvarchar(max)
	, FileSizeInMB decimal(10,2)
	, FreeSizeMB decimal(10,2)
	, UsedSizeMB decimal(10,2)
	, IsLogFile int
	, Physical_Name nvarchar(max)
	, SampleTime datetime
)
'
--PRINT @SqlCreateTable
EXECUTE sp_executesql @SqlCreateTable

DECLARE @SqlDoMonitoring nvarchar(max)
SELECT @SqlDoMonitoring = 
N'
IF DB_ID('''+@DatabaseToMonitor+''') is NOT NULL
BEGIN
	USE ['+@DatabaseToMonitor+']
	INSERT INTO [tempdb].dbo.'+@LogTable+' ([Name], FileSizeInMB, FreeSizeMB, UsedSizeMB, IsLogFile, Physical_Name, SampleTime)
	SELECT 
		  name
		, CAST(size/128.0 as decimal(10,2)) as FileSizeInMB
		, CAST(size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 as decimal(10,2)) as FreeSizeMB
		, CAST(CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 as decimal(10,2)) as UsedSizeMB
		, FILEPROPERTY(name, ''IsLogFile'') as IsLogFile
		, physical_name
		, DATEADD(HOUR, -8, GETUTCDATE())
	FROM ['+@DatabaseToMonitor+'].sys.database_files;
END
'

PRINT @SqlDoMonitoring

DECLARE @Counter int = 1
WHILE (@Counter <= 1440) -- Minutes per day
BEGIN
	EXECUTE sp_executesql @SqlDoMonitoring
	SELECT @Counter = @Counter + 1
	WAITFOR DELAY '00:01:00'
END

GO








