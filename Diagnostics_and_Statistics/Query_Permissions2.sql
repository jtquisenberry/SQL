-- 1. Query Server Roles
USE [tempdb]
SELECT sp.Name as RoleName, sp2.Name as PrincipalName FROM sys.server_principals sp 
JOIN sys.server_role_members srm ON sp.principal_id = srm.role_principal_id
JOIN sys.server_principals sp2 ON sp2.principal_id = srm.member_principal_id
WHERE  (sp2.Name = 'MyName' )
ORDER BY sp2.Name, sp.Name


-- 2. Query DB Permissions
USE MyDB
SELECT dp.name as RoleName , us.name as DatabaseUser, sp.Name as ServerUser
FROM sys.sysusers us 
RIGHT JOIN  sys.database_role_members rm ON us.uid = rm.member_principal_id
JOIN sys.database_principals dp ON rm.role_principal_id =  dp.principal_id
LEFT JOIN sys.server_principals sp ON us.sid = sp.sid
WHERE 
	   ((us.Name = 'MyName' OR sp.Name = 'MyName') )
ORDER BY us.name, dp.name


-- 3. Query sp_send_mail
USE msdb
SELECT prin.name as GranteeName, perm.permission_name as PermissionName, obj.name as ObjectName, perm.state_desc 
FROM sys.database_permissions perm
JOIN sys.database_principals prin ON perm.grantee_principal_id = prin.principal_id
JOIN sys.objects obj ON perm.major_id = obj.object_id
WHERE 
	   (prin.name = 'MyName' AND obj.name = 'sp_send_dbmail')
ORDER BY prin.name, permission_name, obj.name


-- 4. Query for VIEW SERVER STATE
USE MyDB
SELECT prin.Name as ServerPrincipal, perm.permission_name as Permission, perm.state_desc 
FROM sys.server_principals prin
JOIN sys.server_permissions perm ON prin.principal_id = perm.grantee_principal_id
WHERE 
	   (prin.Name = N'MyName' AND perm.permission_name = N'VIEW SERVER STATE')


-- 5. Query for IMPERSONATE
USE MyDB
SELECT prin2.Name as Grantor, perm.permission_name as Permission, prin.Name as Grantee, perm.state_desc
FROM sys.server_principals prin
JOIN sys.server_permissions perm ON prin.principal_id = perm.grantee_principal_id
JOIN sys.server_principals prin2 ON perm.grantor_principal_id = prin2.principal_id
WHERE 
	   (prin.Name = N'MyName' AND perm.permission_name = N'IMPERSONATE')

