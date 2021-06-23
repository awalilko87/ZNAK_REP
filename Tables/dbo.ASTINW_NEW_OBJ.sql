﻿CREATE TABLE [dbo].[ASTINW_NEW_OBJ] (
  [ANO_ROWID] [int] IDENTITY,
  [ANO_ASTID] [int] NULL,
  [ANO_STSID] [int] NOT NULL,
  [ANO_STNID] [int] NOT NULL,
  [ANO_SIAID] [int] NULL,
  [ANO_CODE] [nvarchar](30) NULL,
  [ANO_ORG] [nvarchar](30) NOT NULL,
  [ANO_DESC] [nvarchar](80) NULL,
  [ANO_DATE] [datetime] NULL,
  [ANO_STATUS] [nvarchar](30) NULL,
  [ANO_TYPE] [nvarchar](30) NULL,
  [ANO_TYPE2] [nvarchar](30) NULL,
  [ANO_TYPE3] [nvarchar](30) NULL,
  [ANO_RSTATUS] [int] NULL,
  [ANO_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_ANO_ANO_CREUSER] DEFAULT (N'SA'),
  [ANO_CREDATE] [datetime] NULL CONSTRAINT [DF_ANO__CREDATE] DEFAULT (getdate()),
  [ANO_UPDUSER] [nvarchar](30) NULL,
  [ANO_UPDDATE] [datetime] NULL,
  [ANO_NOTUSED] [int] NULL CONSTRAINT [DF_ANO_ANO_NOTUSED] DEFAULT (0),
  [ANO_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_ANO_ANO_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [ANO_TXT01] [nvarchar](30) NULL,
  [ANO_TXT02] [nvarchar](30) NULL,
  [ANO_TXT03] [nvarchar](30) NULL,
  [ANO_TXT04] [nvarchar](30) NULL,
  [ANO_TXT05] [nvarchar](30) NULL,
  [ANO_TXT06] [nvarchar](80) NULL,
  [ANO_TXT07] [nvarchar](80) NULL,
  [ANO_TXT08] [nvarchar](255) NULL,
  [ANO_TXT09] [nvarchar](255) NULL,
  [ANO_TXT10] [nvarchar](80) NULL,
  [ANO_TXT11] [nvarchar](80) NULL,
  [ANO_TXT12] [nvarchar](80) NULL,
  [ANO_NTX01] [numeric](24, 6) NULL,
  [ANO_NTX02] [numeric](24, 6) NULL,
  [ANO_NTX03] [numeric](24, 6) NULL,
  [ANO_NTX04] [numeric](24, 6) NULL,
  [ANO_NTX05] [numeric](24, 6) NULL,
  [ANO_COM01] [ntext] NULL,
  [ANO_COM02] [ntext] NULL,
  [ANO_DTX01] [datetime] NULL,
  [ANO_DTX02] [datetime] NULL,
  [ANO_DTX03] [datetime] NULL,
  [ANO_DTX04] [datetime] NULL,
  [ANO_DTX05] [datetime] NULL,
  CONSTRAINT [PK_ANO_1] PRIMARY KEY CLUSTERED ([ANO_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [E2IDX_ANO01]
  ON [dbo].[ASTINW_NEW_OBJ] ([ANO_ASTID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ASTINW_NEW_OBJ]
  ADD CONSTRAINT [FK_ANO_ASSET] FOREIGN KEY ([ANO_ASTID]) REFERENCES [dbo].[ASSET] ([AST_ROWID])
GO

ALTER TABLE [dbo].[ASTINW_NEW_OBJ]
  ADD CONSTRAINT [FK_ANO_STATION] FOREIGN KEY ([ANO_STNID]) REFERENCES [dbo].[STATION] ([STN_ROWID])
GO

ALTER TABLE [dbo].[ASTINW_NEW_OBJ]
  ADD CONSTRAINT [FK_ANO_STENCIL] FOREIGN KEY ([ANO_STSID]) REFERENCES [dbo].[STENCIL] ([STS_ROWID])
GO