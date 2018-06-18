


/************** Example 1 *************/
CREATE TABLE #example (
   id int,
   document NText
);
INSERT INTO #example (id,document)
SELECT 9,N'<email><account language="en" /></email>';

WITH XmlExample AS (
  SELECT id, CONVERT(XML, document) doc
  FROM #example
)
SELECT
  id, C.value('@language', 'VarChar(2)') lang
FROM XmlExample CROSS APPLY
     XmlExample.doc.nodes('//account') X(C);

DROP TABLE #example;
/************** Example 1 *************/


/************** Example 2 *************/
WITH XmlConversion as 
(
	SELECT ProcessRunID, CONVERT(XML, ProcessSettings) as settings
	FROM ProcessSession
	WHERE ProcessRunID BETWEEN 196 and 200
)
SELECT
	ProcessRunID
	, b.value('UseInternalCases[1]', 'nvarchar(100)') as UseInternalCases
FROM XmlConversion CROSS APPLY
	XmlConversion.settings.nodes('Root') a(b)
/************** Example 2 *************/


/************** Example 3 *************/
DECLARE @xml xml
SET @xml = 
'<GespeicherteDaten>
<strategieWuerfelFelder Type="strategieWuerfelFelder">
    <Felder X="3" Y="3" Z="3">
        <Feld X="1" Y="1" Z="1">
            <strategieWuerfelFeld Type="strategieWuerfelFeld">
                <Name>Name</Name>
                <Beschreibung>Test</Beschreibung>
            </strategieWuerfelFeld>
        </Feld>
        <Feld X="1" Y="1" Z="2">
            <strategieWuerfelFeld Type="strategieWuerfelFeld">
                <Name>Name2</Name>
                <Beschreibung>Test2</Beschreibung>
            </strategieWuerfelFeld>
        </Feld>
    </Felder>
</strategieWuerfelFelder></GespeicherteDaten>'

SELECT 
    b.value('@X', 'int') as X
  , b.value('@Y', 'int') as Y
  , b.value('@Z', 'int') as Z
  , b.value('(./strategieWuerfelFeld/Name/text())[1]','Varchar(50)') as [Name]
  , b.value('../@X','int') as Felder_X
  , b.value('../@Y','int') as Felder_Y
  , b.value('../@Z','int') as Felder_Z  
FROM @xml.nodes('/GespeicherteDaten/strategieWuerfelFelder/Felder/Feld') as a(b) 
/************** Example 3 *************/

/************** Example 4 *************/

DROP TABLE #example
CREATE TABLE #example (
   id int,
   Regex nvarchar(max)
);
INSERT INTO #example (id,Regex)
SELECT 9,
N'<Root>
    <Query>
        <Name>SD_SSN</Name>
        <Regex>(?i)\b((?!123-45-6789)((?!9|666|000)\d{3}([- .])(?!00)\d{2}(\3)(?!0000)\d{4}\W*(?:\w+\W+){0,12}?)(Internal Revenue Service|IRS|I\.R\.S\.|SS:|HR|human resources|SS#|SS #|Partner''s identifying number|Tax ID|Taxpayer Identification|SSN|Social Security|SocSecNum|SS No)|(Internal Revenue Service|IRS|I\.R\.S\.|SS:|HR|human resources|SS#|SS #|Partner''s identifying number|Tax ID|Taxpayer Identification|SSN|Social Security|SocSecNum|SS No)\W*(?:\w+\W+){0,12}(?!123-45-6789)(?!9|666|000)\d{3}([- .])(?!00)\d{2}(\7)(?!0000)\d{4})(?=\b|_)</Regex>
    </Query>
    <Query>
        <Name>SD_CCN</Name>
        <Regex>(?i)\b((?:4\d{3}[ -]*\d{4}[ -]*\d{4}[ -]*\d(?:\d{3})?|(?:5[1-5]\d{2}|222[1-9]|22[3-9]\d|2[3-6]\d{2}|27[01]\d|2720)[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|6(?:011|5\d{2})[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|3[47]\d{2}[ -]*\d{6}[ -]*\d{5}|3(?:0[0-5]|[68]\d)\d[ -]*\d{6}[ -]*\d{4}|(?:2131|1800)[ -]*\d{6}[ -]*\d{5}|35\d{2}[ -]*\d{4}[ -]*\d{4}[ -]*\d{4})\W+(?:\w+\W+){0,18}?(CCN|Credit card|CCA|CC numbers|CC number|CC#|CC #|CCs|card number|Ccd Card Account #|Stage of the acct|Account #|AcctNbr|ACCESS_MEDIUM_NO|MBNA Account|returned accounts|returned account|Expriration|Expiration|Date of Referral|collection|collector|settlement|settle|ACCTNO)|(CCN|Credit card|CCA|CC numbers|CC number|CC#|CC #|CCs|card number|Ccd Card Account #|Stage of the acct|Account #|AcctNbr|ACCESS_MEDIUM_NO|MBNA Account|returned accounts|returned account|Expriration|Expiration|Date of Referral|collection|collector|settlement|settle|ACCTNO)\W+(?:\w+\W+){0,18}(?:4\d{3}[ -]*\d{4}[ -]*\d{4}[ -]*\d(?:\d{3})?|(?:5[1-5]\d{2}|222[1-9]|22[3-9]\d|2[3-6]\d{2}|27[01]\d|2720)[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|6(?:011|5\d{2})[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|3[47]\d{2}[ -]*\d{6}[ -]*\d{5}|3(?:0[0-5]|[68]\d)\d[ -]*\d{6}[ -]*\d{4}|(?:2131|1800)[ -]*\d{6}[ -]*\d{5}|35\d{2}[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}))(?=\b|_)</Regex>
    </Query>
</Root>
'N'<email><account language="en" /></email>';


WITH XmlConversion as 
(
	SELECT id, CONVERT(XML, Regex) as settings
	FROM #example
)
SELECT
	id
	, b.value('Name[1]', 'nvarchar(100)') as ID
	, b.value('Regex[1]', 'nvarchar(max)') as Regex
FROM XmlConversion CROSS APPLY
	XmlConversion.settings.nodes('Root/Query') a(b)










/************** Example 4 *************/


/************** Example 5 *************/
-- How to use For XML for concatenation without mangling XML characters.



SELECT DISTINCT 
	ST2.RunID, 
	SUBSTRING
	(
		CAST
		(
			(
				SELECT ','+ST1.ESITicket + '&<>'  AS [text()]
				FROM dbo.[TiMetrics] ST1
				WHERE ST1.RunID = ST2.RunID
				ORDER BY ST1.RunID
				For XML PATH (''), root('xxx'), type -- type helps avoid problem XML characters
			).value('.','nvarchar(max)')  -- .value helps avoid problem XML characters
			as nvarchar(max)
		)
		 ,2, 8000
	) as Tickets
FROM dbo.[TiMetrics] ST2

/************** Example 5 *************/