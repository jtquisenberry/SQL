USE [tempdb]

--Method #1
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
WHERE loginame > ''
AND req.session_id = 141
-- total_elapsed_time = 10588673
-- cpu_time = 18441529

--------------------------------------
-- ***********************
--------------------------------------

-- Method 2

SELECT TOP 20
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
        qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
        (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
        qs.total_elapsed_time/1000000,
   st.text,
   qp.query_plan
from
    sys.dm_exec_query_stats as qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
    cross apply sys.dm_exec_query_plan (qs.plan_handle) as qp
ORDER BY qs.total_worker_time desc



select * from sysprocesses