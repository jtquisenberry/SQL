USE [tempdb]

-- Method 1
EXECUTE sp_who2

-- Method 2
SELECT * FROM sys.dm_tran_locks 

-- Method 3
EXECUTE sp_lock

