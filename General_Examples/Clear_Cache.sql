/*

    DBCC DROPCLEANBUFFERS clears clean (unmodified) pages from the buffer pool
    Precede that with a CHECKPOINT to flush any dirty pages to disk first
    DBCC FLUSHPROCINDB clears execution plans for that database

http://dba.stackexchange.com/questions/10818/sql-server-commands-to-clear-caches-before-running-a-performance-comparison
*/


USE [MyDB]
DECLARE @DBID smallint = DB_ID()
SELECT @DBID
DBCC DROPCLEANBUFFERS 
DBCC FLUSHPROCINDB(@DBID)
DBCC FREEPROCCACHE 
DBCC FREESESSIONCACHE

