SELECT   
    T.[object_id] AS ObjectID   
    , T.name AS TableName   
    , IC.column_id AS PartitioningColumnID   
    , C.name AS PartitioningColumnName   
FROM sys.tables     AS T
    JOIN sys.indexes                AS I    ON T.[object_id] = I.[object_id]   
                                                AND I.[type] <= 1 -- clustered index or a heap   
    JOIN sys.partition_schemes      AS PS   ON PS.data_space_id = I.data_space_id   
    JOIN sys.index_columns          AS IC   ON IC.[object_id] = I.[object_id]   
                                                AND IC.index_id = I.index_id   
                                                AND IC.partition_ordinal >= 1 -- because 0 = non-partitioning column   
    JOIN sys.columns                AS C    ON T.[object_id] = C.[object_id] AND IC.column_id = C.column_id   
WHERE T.name = 'TABLE_NAME' ;   
GO  
