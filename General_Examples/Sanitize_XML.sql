USE [tempdb]

-- Sanitize XML String
-- "FOR XML" is not valid in assignments, but it is valid
-- in subqueries.

DECLARE @MyString nvarchar(max) = N'CΘw<>s&Pi𠀁gs'
DECLARE @MyString2 nvarchar(max) = N'O''Neil'
DECLARE @MyXML XML
SELECT @MyXML = (SELECT @MyString for xml path('Setting1')) + 
              (SELECT @MyString2 for xml path('Setting2'))
SELECT @MyXML = (SELECT @MyXML FOR XML PATH(''), root ('Root'))
SELECT @MyXML as XMLResult
