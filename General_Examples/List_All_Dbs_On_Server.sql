-- Option 1 (BEST)
SELECT * FROM sys.databases


-- Option 2

select * 
from master.dbo.sysdatabases
where name like '%MyDB%'


-- Option 3

EXEC sp_databases