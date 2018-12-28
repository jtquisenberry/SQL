SELECT 
	LEN(cast(i.Recipients as nvarchar(max))) - LEN(REPLACE(cast(i.Recipients as nvarchar(max)), ';', '')) + 1 as RecipientCount
FROM Items i
WHERE UID in (/*List*/)
	AND LEN(cast(i.Recipients as nvarchar(max))) - LEN(REPLACE(cast(i.Recipients as nvarchar(max)), ';', '')) + 1 > 300
