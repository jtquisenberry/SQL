
BEGIN
	Declare @DbName varchar(1000);
	DECLARE @ICURSOR CURSOR;
	Declare @strQueryText as varchar(1000);
	
	--Point cursor to the name field of the table containing all database names.
	SET @ICURSOR =CURSOR FOR SELECT /*top 1*/ name FROM master..sysdatabases where name like 'DB%';	
		
	-- Open is a formality that must be performed before iterating a cursor.
	OPEN @ICURSOR
	
	--Grab the next row from @ICURSOR
	FETCH NEXT FROM @ICURSOR INTO @DbName
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN
           --do anything you want to do for each row           
           SELECT @strQueryText = 'INSERT INTO MyDb.dbo.subitems ' + 'SELECT * FROM ' + @DbName + '.dbo.subitems' + ' WHERE (1 = 1)'
           EXEC(@strQueryText)
    
	FETCH NEXT FROM @ICURSOR INTO @DbName;
    	--This is like exit.
    END
        
	CLOSE @ICURSOR
	DEALLOCATE @ICURSOR;

END 
  