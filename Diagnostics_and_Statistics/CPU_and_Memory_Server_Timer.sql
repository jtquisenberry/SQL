-- Based on http://dba.stackexchange.com/questions/34421/detecting-sql-server-utilization-with-a-query
-- Requires VIEW SERVER STATE permission on the server.


USE [tempdb]

-- BEGIN User Variables
DECLARE @LogTable nvarchar(max) = N'Server_Stats' --<--
-- END User Variables

SELECT @LogTable = REPLACE(REPLACE(REPLACE(@LogTable + N'_' + CONVERT(VARCHAR(20),DATEADD(HOUR, -8, GETUTCDATE()),120),' ', '_'),'-',''), ':','')

DECLARE @SqlCreateTable nvarchar(max)
SELECT @SqlCreateTable = 
N'
CREATE TABLE [tempdb].dbo.'+@LogTable+'
(
	  memory_usage FLOAT
	, cpu_usage FLOAT
	, SampleTime datetime NULL
)
'
--PRINT @SqlCreateTable
EXECUTE sp_executesql @SqlCreateTable

DECLARE @Counter int = 1
WHILE (@Counter <= 1440) -- Minutes per day
BEGIN
	DECLARE @memory_usage FLOAT
	DECLARE @cpu_usage FLOAT

	SET @memory_usage = 
	(
		SELECT 1.0 - ( available_physical_memory_kb / ( total_physical_memory_kb * 1.0 ) ) memory_usage
		FROM      sys.dm_os_sys_memory
	)

	SET @cpu_usage = 
	(
		SELECT TOP 1 [CPU] / 100.0 AS [CPU_usage]
		FROM
		(
			SELECT 
				  record.value('(./Record/@id)[1]', 'int') AS record_id
				, record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [CPU]
			FROM
			(
				SELECT 
					  [timestamp]
					, CONVERT(XML, record) AS [record]
				FROM sys.dm_os_ring_buffers WITH ( NOLOCK )
				WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
					AND record LIKE N'%<SystemHealth>%'
			) AS x
		) AS y
		ORDER BY record_id DESC
	)

/*
	SELECT  @memory_usage [memory_usage]
			, @cpu_usage [cpu_usage]
*/

	DECLARE @SqlDoMonitoring nvarchar(max)
	SELECT @SqlDoMonitoring = 
	N'
		INSERT INTO [tempdb].dbo.'+@LogTable+' (memory_usage, cpu_usage, SampleTime)
		SELECT '+ CAST(@memory_usage as nvarchar(36))+', '+CAST(@cpu_usage as nvarchar(36))+', DATEADD(HOUR, -8, GETUTCDATE())
	
	'


	EXECUTE sp_executesql @SqlDoMonitoring
	SELECT @Counter = @Counter + 1
	WAITFOR DELAY '00:01:00'
END