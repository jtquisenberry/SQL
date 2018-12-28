SELECT name, ROW_NUMBER() OVER(ORDER BY name ASC)
FROM sys.databases
WHERE name like N'MyDB_%'