-- 01.데이터베이스별 가장 오래된 백업 기록
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
		KORAIR_MP_SOLUTIONSYSTEM  2019-03-12 16:29:42.000
		KOREANAIR_CONFIG_KSOX     2019-03-12 16:30:06.000
		KOREANAIR_DATA_KSOX       2019-03-12 16:30:30.000
		LearningSpace5            2017-08-09 22:08:15.000
		MASTER                    2019-03-08 18:02:54.000
		model                     2019-03-12 16:36:33.000
		MP_SYS                    2019-03-12 16:37:02.000
		msdb                      2019-03-08 18:03:04.000
		SID8000                   2016-09-20 22:09:59.000
		SID8000_GUEST             2016-09-20 22:10:01.000
		SID8000AC                 2016-09-20 22:10:05.000
		sysutility_mdw            2019-03-12 16:41:04.000
	*/


-- 02. 1개 데이터베이스의 백업 기록
select database_name, backup_finish_date BackupTime,  user_name, machine_name
from  msdb..backupset
where database_name = 'SID8000'
order by backup_finish_date
	/*
		database_name  BackupTime               user_name            machine_name
		-------------  -----------------------  -------------------  ------------
		SID8000        2016-09-20 22:09:59.000  KALDC\sqladmin       KESQLDB2
		SID8000        2019-03-12 16:39:25.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-12 23:34:02.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-13 23:34:56.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-14 23:35:30.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-15 23:25:30.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-16 23:34:29.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-17 23:27:21.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-18 23:35:06.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-19 23:37:06.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-20 23:34:51.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-21 23:26:06.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-22 23:38:34.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-23 23:28:57.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-24 23:36:57.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-25 23:36:39.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-26 23:35:13.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-27 23:36:52.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-28 23:37:22.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-29 23:45:50.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-30 23:39:56.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-03-31 23:41:57.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-01 23:40:43.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-02 23:40:13.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-03 23:38:52.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-04 23:41:19.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-05 23:37:41.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-06 23:41:17.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-07 23:26:22.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
		SID8000        2019-04-08 23:38:44.000  KESQLDEVDB\xdbabkup  KESQLDEVDB
	*/


-- 03. 모든 데이터베이스의 올해 백업 기록만 남기기
exec msdb..sp_delete_backuphistory '2019-01-01'


-- 04.데이터베이스 백업 기록 다시 확인
select S.database_name, min(S.backup_finish_date) backup_finish_date
from msdb..backupfile F
	join msdb..backupset S		on F.backup_set_id = S.backup_set_id
group by S.database_name
order by S.database_name
	/*
		database_name             backup_finish_date
		------------------------  -----------------------
		APPSDEV                   2019-03-12 15:59:29.000
		KAL_LMS                   2019-03-12 16:29:14.000
		KORAIR_MP_SOLUTIONSYSTEM  2019-03-12 16:29:42.000
		KOREANAIR_CONFIG_KSOX     2019-03-12 16:30:06.000
		KOREANAIR_DATA_KSOX       2019-03-12 16:30:30.000
		LearningSpace5            2019-03-12 16:35:35.000
		MASTER                    2019-03-08 18:02:54.000
		model                     2019-03-12 16:36:33.000
		MP_SYS                    2019-03-12 16:37:02.000
		msdb                      2019-03-08 18:03:04.000
		SID8000                   2019-03-12 16:39:25.000    <- 올해백업 기록만 남은걸 확인
		SID8000_GUEST             2019-03-12 16:39:58.000
		SID8000AC                 2019-03-12 16:40:46.000
		sysutility_mdw            2019-03-12 16:41:04.000
	*/


-- sp_delete_database_backuphistory