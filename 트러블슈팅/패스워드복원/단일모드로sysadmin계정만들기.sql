1. sql 서버 구성관리자에서 시작매개변수에 ;-m 을 추가해 단일 사용자모드로 만들기
net stop SQLAgent$KESQLDEVDB		OR net stop SQLSERVERAGENT
net stop MSSQL$KESQLDEVDB			OR net stop MSSQLSERVER

net start MSSQL$KESQLDEVDB /m
net stop MSSQL$KESQLDEVDB /m

net start MSSQL$KESQLDEVDB
net start SQLAgent$KESQLDEVDB

	참고
	https://docs.microsoft.com/ko-kr/sql/database-engine/configure-windows/start-sql-server-in-single-user-mode?view=sql-server-2017
	클러스터 서비스에서 단일사용자 모드로 시작 참고


2. ssms로 접속해 다음 쿼리 실행
주의: 다른 사용자가 이미 접속해 있다고 하면 sqlserver 재시작 하고 빨리 접속
sqlagent가 있다면 미리 중지해 놓자. 얘가 먼저 접속할수도

select * from syslogins

-- sql전용계정 추가
USE [master]
GO
CREATE LOGIN chooladmin with password = 'Hotgood3$$', DEFAULT_DATABASE=[master]
GO
EXEC master..sp_addsrvrolemember @loginame = N'chooladmin', @rolename = N'sysadmin'
GO


-- nt계정 추가
USE [master]
GO
CREATE LOGIN [KALDC\dco3user] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
EXEC master..sp_addsrvrolemember @loginame = N'KALDC\dco3user', @rolename = N'sysadmin'
GO


select name from syslogins ORDER BY name