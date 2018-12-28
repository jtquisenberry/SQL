USE tempdb

IF OBJECT_ID('tempdb.dbo.#workspaceinfo') is NOT NULL
BEGIN
	DROP TABLE #workspaceinfo
END

CREATE TABLE #workspaceinfo
(
	  ArtifactID int
	, CaseName nvarchar(256)
	, DatabaseName nvarchar(256)
	, TheRow int
	, EstDocumentCount bigint
	, EstEntityCount bigint
)


INSERT INTO #workspaceinfo (ArtifactID, CaseName, DatabaseName, TheRow)
SELECT ec.ArtifactID, ec.Name, sd.Name, ROW_NUMBER() OVER(ORDER BY sd.Name) as TheRow
FROM   [PrimaryRelativityServer].EDDS.EDDSDBO.ExtendedCase ec with(nolock)
JOIN sys.databases sd with(nolock) ON 'EDDS'+convert (varchar(50),ec.ArtifactID)=SD.name
WHERE DBLocation = @@SERVERNAME
	AND StatusName in ('Active', 'Internal', 'Nearline')
	AND SD.state_desc <> 'OFFLINE'
	AND NOT (ec.Name LIKE '%DONOTUSE%' OR ec.Name LIKE '%Template%')
	AND NOT (CHARINDEX('[Test]', ec.Name)) > 0

SELECT * FROM #workspaceinfo