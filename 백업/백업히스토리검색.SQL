--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 
SELECT 
    CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server
    , S.database_name
    , S.backup_start_date
    , S.backup_finish_date
    , S.expiration_date
    , CASE S.type 
        WHEN 'D' THEN 'Database' 
        WHEN 'L' THEN 'Log' 
      END AS backup_type
    , S.backup_size
    , MF.logical_device_name
    , MF.physical_device_name
    , S.name AS backupset_name
    , S.description 
FROM msdb.dbo.backupmediafamily MF
    JOIN msdb.dbo.backupset S ON MF.media_set_id = S.media_set_id 
WHERE (CONVERT(datetime, S.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY 
S.database_name, 
S.backup_finish_date