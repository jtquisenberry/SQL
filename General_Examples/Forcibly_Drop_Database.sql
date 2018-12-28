
/* Query to Get Exclusive Access of SQL Server Database before Dropping the Database  */

USE [tempdb]
GO 

ALTER DATABASE [MyDB] 
SET SINGLE_USER  --or RESTRICTED_USER
WITH ROLLBACK IMMEDIATE;
GO

/* Query to Drop Database in SQL Server  */

DROP DATABASE [MyDB]
GO

