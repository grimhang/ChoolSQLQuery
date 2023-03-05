use master  -- skip this for Azure 
go

IF OBJECT_ID('SP_HELPINDEX2') IS NULL
	EXEC ('CREATE PROC SP_HELPINDEX2 AS SELECT 1 ')
GO

ALTER PROCEDURE SP_HELPINDEX2 @NAME NVARCHAR(4000) = ''
/**************************************************************
-- Title        : SP_HELPINDEX2    sp_helpindex에 추가정보
-- Author       : 박성출
-- Create date  : 2022-03-25
-- Description  : 나만의 버전
    
        DATE         	Developer       Change
        ----------   	--------------- --------------------------
        2022-03-25      박성출         	처음 작성
        2023-03-05      박성출          azure에서는 use master 사용안하도록 안내
        2023-03-06      박성출          텍스트모드에서 컬럼명에 해당하는 대시줄이 무한정 길어지는 문제 해결
                                        [2023-03-06 여기해결] <-- 이 키워드로 검색
                                

        exec sp_helpindex2 Mytable                       -- 스키마가 dbo인 테이블
        exec sp_helpindex2 ezmes.Mytable2				 -- 스키마가 ezmes인 테이블

**************************************************************/
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--DECLARE @NAME NVARCHAR(4000) = ' ezmes.BOX '
	--DECLARE @NAME NVARCHAR(4000) = 'DBSERVER '

	DECLARE @Comma int, @schem_name NVARCHAR(100), @table_name NVARCHAR(500), @inputString NVARCHAR(1000);
	DECLARE @schema_id int, @inputStringLen int

	SET @inputString = RTRIM(LTRIM(@NAME))
	SET @inputStringLen = LEN(@inputString)
	SET @Comma = CHARINDEX('.', @inputString)

	-- select @Comma

	IF @Comma > 0
	BEGIN
		SET @schem_name = LEFT(@inputString, @Comma -1)
		SET @table_name = RIGHT(@inputString, @inputStringLen - @Comma)
		SET @schema_id = (SELECT schema_id FROM sys.schemas WHERE name = @schem_name)

		--SET @schema_id = ISNULL(@schema_id, 1) -- 기본값 1 (DBO)
	END
	ELSE
	BEGIN
		SET @schema_id = 1	-- dbo
		SET @schem_name = 'dbo'
		SET @table_name = @inputString
	END


	SELECT 
		-- ISNULL(PS.TYPE_DESC, 'NORMAL') AS ISPTN
		-- ,PS.NAME AS PTNFUNCNAME
		-- ,D.PARTITIONCNT AS PTNCNT,
		--T1.TYPE_DESC
		--, FI.NAME AS FGNAME
		SCHEMA_NAME(SCHEMA_ID) AS SchemaName
		,T1.CREATE_DATE AS TBL_CreateDate
		,T1.NAME AS TableName
		,I.TYPE_DESC IndexType
		,I.NAME AS IndexName
		, STAT1.Index_id AS IndexId	
		,INDEXSIZEKB AS IndexSizeKB
		,LEFT(CAST(SUBSTRING(B.INDEX_COLUMN_DESC, 3, 1000) AS NVARCHAR(500)), 500) AS IndexColumn       -- [2023-03-06 여기해결] XML결과값은 텍스트모드에서 무한정 길어지는 문제 해결
		,LEFT(CAST(SUBSTRING(C.INCLUDE_COLUMN_DESC, 3, 1000) AS NVARCHAR(500)), 500) AS IncludeColumn
		,STATS_DATE(i.object_id, i.index_id) AS [STATISTICUPDATEDATE]
		,I.IS_UNIQUE
		,I.IS_UNIQUE_CONSTRAINT
		,I.IS_PRIMARY_KEY
		,I.HAS_FILTER
		,LEFT(CAST(I.FILTER_DEFINITION AS NVARCHAR(500)), 500) AS FILTER_DEFINITION
		,I.IS_DISABLED
		,STAT1.*
		--,STAT2.*
	--,STAT3.*
	--	, * 
	FROM SYS.OBJECTS AS T1
		JOIN SYS.INDEXES            AS I    ON T1.[OBJECT_ID] = I.[OBJECT_ID]
		LEFT JOIN SYS.FILEGROUPS    AS FI   ON I.DATA_SPACE_ID = FI.DATA_SPACE_ID
	--    AND I.[TYPE] IN (0,1) 
		LEFT JOIN SYS.PARTITION_SCHEMES PS  ON I.DATA_SPACE_ID = PS.DATA_SPACE_ID
		OUTER APPLY
		(
			SELECT TOP 100 PERCENT ', ' + AC.NAME +
													CASE 
														WHEN IS_DESCENDING_KEY = 1
															THEN ' DESC'
														ELSE ' ASC'
													END AS [text()]
			FROM SYS.INDEX_COLUMNS IC
				JOIN SYS.ALL_COLUMNS AC     ON IC.OBJECT_ID = AC.OBJECT_ID AND IC.COLUMN_ID = AC.COLUMN_ID
			WHERE IC.OBJECT_ID = I.OBJECT_ID
				AND IC.INDEX_ID = I.INDEX_ID
				AND IC.IS_INCLUDED_COLUMN = 0
			ORDER BY IC.INDEX_COLUMN_ID
			FOR XML PATH('')
		) B (INDEX_COLUMN_DESC)
		OUTER APPLY
		(
			SELECT TOP 100 PERCENT ', ' + AC.NAME AS [text()]
			FROM SYS.INDEX_COLUMNS IC
				JOIN SYS.ALL_COLUMNS AC     ON IC.OBJECT_ID = AC.OBJECT_ID AND IC.COLUMN_ID = AC.COLUMN_ID
			WHERE IC.OBJECT_ID = I.OBJECT_ID
				AND IC.INDEX_ID = I.INDEX_ID
				AND IC.IS_INCLUDED_COLUMN = 1
			ORDER BY IC.INDEX_COLUMN_ID
			FOR XML PATH('')
		) C(INCLUDE_COLUMN_DESC)
		OUTER APPLY
		(
			SELECT COUNT(*)
			FROM SYS.TABLES AS T
				JOIN SYS.INDEXES                AS I    ON T.OBJECT_ID = I.OBJECT_ID
				JOIN SYS.PARTITIONS             AS P    ON I.OBJECT_ID = P.OBJECT_ID AND I.INDEX_ID = P.INDEX_ID
				JOIN SYS.PARTITION_SCHEMES      AS S    ON I.DATA_SPACE_ID = S.DATA_SPACE_ID
				JOIN SYS.PARTITION_FUNCTIONS    AS F    ON S.FUNCTION_ID = F.FUNCTION_ID
				JOIN SYS.PARTITION_RANGE_VALUES AS R    ON F.FUNCTION_ID = R.FUNCTION_ID AND R.BOUNDARY_ID = P.PARTITION_NUMBER
			WHERE T.NAME = T1.NAME
				AND I.TYPE <= 1
		) D(PARTITIONCNT)
		OUTER APPLY
		(
			SELECT 8 * SUM(A.USED_PAGES)  AS 'INDEXSIZE(KB)'
			FROM SYS.INDEXES                    AS III
				JOIN SYS.PARTITIONS             AS P    ON P.OBJECT_ID = III.OBJECT_ID AND P.INDEX_ID = I.INDEX_ID
				JOIN SYS.ALLOCATION_UNITS       AS A    ON A.CONTAINER_ID = P.PARTITION_ID
			WHERE III.OBJECT_ID = T1.OBJECT_ID
				AND III.INDEX_ID = I.INDEX_ID
		) E(INDEXSIZEKB)
		--OUTER APPLY
		--(
			--SELECT TOP 1 *
			--FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS(DB_ID(), T1.OBJECT_ID, I.INDEX_ID, NULL)
			--WHERE 1 =   CASE 
						 --WHEN T1.TYPE_DESC = 'SQL_TABLE_VALUED_FUNCTION'
						 --       THEN 0
							--ELSE 1
						--END
	--a	) STAT2
		OUTER APPLY
		(
			SELECT TOP 1 *
			FROM SYS.DM_DB_INDEX_USAGE_STATS
			WHERE OBJECT_ID = T1.OBJECT_ID
				AND INDEX_ID = I.INDEX_ID
				AND DATABASE_ID = DB_ID()
		) STAT1
	--OUTER APPLY (
	--	SELECT TOP 1 *
	--	FROM SYS.dm_db_index_physical_stats(DB_ID(), T1.OBJECT_ID, I.INDEX_ID, NULL, NULL)
	--	) STAT3
	WHERE IS_MS_SHIPPED = 0
		AND T1.NAME =  @table_name
		AND T1.schema_id = ISNULL(@schema_id, 1)
	ORDER BY 1, 2, 3, 4, 5, 6, 7, I.INDEX_ID
END
GO

EXEC sys.sp_MS_marksystemobject 
     'sp_helpindex2'; -- skip this for Azure 
GO 
