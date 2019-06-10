select name, 'backup database [' + name + '] to disk=''E:\SQL_DB_BACKUP\' + name + '_Full_' + convert(varchar(50), getdate(), 112) + '_0900.bak'' with stats=1' as SQLs
from sys.databases
where name not in ('master', 'tempdb', 'model', 'msdb')

/*
backup database [BM_PORTAL_DATA] to disk='E:\SQL_DB_BACKUP\BM_PORTAL_DATA_Full_20190327_0900.bak' with stats=1
*/