SELECT T.name AS TableName, I.name AS IndexName, P.partition_number
    -- , P.partition_id, I.data_space_id, PF.function_id
    , PF.type_desc, R.boundary_id, PF.[type], R.value AS BoundaryValue   
    , P.rows PartitionRows
FROM sys.tables AS T  
    JOIN sys.indexes                        AS I        ON T.object_id = I.object_id  
    JOIN sys.partitions                     AS P        ON I.object_id = P.object_id AND I.index_id = P.index_id   
    JOIN sys.partition_schemes              AS PS       ON I.data_space_id = PS.data_space_id  
    JOIN sys.partition_functions            AS PF       ON PS.function_id = PF.function_id  
    LEFT JOIN sys.partition_range_values    AS R        ON PF.function_id = R.function_id and R.boundary_id = (P.partition_number -1)
WHERE T.name = 'TABLE_NAME' AND I.type <= 1  
ORDER BY P.partition_number;  
