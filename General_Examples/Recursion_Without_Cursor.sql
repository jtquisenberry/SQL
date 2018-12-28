-- Recursion without Cursor

--SELECT OBJECT_ID('tempdb..#Testing','U')
IF OBJECT_ID('tempdb..#ServerList','U') IS NOT NULL
   DROP TABLE tempdb..#ServerList

CREATE TABLE #ServerList
(
   ServerName varchar(200)
)

INSERT INTO #ServerList (ServerName) VALUES ('Server001')
INSERT INTO #ServerList (ServerName) VALUES ('Server002')

DECLARE @SQL			NVARCHAR(MAX),
        @DatabaseName	NVARCHAR(512)
        
SELECT @DatabaseName = 'tempdb..#ServerList'       
        
SELECT @SQL =''
SELECT @SQL = @SQL + 
'BEGIN 
SELECT * FROM #ServerList 
WHERE ServerName = ''' + ServerName + '''
END 

'
FROM #ServerList

PRINT @SQL
 
EXEC (@SQL)