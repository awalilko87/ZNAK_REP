CREATE TABLE [dbo].[DOCENTITIES] (
  [ROWID] [int] IDENTITY,
  [DAE_DOCUMENT] [nvarchar](50) NOT NULL,
  [DAE_ENTITY] [nvarchar](4) NOT NULL,
  [DAE_CODE] [nvarchar](50) NOT NULL,
  [DAE_TYPE] [nvarchar](30) NULL,
  [DAE_TYPE2] [nvarchar](30) NULL,
  [DAE_TYPE3] [nvarchar](30) NULL,
  [DAE_RSTATUS] [int] NULL,
  [DAE_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_DAE_DAE_CREUSER] DEFAULT (N'SA'),
  [DAE_CREDATE] [datetime] NULL CONSTRAINT [DF_DAE__CREDATE] DEFAULT (getdate()),
  [DAE_UPDUSER] [nvarchar](30) NULL,
  [DAE_UPDDATE] [datetime] NULL,
  [DAE_NOTUSED] [int] NULL CONSTRAINT [DF_DAE_DAE_NOTUSED] DEFAULT (0),
  [DAE_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_DAE_DAE_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [DAE_COPYTOWO] [int] NULL,
  [DAE_COPYTOPO] [int] NULL,
  [DAE_SQLIDENTITY] [int] NULL,
  [DAE_MN] [int] NULL,
  [DAE_TXT01] [nvarchar](30) NULL,
  [DAE_TXT02] [nvarchar](30) NULL,
  [DAE_TXT03] [nvarchar](30) NULL,
  [DAE_TXT04] [nvarchar](30) NULL,
  [DAE_TXT05] [nvarchar](30) NULL,
  [DAE_TXT06] [nvarchar](80) NULL,
  [DAE_TXT07] [nvarchar](80) NULL,
  [DAE_TXT08] [nvarchar](255) NULL,
  [DAE_TXT09] [nvarchar](255) NULL,
  [DAE_TXT10] [nvarchar](80) NULL,
  [DAE_TXT11] [nvarchar](80) NULL,
  [DAE_TXT12] [nvarchar](80) NULL,
  [DAE_NTX01] [numeric](24, 6) NULL,
  [DAE_NTX02] [numeric](24, 6) NULL,
  [DAE_NTX03] [numeric](24, 6) NULL,
  [DAE_NTX04] [numeric](24, 6) NULL,
  [DAE_NTX05] [numeric](24, 6) NULL,
  [DAE_COM01] [ntext] NULL,
  [DAE_COM02] [ntext] NULL,
  [DAE_DTX01] [datetime] NULL,
  [DAE_DTX02] [datetime] NULL,
  [DAE_DTX03] [datetime] NULL,
  [DAE_DTX04] [datetime] NULL,
  [DAE_DTX05] [datetime] NULL,
  CONSTRAINT [PK_DAE] PRIMARY KEY CLUSTERED ([DAE_DOCUMENT], [DAE_ENTITY], [DAE_CODE]),
  CONSTRAINT [UQ_DAE] UNIQUE ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DOCENTITIES]
  ADD CONSTRAINT [FK_DOCENTITIES_SYFiles] FOREIGN KEY ([DAE_DOCUMENT]) REFERENCES [dbo].[SYFiles] ([FileID2]) ON DELETE CASCADE
GO