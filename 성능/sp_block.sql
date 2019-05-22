CREATE PROCEDURE SP_BLOCK @BATCH CHAR(1) = NULL
AS
-- ***********************************************************************
-- This stored procedure is provided AS IS with no warranties and confers no rights.
-- ***********************************************************************
CREATE TABLE #DBCC (
	PARENTOBJECT NVARCHAR(128)
	,OBJECT NVARCHAR(128)
	,FIELD NVARCHAR(128)
	,VALUE NVARCHAR(128)
	)

DECLARE @BLOCKED TABLE (
	BLOCKER_SPID SMALLINT
	,BLOCKER_CONTEXT VARCHAR(128)
	,BLOCKER_STATUS VARCHAR(18)
	,BLOCKED_SPID SMALLINT
	,BLOCKED_CONTEXT VARCHAR(128)
	,WAITTIME INT
	,LOCK_MODE VARCHAR(7)
	,LOCK_TYPE CHAR(3)
	,DBID SMALLINT
	,LOCK_RESOURCE VARCHAR(30)
	,BLOCKER_SQL TEXT
	,BLOCKED_SQL TEXT
	)
DECLARE @BLOCKED2 TABLE (
	BLOCKER_SPID SMALLINT
	,BLOCKER_CONTEXT VARCHAR(128)
	,BLOCKER_STATUS VARCHAR(18)
	,BLOCKED_SPID SMALLINT
	,BLOCKED_CONTEXT VARCHAR(128)
	,WAITTIME INT
	,LOCK_MODE VARCHAR(7)
	,LOCK_TYPE CHAR(3)
	,DBNAME CHAR(8)
	,TABLENAME CHAR(18)
	,INDEXID INT
	,BLOCKER_SQL TEXT
	,BLOCKED_SQL TEXT
	)

SET NOCOUNT ON

DECLARE @BLOCKER_SPID SMALLINT
	,@BLOCKER_CONTEXT VARCHAR(128)
	,@BLOCKER_STATUS VARCHAR(18)
	,@BLOCKED_SPID SMALLINT
	,@BLOCKED_CONTEXT VARCHAR(128)
	,@WAITTIME INT
	,@LOCK_MODE VARCHAR(7)
	,@LOCK_TYPE CHAR(3)
	,@DBID SMALLINT
	,@OBJECTID INT
	,@INDEXID INT
	,@LOCK_RESOURCE VARCHAR(30)
	,@BLOCKER_HANDLE BINARY (20)
	,@BLOCKER_SQL VARCHAR(8000)
	,@BLOCKED_HANDLE BINARY (20)
	,@BLOCKED_SQL VARCHAR(8000)
	,@CMD VARCHAR(1000)
	,@DELIMITER1 TINYINT
	,@DELIMITER2 TINYINT
	,@DELIMITER3 TINYINT
	,@FILEID VARCHAR(10)
	,@PAGEID VARCHAR(10)

--	-------------------------------------------------------------------------------------
--	Populate temporary table #BLOCKED from sysindexes for blocked and blocking processes
--	-------------------------------------------------------------------------------------
DECLARE PROCESSES CURSOR
FOR
SELECT BLOCKER.spid
	,-- BLOCKER_SPID
	RTRIM(convert(VARCHAR(128), BLOCKER.context_info))
	,-- BLOCKER_CONTEXT
	CASE BLOCKER.blocked -- BLOCKER_STATUS
		WHEN 0
			THEN 'Lead Blocker'
		ELSE 'In Blocking Chain'
		END
	,BLOCKED.spid
	,-- BLOCKED_SPID
	RTRIM(convert(VARCHAR(128), BLOCKED.context_info))
	,-- BLOCKER_CONTEXT
	BLOCKED.waittime
	,-- BLOCKED_WAITTIME
	CASE CONVERT(TINYINT, BLOCKED.waittype) -- LOCK_MODE
		WHEN 1
			THEN 'SCH-ST'
		WHEN 2
			THEN 'SCH-MOD'
		WHEN 3
			THEN 'S'
		WHEN 4
			THEN 'U'
		WHEN 5
			THEN 'X'
		WHEN 6
			THEN 'IS'
		WHEN 7
			THEN 'IU'
		WHEN 8
			THEN 'IX'
		WHEN 9
			THEN 'SIU'
		WHEN 10
			THEN 'SIX'
		WHEN 11
			THEN 'UIX'
		WHEN 12
			THEN 'BU'
		WHEN 13
			THEN 'RangeS-S'
		WHEN 14
			THEN 'RangeS-U'
		WHEN 15
			THEN 'RangeIn-Null'
		WHEN 16
			THEN 'RangeIn-S'
		WHEN 17
			THEN 'RangeIn-U'
		WHEN 18
			THEN 'RangeIn-X'
		WHEN 19
			THEN 'RangeX-S'
		WHEN 20
			THEN 'RangeX-U'
		WHEN 21
			THEN 'RangeX-X'
		ELSE 'UNKNOWN'
		END
	,SUBSTRING(BLOCKED.waitresource, 1, 3)
	,-- LOCK_RESOURCE_TYPE
	BLOCKED.dbid
	,-- DBID
	SUBSTRING(BLOCKED.waitresource, 6, 30)
	,-- LOCK_RESOURCE
	BLOCKER.sql_handle
	,BLOCKER.cmd
	,BLOCKED.sql_handle
	,BLOCKED.cmd
FROM master..sysprocesses BLOCKER
INNER JOIN master..sysprocesses BLOCKED ON BLOCKER.spid = BLOCKED.blocked
WHERE BLOCKED.blocked <> 0
	AND BLOCKER.dbid = db_id()

OPEN PROCESSES

FETCH PROCESSES
INTO @BLOCKER_SPID
	,@BLOCKER_CONTEXT
	,@BLOCKER_STATUS
	,@BLOCKED_SPID
	,@BLOCKED_CONTEXT
	,@WAITTIME
	,@LOCK_MODE
	,@LOCK_TYPE
	,@DBID
	,@LOCK_RESOURCE
	,@BLOCKER_HANDLE
	,@BLOCKER_SQL
	,@BLOCKED_HANDLE
	,@BLOCKED_SQL

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @BLOCKED_HANDLE <> 0x0
		AND IS_SRVROLEMEMBER('sysadmin') = 1
		SELECT @BLOCKED_SQL = TEXT
		FROM::fn_get_sql(@BLOCKED_HANDLE)

	IF @BLOCKER_HANDLE <> 0x0
		AND IS_SRVROLEMEMBER('sysadmin') = 1
		SELECT @BLOCKER_SQL = TEXT
		FROM::fn_get_sql(@BLOCKER_HANDLE)

	INSERT INTO @BLOCKED
	VALUES (
		@BLOCKER_SPID
		,@BLOCKER_CONTEXT
		,@BLOCKER_STATUS
		,@BLOCKED_SPID
		,@BLOCKED_CONTEXT
		,@WAITTIME
		,@LOCK_MODE
		,@LOCK_TYPE
		,@DBID
		,@LOCK_RESOURCE
		,@BLOCKER_SQL
		,@BLOCKED_SQL
		)

	FETCH PROCESSES
	INTO @BLOCKER_SPID
		,@BLOCKER_CONTEXT
		,@BLOCKER_STATUS
		,@BLOCKED_SPID
		,@BLOCKED_CONTEXT
		,@WAITTIME
		,@LOCK_MODE
		,@LOCK_TYPE
		,@DBID
		,@LOCK_RESOURCE
		,@BLOCKER_HANDLE
		,@BLOCKER_SQL
		,@BLOCKED_HANDLE
		,@BLOCKED_SQL
END -- @@FETCH_STATUS = 0

DEALLOCATE PROCESSES

DECLARE BLOCKED CURSOR
FOR
SELECT BLOCKER_SPID
	,BLOCKER_CONTEXT
	,BLOCKER_STATUS
	,BLOCKED_SPID
	,BLOCKED_CONTEXT
	,WAITTIME
	,LOCK_MODE
	,LOCK_TYPE
	,DBID
	,LOCK_RESOURCE
	,BLOCKER_SQL
	,BLOCKED_SQL
FROM @BLOCKED

OPEN BLOCKED

FETCH BLOCKED
INTO @BLOCKER_SPID
	,@BLOCKER_CONTEXT
	,@BLOCKER_STATUS
	,@BLOCKED_SPID
	,@BLOCKED_CONTEXT
	,@WAITTIME
	,@LOCK_MODE
	,@LOCK_TYPE
	,@DBID
	,@LOCK_RESOURCE
	,@BLOCKER_SQL
	,@BLOCKED_SQL

WHILE @@FETCH_STATUS = 0
BEGIN
	--	-------------------------------------------------------------------------------------
	--	Decode the waitresource column from sysprocesses.
	--	The 1st 5 bytes have already been trimmed off and stored in LOCK_TYPE
	--	-------------------------------------------------------------------------------------
	--	Establish position of the delimiters between the fields of the lock
	--	resource. In order to establish a uniform delimiter to look for, replace ':' with ' '
	--	-------------------------------------------------------------------------------------
	SET @LOCK_RESOURCE = REPLACE(@LOCK_RESOURCE, ':', ' ')
	SET @DELIMITER1 = CHARINDEX(' ', @LOCK_RESOURCE)
	SET @DELIMITER2 = CHARINDEX(' ', @LOCK_RESOURCE, (@DELIMITER1 + 1))
	SET @DELIMITER3 = CHARINDEX(' ', @LOCK_RESOURCE, (@DELIMITER2 + 1))

	--	-------------------------------------------------------------------------------------
	--	Delimiter positions are then used to substring fields from @LOCK_RESOURCE
	--	-------------------------------------------------------------------------------------
	IF @LOCK_TYPE IN (
			'RID'
			,'PAG'
			)
	BEGIN
		--	-------------------------------------------------------------------------------------
		--	Extract objectid and indexid from file/page for resources of RID or PAG.
		--	LOCK_RESOURCE_TYPE 'RID':	dbid:fileid:pageid:row#
		--	Example:	7:3:47912:10
		--	LOCK_RESOURCE_TYPE 'PAG':	dbid:fileid:pageid
		--	Example:	7:3:47912
		--	-------------------------------------------------------------------------------------
		SET @FILEID = SUBSTRING(@LOCK_RESOURCE, @DELIMITER1 + 1, (@DELIMITER2 - @DELIMITER1) - 1)
		SET @PAGEID = SUBSTRING(@LOCK_RESOURCE, @DELIMITER2 + 1, (@DELIMITER3 - @DELIMITER2) - 1)
		--	-------------------------------------------------------------------------------------
		--	Execute DBCC PAGE to determine the object owner of the page. We use the rowset
		--	version of DBCC (WITH TABLERESULTS) to make it easy to retrieve objext id and index id.
		--	-------------------------------------------------------------------------------------
		SET @CMD = 'DBCC PAGE (' + CONVERT(VARCHAR(3), @DBID) + ',' + @FILEID + ',' + @PAGEID + ') WITH TABLERESULTS, no_infomsgs'

		INSERT INTO #DBCC
		EXEC (@CMD)

		SELECT @OBJECTID = CONVERT(INT, SUBSTRING(VALUE, 1, 30))
		FROM #DBCC
		WHERE FIELD = 'm_objId'
		OPTION (KEEP PLAN)

		SELECT @INDEXID = CONVERT(INT, SUBSTRING(VALUE, 1, 30))
		FROM #DBCC
		WHERE FIELD = 'm_indexId'
		OPTION (KEEP PLAN)

		TRUNCATE TABLE #DBCC
	END

	IF @LOCK_TYPE = 'TAB'
	BEGIN
		--	-------------------------------------------------------------------------------------
		--	LOCK_RESOURCE_TYPE 'TAB':	dbid:objectid
		--	Example:	7:1993058136
		--	-------------------------------------------------------------------------------------
		SET @OBJECTID = SUBSTRING(@LOCK_RESOURCE, @DELIMITER1 + 1, (@DELIMITER2 - @DELIMITER1) - 1)
		--	-------------------------------------------------------------------------------------
		--	For table locks, set indexid to '0'
		--	-------------------------------------------------------------------------------------
		SET @INDEXID = 0

		--	-------------------------------------------------------------------------------------
		--	If the waitresource contains the keyword COMPILE, then the object name is actually a
		--	stored procedure.
		--	Example:	6:834102 [[COMPILE]]
		--	-------------------------------------------------------------------------------------
		IF @LOCK_RESOURCE LIKE '%COMPILE%'
			SET @LOCK_TYPE = 'PRC'
	END

	IF @LOCK_TYPE = 'KEY'
	BEGIN
		--	-------------------------------------------------------------------------------------
		--	LOCK_RESOURCE_TYPE 'KEY':	dbid:objectid:indexid (hash of key value)
		--	Example:	7:1993058136:4 (0a0087c006b1)
		--	-------------------------------------------------------------------------------------
		SET @OBJECTID = SUBSTRING(@LOCK_RESOURCE, @DELIMITER1 + 1, (@DELIMITER2 - @DELIMITER1) - 1)
		SET @INDEXID = SUBSTRING(@LOCK_RESOURCE, @DELIMITER2 + 1, (@DELIMITER3 - @DELIMITER2) - 1)
	END

	--	-------------------------------------------------------------------------------------
	--	If executing in batch, write directly to SQLPERF..BLOCKED_PROCESSES
	--	-------------------------------------------------------------------------------------
	IF @BATCH IS NOT NULL
		INSERT INTO SQLPERF..BLOCKED_PROCESSES
		WITH (TABLOCKX)
		VALUES (
			GETDATE()
			,@BLOCKED_SPID
			,@BLOCKED_CONTEXT
			,@BLOCKER_SPID
			,@BLOCKER_CONTEXT
			,@BLOCKER_STATUS
			,@WAITTIME
			,LEFT(DB_NAME(@DBID), 8)
			,LEFT(OBJECT_NAME(@OBJECTID), 18)
			,@INDEXID
			,@LOCK_TYPE
			,@LOCK_MODE
			,@BLOCKER_SQL
			,@BLOCKED_SQL
			)
	ELSE
		--	-------------------------------------------------------------------------------------
		--	Otherwise, insert into temp table for subsequent OUTPUT
		--	-------------------------------------------------------------------------------------
		INSERT INTO @BLOCKED2
		VALUES (
			@BLOCKER_SPID
			,@BLOCKER_CONTEXT
			,@BLOCKER_STATUS
			,@BLOCKED_SPID
			,@BLOCKED_CONTEXT
			,@WAITTIME
			,@LOCK_MODE
			,@LOCK_TYPE
			,LEFT(DB_NAME(@DBID), 8)
			,LEFT(OBJECT_NAME(@OBJECTID), 18)
			,@INDEXID
			,@BLOCKER_SQL
			,@BLOCKED_SQL
			)

	FETCH BLOCKED
	INTO @BLOCKER_SPID
		,@BLOCKER_CONTEXT
		,@BLOCKER_STATUS
		,@BLOCKED_SPID
		,@BLOCKED_CONTEXT
		,@WAITTIME
		,@LOCK_MODE
		,@LOCK_TYPE
		,@DBID
		,@LOCK_RESOURCE
		,@BLOCKER_SQL
		,@BLOCKED_SQL
END -- WHILE @@FETCH_STATUS = 0

DEALLOCATE BLOCKED

--	-------------------------------------------------------------------------------------
--	Format output.
--	-------------------------------------------------------------------------------------
IF @BATCH IS NULL
	SELECT BLOCKED_DTTM = GETDATE()
		,BLOCKED_SPID
		,BLOCKED_CONTEXT
		,BLOCKER_SPID
		,BLOCKER_CONTEXT
		,BLOCKER_STATUS
		,WAITTIME AS [WAITING(ms)]
		,DBNAME
		,TABLENAME
		,INDEXID
		,LOCK_TYPE
		,LOCK_MODE
		,BLOCKER_SQL
		,BLOCKED_SQL
	FROM @BLOCKED2
	ORDER BY BLOCKER_STATUS DESC
		,[WAITING(ms)] DESC

RETURN
GO

