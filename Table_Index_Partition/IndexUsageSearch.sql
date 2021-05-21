SELECT DB.name AS DBName
    , IU.database_id, IU.[object_id], Object_Name(IU.object_id) TableName, IU.index_id AS IndexID,  IsNull(I.name, 'HEAP') as IndexName
    , IU.user_seeks, IU.user_scans, IU.user_lookups  
    ,   CASE
            WHEN (IU.index_id = 0 OR IU.index_id = 1) AND user_seeks < user_lookups THEN 'clu'
            ELSE '' 
        END AS Cluster      -- 클러스터형 인덱스   
    ,   CASE
            WHEN IU.index_id > 1 AND user_seeks > user_lookups THEN 'non'
            ELSE ''
        END AS NonCluster-- 비클러스터형 인덱스    
    ,   CASE
            WHEN (IU.index_id = 0 OR IU.index_id = 1) AND user_seeks < user_lookups THEN 'Y'
            WHEN IU.index_id > 1 AND user_seeks > user_lookups                      THEN 'Y'
            ELSE 'N' 
        END ClusterFlag  -- 클러스터/비클러스터형 확인
    , INDEXSIZEKB
FROM sys.dm_db_index_usage_stats IU
    JOIN sys.databases DB           ON IU.database_id = DB.database_id
    LEFT JOIN sys.indexes I         ON IU.object_id = I.object_id AND IU.index_id = I.index_id
    OUTER APPLY
    (
	    SELECT 8 * SUM(A.USED_PAGES) AS 'INDEXSIZE(KB)'
	    FROM SYS.INDEXES AS III
	        JOIN SYS.PARTITIONS AS P            ON P.OBJECT_ID = III.OBJECT_ID AND P.INDEX_ID = I.INDEX_ID
	        JOIN SYS.ALLOCATION_UNITS AS A      ON A.CONTAINER_ID = P.PARTITION_ID
	    WHERE III.OBJECT_ID = I.OBJECT_ID AND III.INDEX_ID = I.INDEX_ID
	) E(INDEXSIZEKB)
WHERE DB.database_id = db_id()
ORDER BY TableName, IU.index_id
