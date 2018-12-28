USE MyDB 
GO  

SELECT 
	  name
	, CAST(size/128.0 as decimal(10,2)) as FileSizeInMB
	, CAST(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 as decimal(10,2)) as FreeSizeMB
	, CAST(CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 as decimal(10,2)) as UsedSizeMB
	, FILEPROPERTY(name, 'IsLogFile') as IsLogFile
	, physical_name
FROM sys.database_files;
GO

