USE [tempdb]

-- Recursion without Cursor

DECLARE @SQL NVARCHAR(MAX)
        
SELECT @SQL =''
SELECT @SQL = @SQL + 
'
 
   SELECT ''' +name+ ''' as Name, COUNT(*) as Count FROM [' + name + ']..MyTable' +
'   
UNION ALL 
'

FROM master.sys.databases 
WHERE name like 'abc[_][0-9]%' 
AND NOT name like '%1111%' AND NOT name like '%2222%'

SELECT @SQL = SUBSTRING(@SQL,0, LEN(@SQL) - 11)
PRINT @SQL

 
EXEC (@SQL)



 