
--**************************************************
--Backup Transaction Log ldf file
--**************************************************
BACKUP Log [Twitter001] 
TO  DISK = N'E:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Twitter001.ldf.bak' 
WITH NOFORMAT, NOINIT, NAME = N'Twitter001-Transaction Log Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
--**************************************************

--**************************************************
-- View recovery model
--**************************************************

SELECT name AS [Twitter001],
recovery_model_desc AS [Recovery Model] FROM sys.databases
GO


--**************************************************
-- Truncate Transaction Log
--**************************************************
USE Twitter001;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE Twitter001
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (Twitter001_Log, 1024);
GO
-- Reset the database recovery model.
ALTER DATABASE Twitter001
SET RECOVERY FULL;
GO
--**************************************************