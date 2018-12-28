#Add-PSSnapin SqlServerCmdletSnapin100
#Add-PSSnapin SqlServerProviderSnapin100

#$MyArray = "MyVar1 = 'String1'", "MyVar2 = 'String2'"  
#Invoke-Sqlcmd -Query "SELECT `$(MyVar1) AS Var1, `$(MyVar2) AS Var2;" -Variable $MyArray  
#Invoke-Sqlcmd -Query "SELECT 1"

Set-Location SQLSERVER:\SQL\MyServer  
Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance (Get-Item .) 