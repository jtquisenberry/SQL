-- Requires VIEW SERVER STATE permission on master database.
USE [tempdb]

-- Get Running Queries, Method #1
SELECT 
	  sqltext.TEXT
	, req.session_id
	, req.status
	, req.command
	, req.cpu_time
	, req.total_elapsed_time
	, sp.loginame
	, DB_NAME(sp.dbid) as DBName
	, sp.sql_handle
	, sp.stmt_start/2 as stmt_start_char
	, sp.stmt_end/2 as stmt_end_char
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
JOIN master.dbo.sysprocesses sp ON req.session_id = sp.spid


GO

-- Get Running Queries, Method #2
SELECT * FROM master.dbo.sysprocesses p
CROSS APPLY sys.dm_exec_sql_text(sql_handle) t
WHERE p.status not in ('background', 'sleeping')
and   p.cmd not in ('AWAITING COMMAND'
                    ,'MIRROR HANDLER'
                    ,'LAZY WRITER'
                    ,'CHECKPOINT SLEEP'
                    ,'RA MANAGER')
--AND s.spid = 55

GO

-- Get All SPIDs
SELECT * FROM master.dbo.sysprocesses p
CROSS APPLY sys.dm_exec_sql_text(sql_handle) t


