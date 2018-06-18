--Query XML

IF OBJECT_ID('tempdb.dbo.#Animals') IS NOT NULL
BEGIN
	DROP TABLE #Animals
END

CREATE TABLE #Animals
(
	  ID int IDENTITY(1,1)
	, Animal nvarchar (50)
	, Type nvarchar (50) 
)

INSERT INTO #Animals (Animal, [Type])
VALUES 
	  ('Dog', 'Mammal')
	, ('Snake', 'Reptile')
	, ('Hawk','Bird')

SELECT *
FROM #Animals
FOR XML PATH('Row'), Root('Table')