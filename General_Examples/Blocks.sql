SELECT 
	 SUBSTRING(sqltext.text, (req.statement_start_offset/2)+1,   
        ((CASE req.statement_end_offset  
          WHEN -1 THEN DATALENGTH(sqltext.text)  
         ELSE req.statement_end_offset  
         END - req.statement_start_offset)/2) + 1) AS Query
	, req.session_id
	, req.status
	, req.command
	, s.login_name
	, DB_NAME(s.database_id) as DatabaseName
	, req.blocking_session_id
	, s2.login_name as BlockingUser
	, DB_NAME(s2.database_id) as BlockingDBName
FROM sys.dm_exec_requests req
JOIN sys.dm_exec_sessions s ON req.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
LEFT JOIN sys.dm_exec_sessions s2 ON req.blocking_session_id = s2.session_id



