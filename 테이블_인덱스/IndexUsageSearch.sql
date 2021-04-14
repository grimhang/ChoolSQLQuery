SELECT db.name as database_name,
    iu.database_id, iu.object_id, Object_Name(iu.object_id) TableName, iu.index_id, IsNull(i.name, 'HEAP') as IndexName
    , user_seeks, user_scans, user_lookups  
    -- 클러스터형 인덱스
     , cluster = case when (iu.index_id = 0 OR iu.index_id = 1) AND user_seeks < user_lookups then 'clu' else '' end
    -- 비클러스터형 인덱스
    , nonCluster = case when iu.index_id > 1 AND user_seeks > user_lookups then 'non' else '' end
    -- 클러스터/비클러스터형 확인
    , case
        when (iu.index_id = 0 OR iu.index_id = 1) AND user_seeks < user_lookups then 'Y'
        when iu.index_id > 1 AND user_seeks > user_lookups then 'Y' else 'N' 
      end ClusterFlag

FROM [sys].[dm_db_index_usage_stats] iu
    Inner Join [sys].[databases] db on iu.database_id = db.database_id
    Left Join [sys].[indexes] i on iu.object_id = i.object_id AND iu.index_id = i.index_id
WHERE db.database_id = db_id()
ORDER BY TableName, iu.index_id
