SELECT a.object_id, object_name(a.object_id) AS TableName,
    a.index_id, name AS IndedxName, b.type_desc, a.partition_number, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(N'CNJ_FCS_CELL_P01'), OBJECT_ID(N'DBO.TC_CELL'), NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b    ON a.object_id = b.object_id    AND a.index_id = b.index_id
ORDER BY TableName, a.index_id, a.partition_number
GO

SELECT * FROM SYS.indexes

/*
object_id  TableName  index_id  IndedxName     type_desc     partition_number  avg_fragmentation_in_percent
---------  ---------  --------  -------------  ------------  ----------------  ----------------------------
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     1                 0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     2                 0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     3                 0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     4                 0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     5                 0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     6                 6.22769607411796
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     7                 6.8847865570165
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     8                 7.16689169132362
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     9                 5.52858686476129
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     10                4.22822840775997
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     11                3.67747129152201
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     12                3.79810834473999
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     13                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     14                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     15                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     16                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     17                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     18                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     19                0
341628310  TC_CELL    1         PK_TC_CELL     CLUSTERED     20                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  1                 0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  2                 0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  3                 0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  4                 0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  5                 0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  6                 51.3477843969557
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  7                 52.7795460713027
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  8                 48.8187955333997
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  9                 47.1103732574151
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  10                33.8036858528994
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  11                33.5673998704363
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  12                35.7862158960183
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  13                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  14                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  15                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  16                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  17                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  18                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  19                0
341628310  TC_CELL    2         IX_TC_CELL_01  NONCLUSTERED  20                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  1                 0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  2                 0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  3                 0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  4                 0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  5                 0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  6                 76.6652289112083
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  7                 76.4265775431534
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  8                 77.0836430305733
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  9                 75.5742281240599
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  10                77.6482343340344
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  11                78.7569809769613
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  12                71.0246504456928
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  13                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  14                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  15                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  16                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  17                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  18                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  19                0
341628310  TC_CELL    3         IDX_DW_UPDDTM  NONCLUSTERED  20                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  1                 0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  2                 0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  3                 0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  4                 0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  5                 0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  6                 10.2310216046722
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  7                 11.3027802681983
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  8                 12.2369290978715
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  9                 9.53480815337192
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  10                7.73411848227076
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  11                6.40843169492773
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  12                6.50716757291152
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  13                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  14                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  15                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  16                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  17                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  18                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  19                0
341628310  TC_CELL    4         FK_CC_CT_1     NONCLUSTERED  20                0
*/
