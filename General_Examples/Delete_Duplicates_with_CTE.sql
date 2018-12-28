--===================================
-- Delete duplicates with CTE
-- Window functions
-- PARTITION BY
--===================================

CREATE TABLE xFilterTerm
(
	[FilterTermID] [int]  NULL,
	[FilterTagID] [int]  NULL,
	[FilterTerm] [nvarchar](max)  NULL,
	[Alias] [nvarchar](max)  NULL
)

INSERT INTO xFilterTerm (FilterTermID, FilterTagID, FilterTerm, Alias)
VALUES 
 (1, 1, '(energy OR mmhhmm) AND flag:audited', 'energy')
,(2, 1, '(ubs OR mmhhmm) AND flag:audited', 'energy')
,(3, 1, '(ubs OR mmhhmm) AND flag:audited', 'energy')


WITH cteDupes AS
(
	SELECT *, RowNum = ROW_NUMBER() OVER (PARTITION BY FilterTagID, FilterTerm, Alias ORDER BY FilterTagID, FilterTerm, Alias, FilterTermID ASC)
    FROM dbo.xFilterTerm 
)
--DELETE FROM cteDupes
SELECT * FROM cteDupes
WHERE RowNum > 1;
  
-- More window functions
SELECT FilterTagID, FilterTermID, theCount = COUNT(FilterTagID) OVER (PARTITION BY FilterTagID) FROM xFilterTerm
SELECT FilterTagID, FilterTermID, ROW_NUMBER() OVER (ORDER BY FilterTagID ASC, FilterTermID ASC) FROM xFilterTerm
