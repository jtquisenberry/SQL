USE [tempdb]

SELECT 
	   [session_id]
      ,[Status]
      ,[command]
      ,[cpu_time]
      ,[wait_type]
      ,[wait_time]
      ,[reads]
      ,[writes]
      ,[total_elapsed_time]
      ,[loginame]
      ,[DBName]
      ,[sql_handle]
      ,[stmt_start_char]
      ,[stmt_end_char]
      ,[SampleTime]
FROM [tempdb].[dbo].[Running_Queries_20170125_164710]
WHERE session_id = 99
	AND [TEXT] like '%DocCountB%'
ORDER BY SampleTime ASC



-- Get wait time
SELECT SUM(wait_time), wait_type
FROM [tempdb].[dbo].[Running_Queries_20170125_164710]
WHERE session_id = 99
	AND [TEXT] like '%DocCountB%'
	--AND SampleTime < '2017-01-25 23:59:16.683'
GROUP BY wait_type

-- Get Reads, Writes
SELECT TOP 1 reads, writes, cpu_time
FROM [tempdb].[dbo].[Running_Queries_20170125_164710]
WHERE session_id = 99
	AND [TEXT] like '%DocCountB%'
	--AND SampleTime < '2017-01-25 23:59:16.683'
ORDER BY SampleTime DESC






--57212561

  --ORDER BY SampleTime ASC
  
 -- 85
--99