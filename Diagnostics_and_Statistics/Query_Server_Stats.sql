
-- GET Begin Stats
SELECT TOP 1 cpu_usage, memory_usage
FROM [dbo].[Server_Stats_20170130_162832]
ORDER BY SampleTime ASC

-- GET End Stats
SELECT TOP 1 cpu_usage, memory_usage
FROM [dbo].[Server_Stats_20170130_162832]
WHERE SampleTime < '2017-01-31 1:00:00.000'
ORDER BY SampleTime DESC

--Get MAX and MIN
SELECT MAX(cpu_usage), MIN(cpu_usage), MAX(memory_usage), MIN(memory_usage)
FROM [dbo].[Server_Stats_20170130_162832]
WHERE SampleTime < '2017-01-31 1:00:00.000'
