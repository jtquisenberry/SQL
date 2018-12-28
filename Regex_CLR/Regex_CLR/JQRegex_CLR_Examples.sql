USE [MyTest]
GO




SELECT dbo.RegExMatch('\d+', ' somewhere there is a number 4567 and then more ',1) as Match


SELECT dbo.RegExMatchGroups('(((\d)(\d)\d)+)', ' somewhere there is a number 4567 and then more ',1) as Match




SELECT * FROM dbo.RegExSplit('\W+','this is an exciting  regular   expression',1)



