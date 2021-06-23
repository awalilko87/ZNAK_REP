CREATE TABLE [dbo].[INVTSK_NEW_OBJ] (
  [INO_ROWID] [int] IDENTITY,
  [INO_STSID] [int] NOT NULL,
  [INO_PSPID] [int] NULL,
  [INO_STNID] [int] NULL,
  [INO_CODE] [nvarchar](30) NULL,
  [INO_ORG] [nvarchar](30) NOT NULL,
  [INO_DESC] [nvarchar](80) NULL,
  [INO_DATE] [datetime] NULL,
  [INO_STATUS] [nvarchar](30) NULL,
  [INO_TYPE] [nvarchar](30) NULL,
  [INO_TYPE2] [nvarchar](30) NULL,
  [INO_TYPE3] [nvarchar](30) NULL,
  [INO_RSTATUS] [int] NULL,
  [INO_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_INO_INO_CREUSER] DEFAULT (N'SA'),
  [INO_CREDATE] [datetime] NULL CONSTRAINT [DF_INO__CREDATE] DEFAULT (getdate()),
  [INO_UPDUSER] [nvarchar](30) NULL,
  [INO_UPDDATE] [datetime] NULL,
  [INO_NOTUSED] [int] NULL CONSTRAINT [DF_INO_INO_NOTUSED] DEFAULT (0),
  [INO_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_INO_INO_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [INO_TXT01] [nvarchar](30) NULL,
  [INO_TXT02] [nvarchar](30) NULL,
  [INO_TXT03] [nvarchar](30) NULL,
  [INO_TXT04] [nvarchar](30) NULL,
  [INO_TXT05] [nvarchar](30) NULL,
  [INO_TXT06] [nvarchar](80) NULL,
  [INO_TXT07] [nvarchar](80) NULL,
  [INO_TXT08] [nvarchar](255) NULL,
  [INO_TXT09] [nvarchar](255) NULL,
  [INO_TXT10] [nvarchar](80) NULL,
  [INO_TXT11] [nvarchar](80) NULL,
  [INO_TXT12] [nvarchar](80) NULL,
  [INO_NTX01] [numeric](24, 6) NULL,
  [INO_NTX02] [numeric](24, 6) NULL,
  [INO_NTX03] [numeric](24, 6) NULL,
  [INO_NTX04] [numeric](24, 6) NULL,
  [INO_NTX05] [numeric](24, 6) NULL,
  [INO_COM01] [ntext] NULL,
  [INO_COM02] [ntext] NULL,
  [INO_DTX01] [datetime] NULL,
  [INO_DTX02] [datetime] NULL,
  [INO_DTX03] [datetime] NULL,
  [INO_DTX04] [datetime] NULL,
  [INO_DTX05] [datetime] NULL,
  [INO_QTY] [int] NULL,
  [INO_MULTI] [tinyint] NULL,
  [INO_ITSID] [int] NULL,
  CONSTRAINT [PK_INO_1] PRIMARY KEY CLUSTERED ([INO_ROWID]),
  CONSTRAINT [UQ_INO] UNIQUE ([INO_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [E2IDX_INO01]
  ON [dbo].[INVTSK_NEW_OBJ] ([INO_CREUSER])
  INCLUDE ([INO_ROWID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[INVTSK_NEW_OBJ]
  ADD CONSTRAINT [FK_INO_STATION] FOREIGN KEY ([INO_STNID]) REFERENCES [dbo].[STATION] ([STN_ROWID])
GO

ALTER TABLE [dbo].[INVTSK_NEW_OBJ]
  ADD CONSTRAINT [FK_INO_STENCIL] FOREIGN KEY ([INO_STSID]) REFERENCES [dbo].[STENCIL] ([STS_ROWID])
GO