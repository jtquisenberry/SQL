
/* Using JOINs in a DELETE query */

DELETE [MyDB].[dbo].[SubItems2]
FROM [MyDB].[dbo].[SubItems2] s2
LEFT JOIN 
(
	SELECT s.itemnumber, s.subitemnumber
	FROM [MyDB].[dbo].[SubItems2] s
	WHERE s.subitemnumber = 0
 ) s0
 ON s2.itemnumber = s0.itemnumber
 
/* Notice that "tableName" comes immediately after DELETE AND after FROM. */
--DELETE tableName
--FROM tableName tn
--INNER JOIN JoinedTable jn ON jn.col = tn.col
--WHERE jn = someval