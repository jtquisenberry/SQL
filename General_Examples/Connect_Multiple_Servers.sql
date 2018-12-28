-- Query multiple SQL Servers without using linked servers.
/*
	--In SQL Server Management Studio, turn on SQLCMD mode from the Query menu. Then at the top of your script, type in the command below

	--:Connect server_name[\instance_name] [-l timeout] [-U user_name [-P password]
	--http://stackoverflow.com/questions/125457/what-is-the-t-sql-syntax-to-connect-to-another-sql-server
*/



IF OBJECT_ID('tempdb.dbo.#AllServers') is NOT NULL
BEGIN
	DROP TABLE #AllServers
END

CREATE TABLE #AllServers
(
	  [ServerID] int NOT NULL IDENTITY(1,1)	
	, [Name] nvarchar(250)
	, [Description] nvarchar(500)
)

INSERT INTO #AllServers ([Name], [Description])
VALUES
  (N'Server1\Instance1', N'Server1')
, (N'Server2\Instance2', N'Server2')
, (N'Server3\Instance3', N'Server3')
, (N'Server4\Instance4', N'Server4')
, (N'Server5\Instance5', N'Server5')




--SELECT * FROM #AllServers
DECLARE @CurrentNum int = 1
DECLARE @MaxNum int = (SELECT MAX(ServerID) FROM #AllServers)

WHILE @CurrentNum <= @MaxNum
BEGIN
	
	DECLARE @Name nvarchar(250) = (SELECT TOP 1 [Name] FROM #AllServers WHERE ServerID = @CurrentNum)

	DECLARE @sql nvarchar(max) = N''
	SELECT @sql = @sql +
	N'
	:Connect ' + @Name + '
	SELECT @@SERVERNAME, * FROM INFORMATION_SCHEMA.COLUMNS 
	GO
	'
	PRINT @sql
	SELECT @CurrentNum = @CurrentNum + 1
END


