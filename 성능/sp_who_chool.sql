USE master

IF EXISTS(SELECT 1 FROM sys.tables WHERE NAME = 'TClientConnection') drop table TClientConnection
CREATE TABLE TClientConnection
(
    HostName nvarchar(100) not null
    --, UserID nvarchar(100) not null
    , UserName nvarchar(100) not null
    , ClientIP nvarchar(100) not null
    , ClientMac nvarchar(100) not null
    , CONSTRAINT PK_TClientConnection PRIMARY KEY CLUSTERED 
	(
	    HostName
	)
)

--IF EXISTS(SELECT 1 FROM sys.objects WHERE NAME = 'sp_who_chool') drop proc sp_who_chool
--GO

/*
    Author  : Sungchool Park
    Date    : 2019-10-25
    Desc    : alternative sp_who  and without background session(spid > 50)

    ex)
        exec sp_who_chool                        -- default(active sesseion)
        exec sp_who_chool 'all'                  -- all sesseion        
        exec sp_who_chool @IncludeLocalYN = 'N'  -- only not local session
        exec sp_who_chool 'all', 'N'             -- all session, not local
        exec sp_who_chool null, 'N'
*/
CREATE OR ALTER PROC dbo.sp_who_chool @status varchar(100) = 'active', @IncludeLocalYN CHAR(1) = 'Y', @TYPE TINYINT = 1
AS
BEGIN
    DECLARE @statusVar varchar(100) 

    SET @statusVar = @status
    --IF (lower(@status collate Latin1_General_CI_AS) IN ('active'))  --Special action, not sleeping.
    --    SET @statusVar = 'active'
    --ELSE
    --    SET @statusVar = ''

           --select @loginame = lower(@loginame collate Latin1_General_CI_AS)
           --GOTO LABEL_17PARM1EDITED
--    return 0

    IF @TYPE = 1
    BEGIN
        IF @IncludeLocalYN = 'Y'
        BEGIN
            SELECT C.session_id
                , P.open_tran
                , P.blocked
                , RTRIM(P.loginame) AS LoginName
                , DB_Name(P.dbid) DBName
                --, P.net_address MAC -- 정확치 않음. 확인요망
                --, rtrim(P.hostname) HostName
                , ISNULL(CL.HostName, RTRIM(P.hostname)) as Hostname
                , p.cpu AS CPU
                , P.physical_io AS DiskIO
                , CL.UserName
                --, cl.ClientIP
                , C.client_net_address
                , CL.ClientMac    
                , RTRIM(
                    CASE
                        WHEN P.program_name LIKE 'Microsoft SQL Server Management Studio%' THEN 'SSMS'
                        WHEN P.program_name LIKE 'SQLAgent%' THEN 'SQL Agent'
                        WHEN P.program_name LIKE 'Microsoft JDBC Driver for SQL Server%' THEN 'MS JDBC'
                        ELSE P.program_name
                    END) AS ClientApp
                , C.net_transport AS ClientProtocol
                , CONVERT(varchar(19), C.connect_time, 121 ) ConnTime
                --,  rtrim(P.lastwaittype) LastWaitType
                , RTRIM(P.status) Status
                , P.cmd    
            FROM sys.dm_exec_connections AS C
                JOIN sys.sysprocesses AS P                        ON C.session_id = P.spid
                LEFT join master..TClientConnection AS CL       ON CL.ClientIP = C.client_net_address
            WHERE 1 = 1
                --AND RTRIM(P.status) NOT IN ('sleeping')
                AND (
                        (
                            CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)                    ELSE 'a' END
                            =
                            CASE WHEN @statusVar = 'active' THEN 'runnable'                        ELSE 'a' END
                        )
                        OR 
                        (
                            CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)                    ELSE 'a' END
                            =
                            CASE WHEN @statusVar = 'active' THEN 'suspended'                        ELSE 'a' END
                        )
                    )
        END
        ELSE
        BEGIN
            SELECT C.session_id
                , P.open_tran
                , P.blocked
                , RTRIM(P.loginame) AS LoginName
                , DB_Name(P.dbid) DBName
                --, P.net_address MAC -- 정확치 않음. 확인요망
                --, rtrim(P.hostname) HostName
                , ISNULL(CL.HostName, RTRIM(P.hostname)) as Hostname
                , p.cpu AS CPU
                , P.physical_io AS DiskIO
                , CL.UserName
                --, cl.ClientIP
                , C.client_net_address
                , CL.ClientMac    
                , RTRIM(
                    CASE
                        WHEN P.program_name LIKE 'Microsoft SQL Server Management Studio%' THEN 'SSMS'
                        WHEN P.program_name LIKE 'SQLAgent%' THEN 'SQL Agent'
                        WHEN P.program_name LIKE 'Microsoft JDBC Driver for SQL Server%' THEN 'MS JDBC'
                        ELSE P.program_name
                    END) AS ClientApp
                , C.net_transport AS ClientProtocol
                , CONVERT(varchar(19), C.connect_time, 121 ) ConnTime
                --,  rtrim(P.lastwaittype) LastWaitType
                , RTRIM(P.status) Status
                , P.cmd    
            FROM sys.dm_exec_connections AS C
                JOIN sys.sysprocesses AS P                        ON C.session_id = P.spid
                LEFT join master..TClientConnection AS CL       ON CL.ClientIP = C.client_net_address
            WHERE 1 = 1
                AND C.client_net_address NOT IN ('<local machine>')
                --AND RTRIM(P.status) NOT IN ('sleeping')
                AND (
                        (
                            CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)                    ELSE 'b' END
                            =
                            CASE WHEN @statusVar = 'active' THEN 'runnable'                        ELSE 'b' END
                        )
                        OR 
                        (
                            CASE WHEN @statusVar = 'active' THEN RTRIM(P.status)                    ELSE 'b' END
                            =
                            CASE WHEN @statusVar = 'active' THEN 'suspended'                        ELSE 'b' END
                        )
                    )
        END
    END
END