use master
go

IF OBJECT_ID('sp_who_chool') IS NULL
    EXEC ('CREATE PROC sp_who_chool AS SELECT 1')
GO

ALTER  PROC dbo.sp_who_chool @status varchar(100) = 'all', @IncludeLocalYN CHAR(1) = 'Y', @TYPE TINYINT = 1, @DbName VARCHAR(50) = 'master'

/**************************************************************
-- Title        : sp_who2의 커스텀 버전 V1
-- Author     : 박성출
-- Create date  : 2019-09-08
-- Alter date   : 2022-03-25
-- Description  : 나만의 버전
    
        DATE        Developer    	Change
        ----------  --------------- --------------------------
        2019-09-08	박성출          처음 작성
        2019-12-18  박성출          client_net_address 에서 <local machine> 제외로직 case문으로 변경
        2023-09-12  박성출          특정데이터베이스만 선택할수 있도록
        2023-09-13  박성출          모든 세션보기를 default값으로 변경. active 세션은 option으로
                                    ClientApp을 case와 replace를 같이 씀
                                    Client HostName 추가

        exec sp_who_chool                             	-- default(all sesseion)
        exec sp_who_chool 'active'                      -- active sesseion
        exec sp_who_chool @IncludeLocalYN = 'N'         -- without local session
        exec sp_who_chool 'all', 'N'                    -- all session, not local
        exec sp_who_chool null, 'N'
        exec sp_who_chool @status = 'all', @DbName = 'MyDBName'
**************************************************************/

AS
BEGIN
    DECLARE @statusVar varchar(100) 
    SET @statusVar = @status

    IF @TYPE = 1
    BEGIN

        SELECT C.session_id
            , P.open_tran
            , P.blocked
            , RTRIM(P.loginame) AS LoginName
            , DB_Name(P.dbid) DBName
            --, P.net_address MAC -- 정확치 않음. 확인요망
            --, rtrim(P.hostname) HostName
            --, ISNULL(CL.HostName, RTRIM(P.hostname)) as Hostname
            , p.cpu AS CPU
            , P.physical_io AS DiskIO
            --, CL.UserName
            --, cl.ClientIP
            , P.hostname AS ClientHostName
            , C.client_net_address AS ClientIP
            --, CL.ClientMac    
            , P.net_address ClientMac -- 정확치 않음. 확인요망
            , RTRIM(
                CASE
                    WHEN P.program_name LIKE 'Microsoft SQL Server Management Studio%' THEN REPLACE(P.program_name, 'Microsoft SQL Server Management Studio', 'SSMS') --'SSMS'
                    --WHEN P.program_name LIKE 'SQLAgent%' THEN REPLACE(P.program_name, 'Microsoft SQL Server Management Studio', 'SSMS') --'SQL Agent'
                    WHEN P.program_name LIKE 'Microsoft JDBC Driver for SQL Server%' THEN REPLACE(P.program_name, 'Microsoft JDBC Driver for SQL Server', 'MS JDBC Driver') -- 'MS JDBC'
                    ELSE P.program_name
                END) AS ClientApp
            , C.net_transport AS ClientProtocol
            --, CONVERT(varchar(19), C.connect_time, 121 ) ConnTime
            , CONVERT(varchar(19), P.last_batch, 121 ) LastBatchTime
            --,  rtrim(P.lastwaittype) LastWaitType
            , RTRIM(P.status) Status
            , P.cmd    
        FROM sys.dm_exec_connections AS C
            JOIN sys.sysprocesses AS P                        ON C.session_id = P.spid
            -- LEFT join master..TClientConnection AS CL       ON CL.ClientIP = C.client_net_address
        WHERE 1 = 1
            AND (
                    (
                        CASE WHEN @IncludeLocalYN = 'Y' THEN 'a' ELSE C.client_net_address END
                        <>
                        CASE WHEN @IncludeLocalYN = 'Y' THEN 'b' ELSE '<local machine>' END
                    )
                )
            AND (
                    (
                        CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)    ELSE 'a' END
                        =
                        CASE WHEN @statusVar = 'active' THEN 'runnable'         ELSE 'a' END
                    )
                    --OR    2023-09-13 왜 이거 있는지 이해 못해서 일단 주석 처리
                    --(
                    --    CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)    ELSE 'a' END
                    --    =
                    --    CASE WHEN @statusVar = 'active' THEN 'suspended'        ELSE 'a' END
                    --)
                )
            AND (                    
                    CASE WHEN @DbName <> 'master'        THEN DB_NAME(P.dbid)    ELSE 'a' END
                    =
                    CASE WHEN @DbName <> 'master'        THEN @DbName            ELSE 'a' END
                )
        ORDER BY C.session_id

    END
END


EXEC sys.sp_MS_marksystemobject
    'sp_who_chool';   -- skip this for Azure
GO    
