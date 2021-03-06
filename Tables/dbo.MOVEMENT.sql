CREATE TABLE [dbo].[MOVEMENT] (
  [MOV_ROWID] [int] IDENTITY,
  [MOV_CODE] [nvarchar](30) NOT NULL,
  [MOV_ORG] [nvarchar](30) NOT NULL,
  [MOV_STNID] [int] NULL,
  [MOV_CCDID] [int] NULL,
  [MOV_DESC] [nvarchar](80) NULL,
  [MOV_NOTE] [ntext] NULL,
  [MOV_DATE] [datetime] NULL,
  [MOV_STATUS] [nvarchar](30) NULL,
  [MOV_TYPE] [nvarchar](30) NULL,
  [MOV_TYPE2] [nvarchar](30) NULL,
  [MOV_TYPE3] [nvarchar](30) NULL,
  [MOV_RSTATUS] [int] NULL CONSTRAINT [DF_MOVEMENT_MOV_RSTATUS] DEFAULT (0),
  [MOV_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_MOVEMENT_MOV_CREUSER] DEFAULT ('SA'),
  [MOV_CREDATE] [datetime] NULL CONSTRAINT [DF_MOVEMENT_CREDATE] DEFAULT (getdate()),
  [MOV_UPDUSER] [nvarchar](30) NULL,
  [MOV_UPDDATE] [datetime] NULL,
  [MOV_NOTUSED] [int] NULL CONSTRAINT [DF_MOVEMENT_MOV_NOTUSED] DEFAULT (0),
  [MOV_ID] [nvarchar](50) NULL CONSTRAINT [DF_MOVEMENT_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [MOV_TXT01] [nvarchar](30) NULL,
  [MOV_TXT02] [nvarchar](30) NULL,
  [MOV_TXT03] [nvarchar](30) NULL,
  [MOV_TXT04] [nvarchar](30) NULL,
  [MOV_TXT05] [nvarchar](30) NULL,
  [MOV_TXT06] [nvarchar](80) NULL,
  [MOV_TXT07] [nvarchar](80) NULL,
  [MOV_TXT08] [nvarchar](255) NULL,
  [MOV_TXT09] [nvarchar](255) NULL,
  [MOV_NTX01] [numeric](24, 6) NULL,
  [MOV_NTX02] [numeric](24, 6) NULL,
  [MOV_NTX03] [numeric](24, 6) NULL,
  [MOV_NTX04] [numeric](24, 6) NULL,
  [MOV_NTX05] [numeric](24, 6) NULL,
  [MOV_COM01] [ntext] NULL,
  [MOV_COM02] [ntext] NULL,
  [MOV_DTX01] [datetime] NULL,
  [MOV_DTX02] [datetime] NULL,
  [MOV_DTX03] [datetime] NULL,
  [MOV_DTX04] [datetime] NULL,
  [MOV_DTX05] [datetime] NULL,
  [MOV_RESPON] [nvarchar](30) NULL,
  [MOV_AUTH] [nvarchar](30) NULL,
  [MOV_AUTHDATE] [datetime] NULL,
  [MOV_BTN_ENABLE] [int] NULL,
  [MOV_AST] [smallint] NULL,
  [MOV_ROWGUID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_MOVEMENT] PRIMARY KEY NONCLUSTERED ([MOV_CODE], [MOV_ORG]),
  CONSTRAINT [UQ_MOVEMENT] UNIQUE CLUSTERED ([MOV_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[MOVEMENT]
  ADD CONSTRAINT [FK_MOVEMENT_ORG] FOREIGN KEY ([MOV_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE])
GO