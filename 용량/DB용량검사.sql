-- DB용량
SELECT 
    D.database_id 'Database ID'
    , D.name AS 'DBName'
    , Max(D.collation_name)			AS 'Collation'
    , Max(D.compatibility_level)	AS 'Compatibility'
    , Max(D.user_access_desc)		AS 'User Access'
    , Max(D.state_desc)				AS 'Status'
    , Max(D.recovery_model_desc)	AS 'Recovery Model'
    , MAX(SUSER_SNAME(D.owner_sid))   AS DBOwnerName
    , SUM(CASE WHEN F.type_desc ='ROWS' THEN CAST(F.size AS BIGINT) ELSE 0 END) * 8/ 1024	AS TotalDataDiskSpace_MB
    , SUM(CASE WHEN F.type_desc ='LOG' THEN CAST(F.size AS BIGINT) ELSE 0 END) * 8 / 1024 	AS TotalLogDiskSpace_MB
FROM SYS.DATABASES D
    JOIN sys.master_files F					ON D.database_id= F.database_id
    LEFT JOIN
    (
        SELECT database_name, MAX(backup_finish_date) MY_DATE
        FROM msdb.dbo.backupset
        WHERE 1=1
            --DATABASE_NAME ='TL_REPORT'
            AND type = 'D'	-- Data backup only
        GROUP BY database_name
    ) B			ON B.database_name = D.name 
WHERE D.name in ('XENAPPDB', 'XenDesktopDB01', 'XENMONDB')
    --AND D.DATABASE_ID = 9 AND type_desc ='ROWS'
GROUP BY D.database_id, D.[name]
ORDER BY D.[name]
GO


-- DB파일 위치
SELECT 
    D.database_id 'Database ID'
    , D.name AS 'DBName'
    , D.collation_name			AS 'Collation'
    , D.compatibility_level	AS 'Compatibility'
    , D.user_access_desc		AS 'User Access'
    , D.state_desc				AS 'Status'
    , D.recovery_model_desc	AS 'Recovery Model'
    , SUSER_SNAME(D.owner_sid)   AS DBOwnerName
    , f.physical_name
FROM SYS.DATABASES D
    JOIN sys.master_files F					ON D.database_id= F.database_id
WHERE D.name in ('XENAPPDB', 'XenDesktopDB01', 'XENMONDB')
    --AND D.DATABASE_ID = 9 AND type_desc ='ROWS'
ORDER BY D.[name]
GO


--로그파일 용량 검사
dbcc sqlperf(logspace)
