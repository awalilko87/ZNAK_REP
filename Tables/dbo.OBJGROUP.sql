CREATE TABLE [dbo].[OBJGROUP] (
  [OBG_ROWID] [int] IDENTITY,
  [OBG_CODE] [nvarchar](48) NOT NULL,
  [OBG_ORG] [nvarchar](30) NOT NULL,
  [OBG_DESC] [nvarchar](80) NULL,
  [OBG_NOTE] [ntext] NULL,
  [OBG_DATE] [datetime] NULL,
  [OBG_STATUS] [nvarchar](30) NULL,
  [OBG_TYPE] [nvarchar](30) NULL,
  [OBG_TYPE2] [nvarchar](30) NULL,
  [OBG_TYPE3] [nvarchar](30) NULL,
  [OBG_RSTATUS] [int] NULL,
  [OBG_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_OBJGROUP_CREUSER] DEFAULT (N'SA'),
  [OBG_CREDATE] [datetime] NULL CONSTRAINT [DF_OBJGROUP_CREDATE] DEFAULT (getdate()),
  [OBG_UPDUSER] [nvarchar](30) NULL,
  [OBG_UPDDATE] [datetime] NULL,
  [OBG_NOTUSED] [int] NULL,
  [OBG_ID] [nvarchar](50) NULL CONSTRAINT [DF_OBJGROUP_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [OBG_AUTHGROUP] [nvarchar](100) NULL,
  [OBG_TXT01] [nvarchar](30) NULL,
  [OBG_TXT02] [nvarchar](30) NULL,
  [OBG_TXT03] [nvarchar](30) NULL,
  [OBG_TXT04] [nvarchar](30) NULL,
  [OBG_TXT05] [nvarchar](30) NULL,
  [OBG_TXT06] [nvarchar](80) NULL,
  [OBG_TXT07] [nvarchar](80) NULL,
  [OBG_TXT08] [nvarchar](255) NULL,
  [OBG_TXT09] [nvarchar](255) NULL,
  [OBG_NTX01] [numeric](24, 6) NULL,
  [OBG_NTX02] [numeric](24, 6) NULL,
  [OBG_NTX03] [numeric](24, 6) NULL,
  [OBG_NTX04] [numeric](24, 6) NULL,
  [OBG_NTX05] [numeric](24, 6) NULL,
  [OBG_COM01] [ntext] NULL,
  [OBG_COM02] [ntext] NULL,
  [OBG_DTX01] [datetime] NULL,
  [OBG_DTX02] [datetime] NULL,
  [OBG_DTX03] [datetime] NULL,
  [OBG_DTX04] [datetime] NULL,
  [OBG_DTX05] [datetime] NULL,
  CONSTRAINT [PK_OBJGROUP_1] PRIMARY KEY NONCLUSTERED ([OBG_CODE], [OBG_ORG]),
  CONSTRAINT [UQ_OBJGROUP] UNIQUE CLUSTERED ([OBG_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[OBJGROUP]
  ADD CONSTRAINT [FK_OBJGROUP_ORG] FOREIGN KEY ([OBG_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO