CREATE TABLE [dbo].[MANUFAC] (
  [MFC_ROWID] [int] IDENTITY,
  [MFC_CODE] [nvarchar](30) NOT NULL,
  [MFC_ORG] [nvarchar](30) NOT NULL,
  [MFC_DESC] [nvarchar](255) NULL,
  [MFC_NOTE] [ntext] NULL,
  [MFC_DATE] [datetime] NULL,
  [MFC_STATUS] [nvarchar](30) NULL,
  [MFC_TYPE] [nvarchar](30) NULL,
  [MFC_TYPE2] [nvarchar](30) NULL,
  [MFC_TYPE3] [nvarchar](30) NULL,
  [MFC_RSTATUS] [int] NULL CONSTRAINT [DF_MANUFAC_MFC_RSTATUS] DEFAULT (0),
  [MFC_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_MANUFAC_MFC_CREUSER] DEFAULT ('SA'),
  [MFC_CREDATE] [datetime] NULL CONSTRAINT [DF_MANUFAC__CREDATE] DEFAULT (getdate()),
  [MFC_UPDUSER] [nvarchar](30) NULL,
  [MFC_UPDDATE] [datetime] NULL,
  [MFC_NOTUSED] [int] NULL CONSTRAINT [DF_MANUFAC_MFC_NOTUSED] DEFAULT (0),
  [MFC_ID] [nvarchar](50) NULL CONSTRAINT [DF_MANUFAC__ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [MFC_STREET] [nvarchar](255) NULL,
  [MFC_CITY] [nvarchar](80) NULL,
  [MFC_POSTCODE] [nvarchar](30) NULL,
  [MFC_STREETNUM] [nvarchar](30) NULL,
  [MFC_TXT01] [nvarchar](30) NULL,
  [MFC_TXT02] [nvarchar](30) NULL,
  [MFC_TXT03] [nvarchar](30) NULL,
  [MFC_TXT04] [nvarchar](30) NULL,
  [MFC_TXT05] [nvarchar](30) NULL,
  [MFC_TXT06] [nvarchar](80) NULL,
  [MFC_TXT07] [nvarchar](80) NULL,
  [MFC_TXT08] [nvarchar](255) NULL,
  [MFC_TXT09] [nvarchar](255) NULL,
  [MFC_NTX01] [numeric](24, 6) NULL,
  [MFC_NTX02] [numeric](24, 6) NULL,
  [MFC_NTX03] [numeric](24, 6) NULL,
  [MFC_NTX04] [numeric](24, 6) NULL,
  [MFC_NTX05] [numeric](24, 6) NULL,
  [MFC_COM01] [ntext] NULL,
  [MFC_COM02] [ntext] NULL,
  [MFC_DTX01] [datetime] NULL,
  [MFC_DTX02] [datetime] NULL,
  [MFC_DTX03] [datetime] NULL,
  [MFC_DTX04] [datetime] NULL,
  [MFC_DTX05] [datetime] NULL,
  CONSTRAINT [PK_MANUFAC] PRIMARY KEY CLUSTERED ([MFC_CODE], [MFC_ORG]),
  CONSTRAINT [IX_MANUFAC] UNIQUE ([MFC_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[MANUFAC]
  ADD CONSTRAINT [FK_MANUFAC_ORG] FOREIGN KEY ([MFC_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO