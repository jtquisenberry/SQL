set nocount on
go
 

select @@version
go
 

select 'Edition: ' + convert(char(30), serverproperty('Edition'))
go
 

select 'Product Version: ' + convert(char(20), serverproperty('ProductVersion'))
go
 

select 'Product Level: ' + convert(char(20),serverproperty('ProductLevel'))
go
 

set nocount off
go


