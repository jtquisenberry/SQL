
SELECT a.*
FROM
(
	SELECT i.ItemNumber, i.Scripts, i.ID
	   
	   -- ISNULL
	   -- If there are no scripts, then the results string is NULL. 
	   -- Replace NULL with ''.   
	   ,ISNULL
	   (
		   -- STUFF
		   -- STUFF ( character_expression , start , length , replaceWith_expression )
		   -- STUFF ( <script string>, 1, 1, '') means
		   -- Delete the substring starting at character 1 for 1 characters (;)
		   -- Replace the deleted character with the replacement string of ''.
		   STUFF
		   (
				(
					-- SELECT
					-- An ordinary SELECT query
					SELECT ';' + Property 
					FROM ItemProperties 
					WHERE ItemNumber = i.ItemNumber AND ItemProperties.PropertyGroup = 'LANGUAGESCRIPT'
	                
					-- FOR XML
					-- For each row in the result set, create XML code like this
	                
					-- PATH('')
					-- The "PATH" keyword specifies the structure of the XML tree. If PATH is not given arguments,
					-- then the default structure looks like this.
					--    <row>;Greek</row>
					--    <row>;Latin</row>
					-- If an argument is specified, the row wrapper is given the same name as the argument, e.g.
					-- PATH('TEST') yields
					--    <TEST>;Greek</TEST>
					--    <TEST>;Latin</TEST>
					-- If the argument is empty string '', then there is no row wrapper. 
					-- http://msdn.microsoft.com/en-us/library/ms190922.aspx
					-- This effectively joins the values together.
					-- Since the SELECT statement uses the "+" operator, value wrappers are omitted too.
					FOR XML PATH('')
				 ) ,1,1,'' --End STUFF
		   ) ,'' --End ISNULL
		) as Scripts2 --End column
	FROM Items i  --End query
) a
WHERE a.Scripts <> a.Scripts2 

