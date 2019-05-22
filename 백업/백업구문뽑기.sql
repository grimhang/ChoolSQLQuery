select name, 'backup database [' + name + '] to disk=''E:\SQL_DB_BACKUP\' + name + '_Full_' + convert(varchar(50), getdate(), 112) + '_0900.bak'' with stats=1' as SQLs
from sys.databases
where name not in ('master', 'tempdb', 'model', 'msdb')

/*
backup database [BM_PORTAL_DATA] to disk='E:\SQL_DB_BACKUP\BM_PORTAL_DATA_Full_20190327_0900.bak' with stats=1
backup database [BM_RMGT_DATA] to disk='E:\SQL_DB_BACKUP\BM_RMGT_DATA_Full_20190327_0900.bak' with stats=1
backup database [BM_WEBUI_DATA] to disk='E:\SQL_DB_BACKUP\BM_WEBUI_DATA_Full_20190327_0900.bak' with stats=1
backup database [IM_DATA] to disk='E:\SQL_DB_BACKUP\IM_DATA_Full_20190327_0900.bak' with stats=1
backup database [IM_PORTAL_DATA] to disk='E:\SQL_DB_BACKUP\IM_PORTAL_DATA_Full_20190327_0900.bak' with stats=1
backup database [IM_WEBUI_DATA] to disk='E:\SQL_DB_BACKUP\IM_WEBUI_DATA_Full_20190327_0900.bak' with stats=1
backup database [PM_DATA_01] to disk='E:\SQL_DB_BACKUP\PM_DATA_01_Full_20190327_0900.bak' with stats=1
backup database [PM_PORTAL_DATA_01] to disk='E:\SQL_DB_BACKUP\PM_PORTAL_DATA_01_Full_20190327_0900.bak' with stats=1
backup database [SDM_DATA] to disk='E:\SQL_DB_BACKUP\SDM_DATA_Full_20190327_0900.bak' with stats=1
*/