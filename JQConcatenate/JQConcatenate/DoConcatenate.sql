USE [MyDB]

IF OBJECT_ID('tempdb..#ConcatExample') is not null 
BEGIN
	DROP TABLE #ConcatExample
END

CREATE TABLE #ConcatExample
(
	  ID int
	, String nvarchar(max)
)

INSERT INTO #ConcatExample (ID, String) 
VALUES 
	  (1, N'abc') -- BMP
	, (1, N'𠀁') -- SIP
	, (1, N'') -- Empty String
	, (1, CAST(Char(0) as nvarchar(max))+N'xxx') -- NULL control character
	, (1, NULL)
	, (1, N'𐐥') -- SMP
	, (1, Char(6)) -- Control 6
	, (1, N'<&>')

SELECT * FROM #ConcatExample
SELECT 
	  ID
	, Strings = My_DB.dbo.JQConcatenate(String,N'+') 
	, Binary = CONVERT(varbinary(4000), My_DB.dbo.JQConcatenate(String,N'+'))
FROM #ConcatExample
GROUP BY ID




