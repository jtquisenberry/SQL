USE [tempdb]

SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'TEMP'
ORDER BY SampleTime ASC

SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'TEMP'
ORDER BY SampleTime DESC

SELECT MAX(AvailableMBs) as MaxMBs, MIN(AvailableMBs) as MinMBs
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'TEMP'


SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'DATA'
ORDER BY SampleTime ASC

SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'DATA'
ORDER BY SampleTime DESC

SELECT MAX(AvailableMBs) as MaxMBs, MIN(AvailableMBs) as MinMBs
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'DATA'



SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'LOGS'
ORDER BY SampleTime ASC

SELECT TOP 1 (AvailableMBs)
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'LOGS'
ORDER BY SampleTime DESC

SELECT MAX(AvailableMBs) as MaxMBs, MIN(AvailableMBs) as MinMBs
FROM [tempdb].[dbo].[Drive_Space_20170130_162847]
WHERE Contents like 'LOGS'














--SELECT  SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultDataPath')),1,1) as data
--SELECT  SUBSTRING(CONVERT(nvarchar(260), SERVERPROPERTY('InstanceDefaultLogPath')),1,1) as logs