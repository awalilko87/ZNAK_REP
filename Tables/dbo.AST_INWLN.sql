CREATE TABLE [dbo].[AST_INWLN] (
  [SIA_ROWID] [int] IDENTITY,
  [SIA_SINID] [int] NOT NULL,
  [SIA_ASSETID] [int] NULL,
  [SIA_CODE] [nvarchar](30) NOT NULL,
  [SIA_BARCODE] [nvarchar](30) NULL,
  [SIA_ROWGUID] [uniqueidentifier] NULL CONSTRAINT [DF__AST_INWLN__SIA_R__483D01AD] DEFAULT (newid()),
  [SIA_ORG] [nvarchar](30) NULL,
  [SIA_OLDQTY] [numeric](30, 6) NULL,
  [SIA_NEWQTY] [numeric](30, 6) NULL,
  [SIA_PRICE] [numeric](30, 6) NULL,
  [SIA_DESC] [nvarchar](80) NULL,
  [SIA_NOTE] [ntext] NULL,
  [SIA_DATE] [datetime] NULL,
  [SIA_STATUS] [nvarchar](30) NULL,
  [SIA_TYPE] [nvarchar](30) NULL,
  [SIA_TYPE2] [nvarchar](30) NULL,
  [SIA_TYPE3] [nvarchar](30) NULL,
  [SIA_RSTATUS] [int] NULL,
  [SIA_CREUSER] [nvarchar](30) NULL,
  [SIA_CREDATE] [datetime] NULL,
  [SIA_UPDUSER] [nvarchar](30) NULL,
  [SIA_UPDDATE] [datetime] NULL,
  [SIA_NOTUSED] [int] NULL,
  [SIA_ID] [nvarchar](50) NULL CONSTRAINT [DF_AST_INWLN__ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [SIA_TXT01] [nvarchar](30) NULL,
  [SIA_TXT02] [nvarchar](30) NULL,
  [SIA_TXT03] [nvarchar](30) NULL,
  [SIA_TXT04] [nvarchar](30) NULL,
  [SIA_TXT05] [nvarchar](30) NULL,
  [SIA_TXT06] [nvarchar](80) NULL,
  [SIA_TXT07] [nvarchar](80) NULL,
  [SIA_TXT08] [nvarchar](255) NULL,
  [SIA_TXT09] [nvarchar](255) NULL,
  [SIA_NTX01] [numeric](24, 6) NULL,
  [SIA_NTX02] [numeric](24, 6) NULL,
  [SIA_NTX03] [numeric](24, 6) NULL,
  [SIA_NTX04] [numeric](24, 6) NULL,
  [SIA_NTX05] [numeric](24, 6) NULL,
  [SIA_COM01] [ntext] NULL,
  [SIA_COM02] [ntext] NULL,
  [SIA_DTX01] [datetime] NULL,
  [SIA_DTX02] [datetime] NULL,
  [SIA_DTX03] [datetime] NULL,
  [SIA_DTX04] [datetime] NULL,
  [SIA_DTX05] [datetime] NULL,
  [SIA_OBJID] [int] NULL,
  [SIA_CONFIRMUSER] [nvarchar](30) NULL,
  [SIA_CONFIRMDATE] [datetime] NULL,
  [SIA_SURPLUS] [int] NULL,
  [SIA_PDA_DATE] [datetime] NULL,
  [SIA_NADWYZKA] [int] NULL,
  CONSTRAINT [PK_AST_INWLN] PRIMARY KEY NONCLUSTERED ([SIA_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_AST_INWLN_01]
  ON [dbo].[AST_INWLN] ([SIA_SINID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[AST_INWLN]
  ADD CONSTRAINT [FK_AST_INWLN_ORG] FOREIGN KEY ([SIA_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE])
GO

ALTER TABLE [dbo].[AST_INWLN]
  ADD CONSTRAINT [FK_AST_INWLN_ST_INW] FOREIGN KEY ([SIA_SINID]) REFERENCES [dbo].[ST_INW] ([SIN_ROWID])
GO