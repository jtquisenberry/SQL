--Use Reverse Function as Substitute for InStrRev


declare @txt3 nvarchar(2048)
select @txt3 = 'WHERE (len(Substring([FileDisplayName], (len([FileDisplayName]) - CHARINDEX( ''.'', REVERSE([FileDisplayName])))+2, 255)) > 4) 
