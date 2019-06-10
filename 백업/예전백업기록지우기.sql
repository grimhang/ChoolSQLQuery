-- 01.�����ͺ��̽��� ���� ������ ��� ���
select S.database_name, min(S.backup_finish_date) backup_finish_date
from msdb..backupfile F
	join msdb..backupset S		on F.backup_set_id = S.backup_set_id
group by S.database_name
order by S.database_name
	/*
		database_name             backup_finish_date
		------------------------  -----------------------
		APPSDEV                   2019-03-12 15:59:29.000
		KAL_LMS                   2016-08-04 22:10:24.000
	*/


-- 02. 1�� �����ͺ��̽��� ��� ���
select database_name, backup_finish_date BackupTime,  user_name, machine_name
from  msdb..backupset
where database_name = 'SID8000'
order by backup_finish_date


-- 03. ��� �����ͺ��̽��� ���� ��� ��ϸ� �����
exec msdb..sp_delete_backuphistory '2019-01-01'


-- 04.�����ͺ��̽� ��� ��� �ٽ� Ȯ��
select S.database_name, min(S.backup_finish_date) backup_finish_date
from msdb..backupfile F
	join msdb..backupset S		on F.backup_set_id = S.backup_set_id
group by S.database_name
order by S.database_name


-- sp_delete_database_backuphistory