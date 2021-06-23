CREATE TABLE [dbo].[PSPEDIT] (
  [PSE_ROWID] [int] IDENTITY,
  [PSE_CODE] [nvarchar](30) NOT NULL,
  [PSE_ORG] [nvarchar](30) NOT NULL,
  [PSE_DESC] [nvarchar](80) NULL,
  [PSE_DATE] [datetime] NULL,
  [PSE_STATUS] [nvarchar](30) NULL,
  [PSE_TYPE] [nvarchar](30) NULL,
  [PSE_TYPE2] [nvarchar](30) NULL,
  [PSE_TYPE3] [nvarchar](30) NULL,
  [PSE_RSTATUS] [int] NULL,
  [PSE_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_PSE_PSE_CREUSER] DEFAULT (N'SA'),
  [PSE_CREDATE] [datetime] NULL CONSTRAINT [DF_PSE__CREDATE] DEFAULT (getdate()),
  [PSE_UPDUSER] [nvarchar](30) NULL,
  [PSE_UPDDATE] [datetime] NULL,
  [PSE_NOTUSED] [int] NULL CONSTRAINT [DF_PSE_PSE_NOTUSED] DEFAULT (0),
  [PSE_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_PSE_PSE_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [PSE_TXT01] [nvarchar](30) NULL,
  [PSE_TXT02] [nvarchar](30) NULL,
  [PSE_TXT03] [nvarchar](30) NULL,
  [PSE_TXT04] [nvarchar](30) NULL,
  [PSE_TXT05] [nvarchar](30) NULL,
  [PSE_TXT06] [nvarchar](80) NULL,
  [PSE_TXT07] [nvarchar](80) NULL,
  [PSE_TXT08] [nvarchar](255) NULL,
  [PSE_TXT09] [nvarchar](255) NULL,
  [PSE_TXT10] [nvarchar](80) NULL,
  [PSE_TXT11] [nvarchar](80) NULL,
  [PSE_TXT12] [nvarchar](80) NULL,
  [PSE_NTX01] [numeric](24, 6) NULL,
  [PSE_NTX02] [numeric](24, 6) NULL,
  [PSE_NTX03] [numeric](24, 6) NULL,
  [PSE_NTX04] [numeric](24, 6) NULL,
  [PSE_NTX05] [numeric](24, 6) NULL,
  [PSE_COM01] [ntext] NULL,
  [PSE_COM02] [ntext] NULL,
  [PSE_DTX01] [datetime] NULL,
  [PSE_DTX02] [datetime] NULL,
  [PSE_DTX03] [datetime] NULL,
  [PSE_DTX04] [datetime] NULL,
  [PSE_DTX05] [datetime] NULL,
  [PSE_NOTE] [nvarchar](255) NULL,
  CONSTRAINT [PK_PSE_1] PRIMARY KEY CLUSTERED ([PSE_CODE]),
  CONSTRAINT [UQ_PSE] UNIQUE ([PSE_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PSPEDIT]
  ADD CONSTRAINT [FK_PSE_ORG] FOREIGN KEY ([PSE_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO