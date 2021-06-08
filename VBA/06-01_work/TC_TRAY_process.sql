USE [CNJ_FCS_CELL_T02]
GO

/****** Object:  Table [dbo].[TC_TRAY_PROCESS]    Script Date: 2021-05-25 오후 7:30:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
    DROP TABLE TC_TRAY_PROCESS
    GO

    bcp CNJ_FCS_CELL_P01.dbo.TC_TRAY_PROCESS OUT g:\BCP\TC_TRAY_PROCESS.bcp -T -n -b 50000
    50000 일때 로컬 하드로 bcp out은 5분  BCP했더니 24GB  (원본은 40gb)
    136으로 복사할때는 ?

    -- 2021-05-31
    name	        rows	        reserved	    data	    index_size	    unused
    TC_TRAY_PROCESS	118,440,438     28,396,648 KB	28315400 KB	    81088 KB	160 KB

    select * into TC_TRAY_PROCESS_bak     from TC_TRAY_PROCESS      -- 00:41
*/

CREATE TABLE [dbo].[TC_TRAY_PROCESS](
	[TRAY_NO] [bigint] NOT NULL,
	[OP_ID] [nchar](3) NOT NULL,
	[OP_START_TIME] [nchar](14) NULL,
	[OP_END_TIME] [nchar](14) NULL,
	[ROUTE_ID] [nchar](4) NULL,
	[EQP_ID] [nvarchar](10) NULL,
	[DOCV_APPLY_YN] [nchar](1) NULL,
	[IRR_HIST_YN] [nchar](1) NULL,
	[IN_CELL_CNT] [int] NULL,
	[PROFILE_YN] [nchar](1) NULL,
	[MDF_TIME] [nchar](14) NULL,
	[MDF_ID] [nvarchar](20) NULL,
	[INSUSERID] [nvarchar](50) NOT NULL,
	[UPDUSERID] [nvarchar](50) NOT NULL,
	[INSDTTM] [datetime] NOT NULL,
	[UPDDTTM] [datetime] NOT NULL,
	[INS_TIME] [nchar](14) NOT NULL
) ON [PRIMARY]
GO

/*
    bcp CNJ_FCS_CELL_T02.dbo.TC_TRAY_PROCESS in e:\BCP\TC_TRAY_PROCESS.bcp -T -n -b 50000       -- 07:00
    or
    INSERT INTO TC_TRAY_PROCESS WITH(TABLOCK) SELECT * FROM TC_TRAY_PROCESS_BAK                 -- 02:02        TABLOCK 해야 BULK_OPERATION 되어 최소로깅
*/

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD CONSTRAINT [PK_TC_TRAY_PROCESS] PRIMARY KEY CLUSTERED 
(
	[TRAY_NO] ASC,
	[OP_ID] ASC
) ON [PRIMARY]       -- 01:39
--) WITH (SORT_IN_TEMPDB = ON) ON [PRIMARY]       -- 01:40
-- sort_in_tempdb = on 이 비슷하거나 약간 느린게 test db 서버는 깔끔한 상태라서 처음부터 깨져 있지 않기 때문으로 추측.
-- 실서버에서느 sort_in_tempdb로 해보자
-- 아니면 cl이라서?

    ALTER INDEX [PK_TC_TRAY_PROCESS] ON [dbo].[TC_TRAY_PROCESS]
    -- REBUILD       -- 00:45
    REBUILD WITH ( SORT_IN_TEMPDB = ON)        -- 00:43
    GO



/****** Object:  Index [FK_TC_TRAY_PROCESS_1]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_PROCESS_1] ON [dbo].[TC_TRAY_PROCESS]
(
	[EQP_ID] ASC
--) on [PRIMARY]        -- 01:46
)WITH (SORT_IN_TEMPDB = ON) ON [PRIMARY]        -- 01:49
GO

    ALTER INDEX [FK_TC_TRAY_PROCESS_1] ON [dbo].[TC_TRAY_PROCESS]
    REBUILD -- 00:26
    --REBUILD WITH (SORT_IN_TEMPDB = ON)        -- 00:30
    -- REBUILD WITH (SORT_IN_TEMPDB = ON, maxdop = 1)        -- 01:35
    GO





/****** Object:  Index [FK_TC_TRAY_PROCESS_2]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_PROCESS_2] ON [dbo].[TC_TRAY_PROCESS]
(
	[OP_ID] ASC,
	[ROUTE_ID] ASC
) ON [PRIMARY]        -- 01:59
GO



/****** Object:  Index [IX_TC_TRAY_PROCESS_N3]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_PROCESS_N3] ON [dbo].[TC_TRAY_PROCESS]
(
	[OP_START_TIME] ASC
) on [PRIMARY]        -- 01:45
GO


/****** Object:  Index [IX_TC_TRAY_PROCESS_N4]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_PROCESS_N4] ON [dbo].[TC_TRAY_PROCESS]
(
	[TRAY_NO] ASC,
	[OP_ID] ASC,
	[OP_START_TIME] ASC
) on [PRIMARY]
GO

/****** Object:  Index [IX_TC_TRAY_PROCESS_N5]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_PROCESS_N5] ON [dbo].[TC_TRAY_PROCESS]
(
	[OP_END_TIME] ASC,
	[OP_ID] ASC
) on [PRIMARY]
GO



/****** Object:  Index [IX_TC_TRAY_PROCESS_N6]    Script Date: 2021-05-25 오후 7:30:16 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_PROCESS_N6] ON [dbo].[TC_TRAY_PROCESS]
(
	[OP_START_TIME] ASC,
	[EQP_ID] ASC
)
INCLUDE([IN_CELL_CNT]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT ('N') FOR [DOCV_APPLY_YN]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT ('N') FOR [IRR_HIST_YN]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT ('N') FOR [PROFILE_YN]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT ('SYSTEM') FOR [INSUSERID]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT ('SYSTEM') FOR [UPDUSERID]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT (getdate()) FOR [INSDTTM]
GO

ALTER TABLE [dbo].[TC_TRAY_PROCESS] ADD  DEFAULT (getdate()) FOR [UPDDTTM]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.TRAY_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'TRAY_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.OP_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'OP_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.OP_START_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'OP_START_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.OP_END_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'OP_END_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.ROUTE_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.EQP_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'EQP_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.DOCV_APPLY_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'DOCV_APPLY_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.IRR_HIST_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'IRR_HIST_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.IN_CELL_CNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'IN_CELL_CNT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.PROFILE_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'PROFILE_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.MDF_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'MDF_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.MDF_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'COLUMN',@level2name=N'MDF_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS.PK_TC_TRAY_PROCESS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS', @level2type=N'CONSTRAINT',@level2name=N'PK_TC_TRAY_PROCESS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY_PROCESS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY_PROCESS'
GO


