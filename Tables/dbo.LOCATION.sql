CREATE TABLE [dbo].[LOCATION] (
  [LOC_ROWID] [int] IDENTITY,
  [LOC_CODE] [nvarchar](30) NOT NULL,
  [LOC_ORG] [nvarchar](30) NOT NULL,
  [LOC_DESC] [nvarchar](80) NULL,
  [LOC_NOTE] [ntext] NULL,
  [LOC_DATE] [datetime] NULL,
  [LOC_STATUS] [nvarchar](30) NULL,
  [LOC_TYPE] [nvarchar](30) NULL,
  [LOC_TYPE2] [nvarchar](30) NULL,
  [LOC_TYPE3] [nvarchar](30) NULL,
  [LOC_RSTATUS] [int] NULL,
  [LOC_CREUSER] [nvarchar](30) NULL,
  [LOC_CREDATE] [datetime] NULL CONSTRAINT [DF_LOCATION__CREDATE] DEFAULT (getdate()),
  [LOC_UPDUSER] [nvarchar](30) NULL,
  [LOC_UPDDATE] [datetime] NULL,
  [LOC_NOTUSED] [int] NULL,
  [LOC_ID] [nvarchar](50) NULL CONSTRAINT [DF_LOCATION__ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [LOC_TXT01] [nvarchar](30) NULL,
  [LOC_TXT02] [nvarchar](30) NULL,
  [LOC_TXT03] [nvarchar](30) NULL,
  [LOC_TXT04] [nvarchar](30) NULL,
  [LOC_TXT05] [nvarchar](30) NULL,
  [LOC_TXT06] [nvarchar](80) NULL,
  [LOC_TXT07] [nvarchar](80) NULL,
  [LOC_TXT08] [nvarchar](255) NULL,
  [LOC_TXT09] [nvarchar](255) NULL,
  [LOC_NTX01] [numeric](24, 6) NULL,
  [LOC_NTX02] [numeric](24, 6) NULL,
  [LOC_NTX03] [numeric](24, 6) NULL,
  [LOC_NTX04] [numeric](24, 6) NULL,
  [LOC_NTX05] [numeric](24, 6) NULL,
  [LOC_COM01] [ntext] NULL,
  [LOC_COM02] [ntext] NULL,
  [LOC_DTX01] [datetime] NULL,
  [LOC_DTX02] [datetime] NULL,
  [LOC_DTX03] [datetime] NULL,
  [LOC_DTX04] [datetime] NULL,
  [LOC_DTX05] [datetime] NULL,
  CONSTRAINT [PK_LOCATION_1] PRIMARY KEY CLUSTERED ([LOC_CODE]),
  CONSTRAINT [UQ_LOCATION] UNIQUE ([LOC_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOCATION]
  ADD CONSTRAINT [FK_LOCATION_ORG] FOREIGN KEY ([LOC_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO