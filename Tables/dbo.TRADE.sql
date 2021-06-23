﻿CREATE TABLE [dbo].[TRADE] (
  [TRD_ROWID] [int] IDENTITY,
  [TRD_CODE] [nvarchar](30) NOT NULL,
  [TRD_ORG] [nvarchar](30) NOT NULL,
  [TRD_MODULE] [nvarchar](30) NULL,
  [TRD_DESC] [nvarchar](80) NULL,
  [TRD_TYPE] [nvarchar](30) NULL,
  [TRD_STATUS] [nvarchar](30) NULL,
  [TRD_COMMENT] [ntext] NULL,
  [TRD_CREDATE] [datetime] NULL,
  [TRD_CREUSER] [nvarchar](30) NULL,
  [TRD_UPDDATE] [datetime] NULL,
  [TRD_UPDUSER] [nvarchar](30) NULL,
  [TRD_RSTATUS] [int] NULL,
  [TRD_NOTUSED] [int] NULL,
  [TRD_RATE] [numeric](38, 2) NULL,
  CONSTRAINT [PK_TRADE] PRIMARY KEY CLUSTERED ([TRD_CODE], [TRD_ORG]),
  CONSTRAINT [IX_TRADE] UNIQUE ([TRD_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRADE]
  ADD CONSTRAINT [FK_TRADE_ORG] FOREIGN KEY ([TRD_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO