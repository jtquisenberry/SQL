--Set active database
USE [MyDB]
GO

--Create table structure
SELECT * INTO MyTableDestination FROM IntItems WHERE 1=0
GO

--Delete indexes
--There were no indexes.

--Create unique key constraint
--Set IGNORE_DUP_KEY = ON
ALTER TABLE [dbo].[MyTableDestination] ADD  CONSTRAINT [IntMsgIDC] UNIQUE NONCLUSTERED 
(
	[IntMsgID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = ON, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--Set IDENTITY_INSERT = ON
USE [MyDB]
SET IDENTITY_INSERT [MyDB].dbo.MyTableDestination ON
GO

--Copy records from source to destination, understanding that a field list is required
USE [MyDB]
INSERT INTO MyTableDestination ([MD5Hash], [Title])
SELECT [MD5Hash], [Title]
FROM MyTableSource
WHERE MD5Hash is not null
GO

