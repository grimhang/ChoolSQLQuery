USE [CNJ_FCS_CELL_T02]
GO

/****** Object:  Table [dbo].[TC_TRAY]    Script Date: 2021-03-23 오전 9:44:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
    drop table TC_TRAY

    bcp CNJ_FCS_CELL_P01.dbo.TC_TRAY OUT g:\BCP\TC_TRAY.bcp -T -n -b 50000   
    9:50 kor time 복사 시작(1.39GB)     355KB/s
*/

CREATE TABLE [dbo].[TC_TRAY](
	[TRAY_NO] [bigint] NOT NULL,
	[LOT_NO] [int] NULL,
	[TRAY_ID] [nchar](10) NULL,
	[TRAY_TYPE_CD] [nchar](4) NULL,
	[CREATE_TIME] [nchar](14) NULL,
	[ROUTE_ID] [nchar](4) NULL,
	[LINE_ID] [nchar](3) NULL,
	[OP_ID] [nchar](3) NULL,
	[OP_SEQ] [int] NULL,
	[JUDG_OP_ID] [nchar](3) NULL,
	[OP_PLAN_TIME] [nchar](14) NULL,
	[RWK_YN] [nchar](1) NULL,
	[OP_RESULT_SEQ] [nvarchar](18) NULL,
	[TRAY_OP_STATUS_CD] [nchar](1) NULL,
	[RESULT_RFT_YN] [nchar](1) NULL,
	[DUMMY_YN] [nchar](1) NULL,
	[AGING_OUT_PRIORITY] [int] NULL,
	[CA_LOT_NO] [int] NULL,
	[AN_LOT_NO] [int] NULL,
	[PALLET_ID] [nvarchar](10) NULL,
	[FIN_CD] [nchar](1) NULL,
	[SPECIAL_NO] [bigint] NULL,
	[SPECIAL_YN] [nchar](1) NULL,
	[AGING_RS_OUT_YN] [nchar](1) NULL,
	[EQP_ID] [nvarchar](10) NULL,
	[RES] [nchar](1) NULL,
	[NEXT_OP_LANE_ID] [nchar](3) NULL,
	[FC_PLAN_TIME] [nchar](14) NULL,
	[PROD_CD] [nvarchar](18) NULL,
	[SAMPLE_MEAS_YN] [nchar](1) NOT NULL,
	[MOVE_ON_YN] [nchar](1) NOT NULL,
	[MDF_TIME] [nchar](14) NULL,
	[MDF_ID] [nvarchar](20) NULL,
	[SPECIAL_DESC] [nvarchar](2048) NULL,
	[INSUSERID] [nvarchar](50) NOT NULL,
	[UPDUSERID] [nvarchar](50) NOT NULL,
	[INSDTTM] [datetime] NOT NULL,
	[UPDDTTM] [datetime] NOT NULL,
	[NEXT_OP_EQP_ID] [nvarchar](10) NULL,
	[CELL_ID_YN] [nchar](1) NULL,
	[FOX_T] [int] NOT NULL
) ON [PRIMARY]
GO

/*
    bcp CNJ_FCS_CELL_T02.dbo.TC_TRAY in e:\BCP\TC_TRAY.bcp -T -n -b 50000
*/

ALTER TABLE [dbo].[TC_TRAY] ADD CONSTRAINT [PK_TC_TRAY] PRIMARY KEY CLUSTERED   -- 
(
	[TRAY_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/*
ALTER INDEX PK_TC_TRAY ON [dbo].[TC_TRAY] REBUILD
GO
*/

/****** Object:  Index [FK_TC_TRAY_1]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_1] ON [dbo].[TC_TRAY]
(
	[LOT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/*
ALTER INDEX FK_TC_TRAY_1 ON [dbo].[TC_TRAY] REBUILD
GO
*/

SET ANSI_PADDING ON
GO

/****** Object:  Index [FK_TC_TRAY_2]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_2] ON [dbo].[TC_TRAY]
(
	[PALLET_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [FK_TC_TRAY_3]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_3] ON [dbo].[TC_TRAY]
(
	[ROUTE_ID] ASC,
	[OP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [FK_TC_TRAY_4]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_4] ON [dbo].[TC_TRAY]
(
	[TRAY_TYPE_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [FK_TC_TRAY_5]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_5] ON [dbo].[TC_TRAY]
(
	[LINE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [FK_TC_TRAY_6]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [FK_TC_TRAY_6] ON [dbo].[TC_TRAY]
(
	[ROUTE_ID] ASC,
	[JUDG_OP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_TC_TRAY_FC_I7] ON [dbo].[TC_TRAY]
(
	[FIN_CD] ASC
)
INCLUDE([TRAY_NO],[LOT_NO],[ROUTE_ID],[OP_ID],[OP_PLAN_TIME],[TRAY_OP_STATUS_CD],[SPECIAL_YN]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N1]    Script Date: 2021-03-23 오전 9:44:44 ******/


SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N2]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N2] ON [dbo].[TC_TRAY]
(
	[TRAY_ID] ASC,
	[FIN_CD] ASC
)
INCLUDE([TRAY_OP_STATUS_CD],[OP_PLAN_TIME],[NEXT_OP_LANE_ID],[AGING_OUT_PRIORITY],[EQP_ID],[MDF_TIME],[MDF_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N3]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N3] ON [dbo].[TC_TRAY]
(
	[FIN_CD] ASC,
	[TRAY_OP_STATUS_CD] ASC,
	[OP_PLAN_TIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N4]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N4] ON [dbo].[TC_TRAY]
(
	[LOT_NO] ASC,
	[LINE_ID] ASC,
	[TRAY_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N5]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N5] ON [dbo].[TC_TRAY]
(
	[FIN_CD] ASC,
	[OP_ID] ASC,
	[EQP_ID] ASC
)
INCLUDE([ROUTE_ID],[OP_PLAN_TIME]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N6]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N6] ON [dbo].[TC_TRAY]
(
	[FIN_CD] ASC,
	[OP_ID] ASC,
	[EQP_ID] ASC,
	[MDF_TIME] ASC
)
INCLUDE([TRAY_ID],[ROUTE_ID],[OP_SEQ],[OP_PLAN_TIME],[TRAY_OP_STATUS_CD],[AGING_OUT_PRIORITY]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N7]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N7] ON [dbo].[TC_TRAY]
(
	[FIN_CD] ASC,
	[NEXT_OP_LANE_ID] ASC,
	[MOVE_ON_YN] ASC,
	[OP_ID] ASC,
	[TRAY_OP_STATUS_CD] ASC,
	[MDF_TIME] ASC
)
INCLUDE([TRAY_ID],[ROUTE_ID],[OP_SEQ],[AGING_OUT_PRIORITY]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [IX_TC_TRAY_N8]    Script Date: 2021-03-23 오전 9:44:44 ******/
CREATE NONCLUSTERED INDEX [IX_TC_TRAY_N8] ON [dbo].[TC_TRAY]
(
	[OP_ID] ASC,
	[FIN_CD] ASC,
	[TRAY_OP_STATUS_CD] ASC,
	[MDF_TIME] ASC,
	[EQP_ID] ASC,
	[OP_PLAN_TIME] ASC,
	[AGING_OUT_PRIORITY] ASC
)
INCLUDE([ROUTE_ID],[OP_SEQ]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [RWK_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('E') FOR [TRAY_OP_STATUS_CD]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [RESULT_RFT_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [DUMMY_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ((5)) FOR [AGING_OUT_PRIORITY]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('C') FOR [FIN_CD]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [SPECIAL_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [AGING_RS_OUT_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [RES]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [SAMPLE_MEAS_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('N') FOR [MOVE_ON_YN]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('SYSTEM') FOR [INSUSERID]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT ('SYSTEM') FOR [UPDUSERID]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT (getdate()) FOR [INSDTTM]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  DEFAULT (getdate()) FOR [UPDDTTM]
GO

ALTER TABLE [dbo].[TC_TRAY] ADD  CONSTRAINT [DF_TC_TRAY_FOX_T]  DEFAULT ((0)) FOR [FOX_T]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.TRAY_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'TRAY_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.LOT_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'LOT_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.TRAY_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'TRAY_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.TRAY_TYPE_CD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'TRAY_TYPE_CD'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.CREATE_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'CREATE_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.ROUTE_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'ROUTE_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.LINE_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'LINE_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.OP_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'OP_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.OP_SEQ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'OP_SEQ'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.JUDG_OP_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'JUDG_OP_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.OP_PLAN_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'OP_PLAN_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.RWK_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'RWK_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.OP_RESULT_SEQ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'OP_RESULT_SEQ'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.TRAY_OP_STATUS_CD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'TRAY_OP_STATUS_CD'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.RESULT_RFT_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'RESULT_RFT_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.DUMMY_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'DUMMY_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.AGING_OUT_PRIORITY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'AGING_OUT_PRIORITY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.CA_LOT_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'CA_LOT_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.AN_LOT_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'AN_LOT_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.PALLET_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'PALLET_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.FIN_CD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'FIN_CD'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.SPECIAL_NO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'SPECIAL_NO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.SPECIAL_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'SPECIAL_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.AGING_RS_OUT_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'AGING_RS_OUT_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.EQP_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'EQP_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.RES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'RES'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.NEXT_OP_LANE_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'NEXT_OP_LANE_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.FC_PLAN_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'FC_PLAN_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.PROD_CD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'PROD_CD'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.SAMPLE_MEAS_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'SAMPLE_MEAS_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.MOVE_ON_YN' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'MOVE_ON_YN'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.MDF_TIME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'MDF_TIME'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.MDF_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'MDF_ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.SPECIAL_DESC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'COLUMN',@level2name=N'SPECIAL_DESC'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY.PK_TC_TRAY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY', @level2type=N'CONSTRAINT',@level2name=N'PK_TC_TRAY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'FORMDBA.TC_TRAY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TC_TRAY'
GO


