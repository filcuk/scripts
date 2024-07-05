-- Source: https://stackoverflow.com/a/26399985
-- Author: https://stackoverflow.com/users/2739334/pwnstar

SELECT *
FROM (
    SELECT PERM.permission_name AS 'PERMISSION'
        ,PERM.state_desc AS 'RIGHT'
        ,PERM.class_desc AS 'RIGHT_ON'
        ,p.NAME AS 'GRANTEE'
        ,m.NAME AS 'USERNAME'
        ,s.name AS 'SCHEMA'
        ,o.name AS 'OBJECT'
        ,IIF(PERM.class = 0, db_name(), NULL) AS 'DATABASE'
    FROM sys.database_permissions PERM
    INNER JOIN sys.database_principals p
        ON p.principal_id = PERM.grantee_principal_id
    LEFT JOIN sys.database_role_members rm
        ON rm.role_principal_id = p.principal_id
    LEFT JOIN sys.database_principals m
        ON rm.member_principal_id = m.principal_id
    LEFT JOIN sys.schemas s
        ON PERM.class = 3
            AND PERM.major_id = s.schema_id
    LEFT JOIN sys.objects AS o
        ON PERM.class = 1
            AND PERM.major_id = o.object_id
    
    UNION ALL
    
    SELECT PERM.permission_name AS 'PERMISSION'
        ,PERM.state_desc AS 'RIGHT'
        ,PERM.class_desc AS 'RIGHT_ON'
        ,'SELF-GRANTED' AS 'GRANTEE'
        ,p.NAME AS 'USERNAME'
        ,s.name AS 'SCHEMA'
        ,o.name AS 'OBJECT'
        ,IIF(PERM.class = 0, db_name(), NULL) AS 'DATABASE'
    FROM sys.database_permissions PERM
    INNER JOIN sys.database_principals p
        ON p.principal_id = PERM.grantee_principal_id
    LEFT JOIN sys.schemas s
        ON PERM.class = 3
            AND PERM.major_id = s.schema_id
    LEFT JOIN sys.objects AS o
        ON PERM.class = 1
            AND PERM.major_id = o.object_id
    ) AS [union]
WHERE [union].USERNAME = 'username' -- Username you will search for
ORDER BY [union].RIGHT_ON
    ,[union].PERMISSION
    ,[union].GRANTEE
