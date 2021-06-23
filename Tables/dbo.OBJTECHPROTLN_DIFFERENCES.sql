CREATE TABLE [dbo].[OBJTECHPROTLN_DIFFERENCES] (
  [id] [int] IDENTITY,
  [RodzZmiany] [nvarchar](50) NULL,
  [POT_ROWID] [int] NULL,
  [OBJ_ROWID] [int] NULL,
  [POL_STATUS] [nvarchar](40) NULL,
  [POL_STA_DESC] [nvarchar](80) NULL,
  [OBJ_STATUS] [nvarchar](80) NULL,
  [OBJ_CODE] [nvarchar](40) NULL,
  [zatwierdzone] [int] NULL,
  [data_wykonania] [datetime] NULL,
  [CRE_USER] [nvarchar](50) NULL,
  [OBJ_GROUPID] [int] NULL,
  [OBJ_GROUP_DESC] [nvarchar](60) NULL,
  [POL_OLDQTY] [numeric](30, 6) NULL,
  [POL_NEWQTY] [numeric](30, 6) NULL,
  [POL_CODE] [nvarchar](40) NULL,
  [POL_CREDATE] [datetime] NULL,
  [POL_CREUSER] [nvarchar](50) NULL,
  [POL_DATE] [datetime] NULL,
  [POL_DESC] [nvarchar](300) NULL,
  [POL_ID] [nvarchar](300) NULL,
  [POL_NOTE] [nvarchar](max) NULL,
  [POL_NOTUSED] [int] NULL,
  [POL_ORG] [nvarchar](20) NULL,
  [POL_RSTATUS] [int] NULL,
  [POL_TYPE] [nvarchar](50) NULL,
  [POL_BIZ_DEC] [int] NULL,
  [POL_ADHOC] [int] NULL,
  [POL_ZARZ_BIZ] [int] NULL,
  [POL_WIEK] [int] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[OBJTECHPROTLN_DIFFERENCES]
  ADD CONSTRAINT [FK_POLN_DIFF_OBJID] FOREIGN KEY ([OBJ_ROWID]) REFERENCES [dbo].[OBJ] ([OBJ_ROWID])
GO