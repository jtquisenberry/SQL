
DECLARE @EmailFields nvarchar(max) = N'1=0'

SELECT @EmailFields = @EmailFields + (
                SELECT N' OR d.[', VirtualTable.FieldName, '] > ''''' 
                    FROM (      SELECT 'TO' AS FieldName 
                                UNION ALL SELECT 'CC'
                                UNION ALL SELECT 'BCC'
                                UNION ALL SELECT 'DATESENT'
                            ) VirtualTable
                INNER JOIN [MyServer].[MyDB].sys.columns sc ON sc.Name=VirtualTable.FieldName AND Object_ID = Object_ID(N'MyDB.dbo.Document')
                    FOR XML PATH(''), TYPE).value('.', 'varchar(max)')

/*
--Output Prior to FOR XML 
 OR	d.[	     TO	         ] > ''
 OR d.[	     CC	         ] > ''
 OR d.[	     BCC	     ] > ''
 OR d.[	     DATESENT    ] > ''
*/

SELECT @EmailFields

/*
--Output including FOR XML
 OR d.[TO] > '' OR d.[CC] > '' OR d.[BCC] > '' OR d.[DATESENT] > ''
*/

