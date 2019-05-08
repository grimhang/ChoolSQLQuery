/*
select *
from opendatasource('SQLNCLI', 'Data Source=ELRNGDB2;Integrated Security=SSPI').master.dbo.sysobjects

select *
from sys.configurations
where name like '%quer%'
*/


-- 01. 연결된서버 만들기
DECLARE @LocalServerName NVARCHAR(100)
	, @Counter INT
	, @sql NVARCHAR(1000)
SET @LocalServerName = CONVERT(NVARCHAR(100), SERVERPROPERTY('MachineName'))

SELECT ROW_NUMBER() OVER(ORDER BY node_name) Seq, node_name
	INTO #TempTable
FROM sys.dm_hadr_availability_replica_cluster_nodes
WHERE node_name <> @LocalServerName

SET @Counter = 1
WHILE (1=1)
BEGIN
	SELECT @sql = 'EXEC sp_addlinkedserver @server = ''LNK_' + node_name + ''', @srvproduct=N''SQL Server'', @datasrc = ''' + node_name + ''', @catalog = ''msdb'''
	FROM #TempTable
	WHERE Seq = @Counter

	PRINT @sql
	--EXEC (@sql)

	SELECT @sql = 'EXEC sp_addlinkedsrvlogin @rmtsrvname = N''LNK_' + node_name + ''', @locallogin = NULL , @useself = N''True'''
	FROM #TempTable
	WHERE Seq = @Counter

	PRINT @sql
	--EXEC (@sql)

	SET @Counter = @Counter + 1

	IF NOT EXISTS (SELECT 1 FROM #TempTable	WHERE Seq = @Counter)
		BREAK;
END

DROP TABLE #TempTable

-- 02. msdb에 tJobList 테이블 만들기
CREATE TABLE tJobList
(
	JobName nvarchar(200) not null
	, enabled tinyint not null
	, description nvarchar(1024) not null
	, JobCreateDTM datetime not null
)




select name JobName, enabled, description
from msdb.dbo.sysjobs
where category_id <> 3		-- 데이터베이스 유지관리 계획 제외
order by name




-- 01. 연결된 서버
EXEC sp_addlinkedserver @server = 'LNK_ELRNGPRDDB2',@srvproduct=N'SQL Server', @datasrc = 'ELRNGPRDDB2', @catalog = 'msdb'
EXEC sp_addlinkedsrvlogin @rmtsrvname = N'ELRNGPRDDB2', @locallogin = NULL , @useself = N'True'		--  로그인의 현재 보안 컨텍스트를 통해 연결



-- AG 데이터베이스
SELECT *
FROM sys.availability_databases_cluster


-- 리스너 정보
SELECT L.dns_name, L.port, L.ip_configuration_string_from_cluster
	, IP.ip_address, IP.network_subnet_ip, IP.state, IP.state_desc
FROM sys.availability_group_listeners L
	JOIN sys.availability_group_listener_ip_addresses IP		ON L.listener_id = IP.listener_id
ORDER BY ip_address DESC


-- 노드
select G.name AGName, G.automated_backup_preference_desc
	, S.replica_server_name
	, R.is_local, R.role, r.role_desc, r.operational_state_desc, r.recovery_health_desc, r.synchronization_health_desc
FROM sys.availability_groups G
	JOIN sys.dm_hadr_availability_replica_states R					ON R.group_id = G.group_id
	JOIN SYS.dm_hadr_availability_replica_cluster_states S			ON R.replica_id = S.replica_id
ORDER BY s.replica_server_name


select name
from sys.servers
where server_id = 0




USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'ELRNGPRDDB2', @srvproduct=N'SQL Server'

GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ELRNGPRDDB2', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'ELRNGPRDDB2', @locallogin = NULL , @useself = N'True'
GO
