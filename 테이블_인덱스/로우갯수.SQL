SELECT T.name AS TableName, SUM(P.rows) AS TotalRowCount
FROM sys.tables AS T
    JOIN sys.partitions AS P        ON T.object_id = P.object_id
WHERE P.index_id IN (0, 1)      -- heap(0), Clutsterd(1) 만 조회
GROUP BY T.name