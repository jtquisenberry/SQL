USE [tempdb]

-- Query Database Files Begin
SELECT TOP 1 FileSizeInMB, * 
FROM [dbo].[MyDB] 
WHERE Physical_Name like N'%.mdf%'
ORDER BY SampleTime ASC

-- Query Database Files End
SELECT TOP 1 FileSizeInMB, * 
FROM [dbo].[MyDB] 
WHERE Physical_Name like N'%.mdf%'
ORDER BY SampleTime DESC

-- Query Database Files Max, Min
SELECT MAX(FileSizeInMB) as MaxFileSize, MIN(FileSizeInMB) as MinFileSize,  MAX(UsedSizeMB) as UsedSizeMB, MAX([FreeSizeMB]) as FreeSizeMB
FROM [dbo].[MyDB]
WHERE Physical_Name like N'%.mdf%'


-- Query Transaction Log Files Begin
SELECT TOP 1 FileSizeInMB, * 
FROM [dbo].[MyDB] 
WHERE IsLogFile = 1
ORDER BY SampleTime ASC

-- Query Transaction Log Files End
SELECT TOP 1 FileSizeInMB, * 
FROM [dbo].[MyDB] 
WHERE IsLogFile = 1
ORDER BY SampleTime DESC

-- Query Transaction Log Files Max, Min
SELECT MAX(FileSizeInMB) as MaxFileSize, MIN(FileSizeInMB) as MinFileSize,  MAX(UsedSizeMB) as UsedSizeMB, MAX([FreeSizeMB]) as FreeSizeMB
FROM [dbo].[MyDB]
WHERE IsLogFile = 1


-- Query tempdb Database Begin
SELECT TOP 1 DBFileMB FROM
(
	SELECT SUM(FileSizeInMB) as DBFileMB, SampleTime 
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE Physical_Name like N'%.mdf%' Group by SampleTime
) a
ORDER BY SampleTime ASC

-- Query tempdb Database End
SELECT TOP 1 DBFileMB FROM
(
	SELECT SUM(FileSizeInMB) as DBFileMB, SampleTime 
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE Physical_Name like N'%.mdf%' Group by SampleTime
) a
ORDER BY SampleTime DESC

-- Query tempdb Database Max, Min
SELECT MAX(FileSizeInMB) as MaxFileSize, MIN(FileSizeInMB) as MinFileSize,  MAX(UsedSizeMB) as UsedSizeMB, MAX([FreeSizeMB]) as FreeSizeMB FROM
( 
	SELECT SUM(FileSizeInMB) as FileSizeInMB, SUM(UsedSizeMB) as UsedSizeMB, SUM(FreeSizeMB) as FreeSizeMB, SampleTime
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE Physical_Name like N'%.mdf%' Group by SampleTime
) a



-- Query tempdb Transaction Begin
SELECT TOP 1 DBFileMB FROM
(
	SELECT SUM(FileSizeInMB) as DBFileMB, SampleTime 
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE IsLogFile = 1 Group by SampleTime
) a
ORDER BY SampleTime ASC

-- Query tempdb Transaction End
SELECT TOP 1 DBFileMB FROM
(
	SELECT SUM(FileSizeInMB) as DBFileMB, SampleTime 
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE IsLogFile = 1 Group by SampleTime
) a
ORDER BY SampleTime DESC

-- Query tempdb Transaction Max, Min
SELECT MAX(FileSizeInMB) as MaxFileSize, MIN(FileSizeInMB) as MinFileSize,  MAX(UsedSizeMB) as UsedSizeMB, MAX([FreeSizeMB]) as FreeSizeMB FROM
( 
	SELECT SUM(FileSizeInMB) as FileSizeInMB, SUM(UsedSizeMB) as UsedSizeMB, SUM(FreeSizeMB) as FreeSizeMB, SampleTime
	FROM My_DIAG_tempdb_20170111_170715 
	WHERE IsLogFile = 1 Group by SampleTime
) a

