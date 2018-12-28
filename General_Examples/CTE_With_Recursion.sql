----==========================================================================
-- CTE Common Table Expressions with Recursion
-- Reference: https://msdn.microsoft.com/en-us/library/ms175972.aspx
----==========================================================================

-- Demonstrates that if there is not limiting condition, the recursive 
-- member continues to execute until MAXRECURSION is reached.
-- Demonstrates that the anchor member is called only once.

WITH ShowMessage(PHRASE, LENGTH)
AS
(
	-- Anchor member
	SELECT PHRASE = CAST('I Like ' AS VARCHAR(300)), LEN('I Like ')
	UNION ALL
	-- Recursive member
	select CAST('A' as varchar(300)),0 from ShowMessage
)
SELECT PHRASE, LENGTH FROM ShowMessage
OPTION (MAXRECURSION 100);

----==========================================================================
----==========================================================================

-- Demonstrates that recursion ceases when the recursive member
-- returns zero rows. 

WITH ShowMessage(PHRASE, LENGTH)
AS
(
	-- Anchor member
	SELECT PHRASE = CAST('I Like ' AS VARCHAR(300)), LEN('I Like ')
	UNION ALL
	-- Recursive member
	SELECT
		  CAST(PHRASE + 'CodeProject! ' AS VARCHAR(300))
		  , LEN(CAST(PHRASE + 'CodeProject! ' AS VARCHAR(300))) FROM ShowMessage
	WHERE LENGTH < 300
)
SELECT PHRASE, LENGTH FROM ShowMessage
OPTION (MAXRECURSION 100);

----==========================================================================
----==========================================================================

-- Demonstrates CTE with hierarchical data.
-- Reference: 

-- Create an Employee table.
CREATE TABLE Employee
(
	EmpID int  NULL,
	FirstName nvarchar(300)  NULL,
	LastName  nvarchar(400)  NULL,
	ManagerID int  NULL
);

-- Populate the table with values.
INSERT INTO Employee VALUES 
 (11, N'Sally', N'Smith', NULL)
,(1, N'Alex', N'Adams', 11)
,(2, N'Barry', N'Brown', 11)
,(3, N'Lee', N'Osako', 11)
,(4, N'David', N'Kennson', 11)
,(5, N'Eric', N'Bender', 11)
,(6, N'Lisa', N'Kendall', 4)
,(7, N'David', N'Lonning', 11)
,(8, N'John', N'Marshbank', 4)
,(9, N'James', N'Newton', 3)
,(10, N'Terry', N'OHare', 3)
,(12, N'Barbara', N'ONeil', 4)
,(13, N'Phil', N'Wilconkinski', 4);

GO

WITH EmployeeList AS
(
	-- Anchor member
	SELECT Boss.EmpID, Boss.FirstName, Boss.LastName, Boss.ManagerID,
	1 as EmpLevel, CAST(Boss.LastName + ', ' + Boss.FirstName as nvarchar(1000)) as Hierarchy
	FROM Employee as Boss
	WHERE Boss.ManagerID is null

	UNION ALL

	-- Recursive member
	SELECT Emp.EmpID, Emp.FirstName, Emp.LastName, Emp.ManagerID,
	EL.EmpLevel + 1, CAST(Emp.LastName + ', ' + Emp.FirstName + '->' + EL.Hierarchy as nvarchar(1000)  ) as Hierarchy
	FROM Employee as Emp
	INNER JOIN EmployeeList EL
	ON Emp.ManagerID = EL.EmpID
	WHERE Emp.ManagerID is not null
)
SELECT * FROM EmployeeList
-- Adjust this to 1 or 2 to see the recursion one step at a time.
OPTION (MAXRECURSION 100);

--DROP TABLE Employee