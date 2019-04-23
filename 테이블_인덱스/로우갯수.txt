SELECT  T.name             AS [TableName],
        SUM( P.[rows] )    AS [TotalRowCount]
FROM    sys.tables AS T
	JOIN    sys.partitions AS P		    ON  T.[object_id] = P.[object_id] AND P.index_id IN (0, 1)
--WHERE    T.name = N'table name' /* uncomment to look for a specific table */
GROUP BY    T.name;