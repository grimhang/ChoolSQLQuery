SELECT Sch.[name] as 'Schema', T.[name] as 'Table',	I.[name] as 'Index'
	, Stat.avg_fragmentation_in_percent, Stat.page_count
	, Stat.page_count * 8	as Size_KB
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS Stat
	JOIN sys.tables T			on T.[object_id] = Stat.[object_id]
	JOIN sys.schemas Sch		on T.[schema_id] = Sch.[schema_id]
	JOIN sys.indexes AS I		ON I.[object_id] = Stat.[object_id] AND Stat.index_id = I.index_id
WHERE Stat.database_id = DB_ID()
	-- and t.name = 't_SumUAllCntByCabinetByD_Co'
ORDER BY Stat.avg_fragmentation_in_percent DESC

-- ALTER INDEX REBUILD
-- ALTER INDEX REORGANIZE

