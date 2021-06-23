CREATE TABLE [dbo].[M_AST_INWLN] (
  [SIA_SINID] [int] NULL,
  [SIA_ASSETID] [int] NULL,
  [SIA_CODE] [nvarchar](30) NULL,
  [SIA_BARCODE] [nvarchar](30) NULL,
  [SIA_ASTDESC] [nvarchar](500) NULL,
  [SIA_ROWGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_M_AST_INWLN_SIA_ROWGUID] DEFAULT (newid()),
  [SIA_ORG] [nvarchar](30) NULL,
  [SIA_OLDQTY] [numeric](30, 6) NULL,
  [SIA_NEWQTY] [numeric](30, 6) NULL,
  [SIA_PRICE] [numeric](30, 6) NULL,
  [SIA_NOTE] [ntext] NULL,
  [SIA_STATUS] [nvarchar](30) NULL,
  [SIA_RSTATUS] [int] NULL,
  [SIA_NOTUSED] [int] NULL,
  [SIA_ID] [nvarchar](50) NULL,
  [SIA_OBJID] [int] NULL,
  [SIA_SURPLUS] [int] NULL,
  [SIA_PDA_DATE] [datetime] NULL,
  [SIA_CONFIRMUSER] [nvarchar](30) NULL,
  [SIA_CONFIRMDATE] [datetime] NULL,
  [SIA_SYNC] [int] NULL,
  CONSTRAINT [PK_M_AST_INWLN] PRIMARY KEY CLUSTERED ([SIA_ROWGUID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO