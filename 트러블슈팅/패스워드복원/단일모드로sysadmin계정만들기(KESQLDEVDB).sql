1. MS-SQL 중지
net stop SQLAgent$KESQLDEVDB
net stop MSSQL$KESQLDEVDB

2. 단일 사용자모드로 만들기(임시로 하기 때문에 명령줄로 시행)
net start MSSQL$KESQLDEVDB /m

3. ssms로 접속해 다음 쿼리 실행
주의: 다른 사용자가 이미 접속해 있다고 하면 sqlserver 재시작 하고 빨리 접속
sqlagent가 있다면 미리 중지해 놓자. 얘가 먼저 접속할수도
    -- sql전용계정 추가
    USE [master]
    GO
    CREATE LOGIN [KESQLDEVDB\xadmuser] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
    GO
    ALTER SERVER ROLE [sysadmin] ADD MEMBER [KESQLDEVDB\xadmuser]
    GO

4. 최종 정상모드로 MS-SQL 시작
net start MSSQL$KESQLDEVDB
net start SQLAgent$KESQLDEVDB
