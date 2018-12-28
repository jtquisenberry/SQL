
USE [tempdb]

-- BEGIN User Variables
DECLARE @LogTable nvarchar(max) = N'Running_Queries' --<--
-- END User Variables

SELECT @LogTable = REPLACE(REPLACE(REPLACE(@LogTable + N'_' + CONVERT(VARCHAR(20),DATEADD(HOUR, -8, GETUTCDATE()),120),' ', '_'),'-',''), ':','')

DECLARE @SqlCreateTable nvarchar(max)
SELECT @SqlCreateTable = 
N'
CREATE TABLE [tempdb].dbo.'+@LogTable+'
(
	  Query nvarchar(max)
	, Text nvarchar(max)
	, session_id smallint
	, [Status] nvarchar(30)
	, command nvarchar(32)
	, cpu_time int
	, wait_type nvarchar(128)
	, wait_time int
	, reads int
	, writes int
	, total_elapsed_time int
	, loginame nvarchar(128)
	, DBName nvarchar(128)
	, sql_handle binary(20)
	, stmt_start_char int
	, stmt_end_char int
	, SampleTime datetime
)
'


--PRINT @SqlCreateTable
EXECUTE sp_executesql @SqlCreateTable

DECLARE @SqlDoMonitoring nvarchar(max)
SELECT @SqlDoMonitoring = 
N'
INSERT INTO [tempdb].dbo.'+@LogTable+' 
	(Query, Text, session_id, [Status], command, cpu_time, wait_type, wait_time, reads, writes, total_elapsed_time, loginame, DBName, sql_handle, stmt_start_char, stmt_end_char, SampleTime)
SELECT 
	  SUBSTRING(sqltext.TEXT, 
		(CASE WHEN sp.stmt_start/2 < 0 THEN 0 ELSE sp.stmt_start/2 END), 
		(CASE WHEN sp.stmt_end/2 - sp.stmt_start/2 < 0 THEN 0 ELSE sp.stmt_end/2 - sp.stmt_start/2 END)) as Query
	, sqltext.TEXT
	, req.session_id
	, req.status
	, req.command
	, req.cpu_time
	, req.wait_type
	, req.wait_time
	, req.reads
	, req.writes
	, req.total_elapsed_time
	, sp.loginame
	, DB_NAME(sp.dbid) as DBName
	, sp.sql_handle
	, case sp.stmt_start when 0 then 0 else sp.stmt_start / 2 end as stmt_start_char
	, case sp.stmt_end when -1 then -1 else sp.stmt_end / 2 end as stmt_end_char
	, DATEADD(HOUR, -8, GETUTCDATE())
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
JOIN master.dbo.sysprocesses sp ON req.session_id = sp.spid
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








