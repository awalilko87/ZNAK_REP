CREATE TABLE [dbo].[ASSET] (
  [AST_ROWID] [int] IDENTITY,
  [AST_CODE] [nvarchar](30) NOT NULL,
  [AST_SUBCODE] [nvarchar](10) NOT NULL CONSTRAINT [DF__ASSET__AST_SUBCO__1EBB33CF] DEFAULT ('0000'),
  [AST_BARCODE] [nvarchar](30) NOT NULL,
  [AST_ORG] [nvarchar](30) NOT NULL,
  [AST_CCDID] [int] NULL,
  [AST_CCTID] [int] NOT NULL,
  [AST_DESC] [nvarchar](120) NULL,
  [AST_NOTE] [ntext] NULL,
  [AST_DATE] [datetime] NULL,
  [AST_STATUS] [nvarchar](30) NULL,
  [AST_TYPE] [nvarchar](30) NULL,
  [AST_TYPE2] [nvarchar](30) NULL,
  [AST_TYPE3] [nvarchar](30) NULL,
  [AST_RSTATUS] [int] NULL,
  [AST_CREUSER] [nvarchar](30) NULL,
  [AST_CREDATE] [datetime] NULL CONSTRAINT [DF_ASSET_CREDATE] DEFAULT (getdate()),
  [AST_UPDUSER] [nvarchar](30) NULL,
  [AST_UPDDATE] [datetime] NULL,
  [AST_NOTUSED] [int] NULL,
  [AST_ID] [nvarchar](50) NULL CONSTRAINT [DF_ASSET_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [AST_TXT01] [nvarchar](30) NULL,
  [AST_TXT02] [nvarchar](30) NULL,
  [AST_TXT03] [nvarchar](30) NULL,
  [AST_TXT04] [nvarchar](30) NULL,
  [AST_TXT05] [nvarchar](30) NULL,
  [AST_TXT06] [nvarchar](80) NULL,
  [AST_TXT07] [nvarchar](80) NULL,
  [AST_TXT08] [nvarchar](255) NULL,
  [AST_TXT09] [nvarchar](255) NULL,
  [AST_NTX01] [numeric](24, 6) NULL,
  [AST_NTX02] [numeric](24, 6) NULL,
  [AST_NTX03] [numeric](24, 6) NULL,
  [AST_NTX04] [numeric](24, 6) NULL,
  [AST_NTX05] [numeric](24, 6) NULL,
  [AST_COM01] [ntext] NULL,
  [AST_COM02] [ntext] NULL,
  [AST_DTX01] [datetime] NULL,
  [AST_DTX02] [datetime] NULL,
  [AST_DTX03] [datetime] NULL,
  [AST_DTX04] [datetime] NULL,
  [AST_DTX05] [datetime] NULL,
  [AST_BUYVALUE] [numeric](30, 2) NULL,
  [AST_TEXT1] [nvarchar](max) NULL,
  [AST_TEXT2] [nvarchar](max) NULL,
  [AST_TEXT3] [nvarchar](max) NULL,
  [AST_PSP] [nvarchar](50) NULL,
  [AST_SAP_Active] [int] NULL,
  [AST_SAP_BUKRS] [nvarchar](30) NULL,
  [AST_SAP_ANLN1] [nvarchar](30) NULL,
  [AST_SAP_ANLN2] [nvarchar](30) NULL,
  [AST_SAP_ANLKL] [nvarchar](30) NULL,
  [AST_SAP_GEGST] [nvarchar](30) NULL,
  [AST_SAP_ERNAM] [nvarchar](30) NULL,
  [AST_SAP_ERDAT] [datetime] NULL,
  [AST_SAP_AENAM] [nvarchar](30) NULL,
  [AST_SAP_AEDAT] [nvarchar](30) NULL,
  [AST_SAP_KTOGR] [nvarchar](30) NULL,
  [AST_SAP_ANLTP] [nvarchar](30) NULL,
  [AST_SAP_ZUJHR] [nvarchar](30) NULL,
  [AST_SAP_ZUPER] [nvarchar](30) NULL,
  [AST_SAP_ZUGDT] [datetime] NULL,
  [AST_SAP_AKTIV] [datetime] NULL,
  [AST_SAP_ABGDT] [datetime] NULL,
  [AST_SAP_DEAKT] [datetime] NULL,
  [AST_SAP_GPLAB] [datetime] NULL,
  [AST_SAP_BSTDT] [datetime] NULL,
  [AST_SAP_ORD41] [nvarchar](30) NULL,
  [AST_SAP_ORD42] [nvarchar](30) NULL,
  [AST_SAP_ORD43] [nvarchar](30) NULL,
  [AST_SAP_ORD44] [nvarchar](30) NULL,
  [AST_SAP_ANEQK] [nvarchar](30) NULL,
  [AST_SAP_LIFNR] [nvarchar](30) NULL,
  [AST_SAP_LAND1] [nvarchar](30) NULL,
  [AST_SAP_LIEFE] [nvarchar](30) NULL,
  [AST_SAP_HERST] [nvarchar](30) NULL,
  [AST_SAP_EIGKZ] [nvarchar](30) NULL,
  [AST_SAP_URWRT] [nvarchar](30) NULL,
  [AST_SAP_ANTEI] [nvarchar](30) NULL,
  [AST_SAP_MEINS] [nvarchar](30) NULL,
  [AST_SAP_MENGE] [nvarchar](30) NULL,
  [AST_SAP_VMGLI] [nvarchar](30) NULL,
  [AST_SAP_XVRMW] [nvarchar](30) NULL,
  [AST_SAP_WRTMA] [nvarchar](30) NULL,
  [AST_SAP_EHWRT] [nvarchar](30) NULL,
  [AST_SAP_STADT] [nvarchar](30) NULL,
  [AST_SAP_GRUFL] [nvarchar](30) NULL,
  [AST_SAP_VBUND] [nvarchar](30) NULL,
  [AST_SAP_SPRAS] [nvarchar](30) NULL,
  [AST_SAP_TXT50] [nvarchar](80) NULL,
  [AST_SAP_KOSTL] [nvarchar](30) NULL,
  [AST_SAP_WERKS] [nvarchar](30) NULL,
  [AST_SAP_GSBER] [nvarchar](30) NULL,
  [AST_SAP_POSNR] [nvarchar](30) NULL,
  [AST_SAP_GDLGRP] [nvarchar](30) NULL,
  [AST_SAP_DOC_IDENT] [nvarchar](30) NULL,
  [AST_SAP_DOC_NUM] [nvarchar](30) NULL,
  [AST_SAP_DOC_YEAR] [int] NULL,
  [AST_SAP_DATA_WYST] [datetime] NULL,
  [AST_SAP_OSOBA_WYST] [nvarchar](30) NULL,
  [AST_KL5ID] [int] NULL,
  [AST_OBJGROUPID] [int] NULL,
  [AST_ANLUE] [nvarchar](30) NULL,
  [AST_DONIESIENIE] [tinyint] NULL CONSTRAINT [DF_AST_DONIESIENIE] DEFAULT (0),
  [AST_SAP_NDJARPER] [nvarchar](100) NULL,
  [AST_INITIALVALUE] [numeric](16, 2) NULL,
  [AST_NETVALUE] [numeric](16, 2) NULL,
  [AST_AMORTIZATIONPERIOD] [nvarchar](30) NULL,
  [AST_ACTVALUEDATE] [datetime] NULL,
  [AST_SAP_STATUS_INW] [nvarchar](30) NULL,
  CONSTRAINT [PK_ASSET] PRIMARY KEY CLUSTERED ([AST_CODE], [AST_SUBCODE], [AST_ORG]),
  CONSTRAINT [UQ_ASSET] UNIQUE ([AST_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [AST_CCDID]
  ON [dbo].[ASSET] ([AST_CCDID])
  ON [PRIMARY]
GO

CREATE INDEX [AST_CODE]
  ON [dbo].[ASSET] ([AST_CODE])
  ON [PRIMARY]
GO

CREATE INDEX [AST_CODE_SUBCODE]
  ON [dbo].[ASSET] ([AST_CODE], [AST_SUBCODE])
  ON [PRIMARY]
GO

CREATE INDEX [AST_SUBCODE]
  ON [dbo].[ASSET] ([AST_SUBCODE])
  ON [PRIMARY]
GO

CREATE INDEX [AST_TYPE]
  ON [dbo].[ASSET] ([AST_TYPE])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_AST02]
  ON [dbo].[ASSET] ([AST_CCDID], [AST_KL5ID])
  INCLUDE ([AST_ROWID], [AST_CODE], [AST_SUBCODE], [AST_DESC])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_AST03]
  ON [dbo].[ASSET] ([AST_SAP_DEAKT], [AST_CCDID], [AST_KL5ID])
  INCLUDE ([AST_ROWID], [AST_CODE], [AST_SUBCODE], [AST_NOTUSED], [AST_SAP_ANLKL])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_AST04]
  ON [dbo].[ASSET] ([AST_DONIESIENIE])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_AST05]
  ON [dbo].[ASSET] ([AST_CCDID])
  ON [PRIMARY]
GO

CREATE INDEX [TestowyIndex]
  ON [dbo].[ASSET] ([AST_SUBCODE], [AST_SAP_Active])
  INCLUDE ([AST_ROWID], [AST_CODE], [AST_BARCODE], [AST_CCDID], [AST_DESC], [AST_STATUS], [AST_ID], [AST_SAP_ANLKL], [AST_SAP_ERNAM], [AST_SAP_ERDAT], [AST_SAP_ZUJHR], [AST_SAP_AKTIV], [AST_SAP_HERST], [AST_SAP_TXT50], [AST_SAP_GDLGRP], [AST_OBJGROUPID], [AST_ANLUE], [AST_SAP_NDJARPER], [AST_NETVALUE], [AST_AMORTIZATIONPERIOD], [AST_ACTVALUEDATE])
  ON [PRIMARY]
GO

ALTER INDEX [TestowyIndex] ON [dbo].[ASSET] DISABLE
GO

ALTER TABLE [dbo].[ASSET]
  ADD CONSTRAINT [FK_ASSET_COSTCLASSIFICATION] FOREIGN KEY ([AST_CCTID]) REFERENCES [dbo].[COSTCENTER] ([CCT_ROWID])
GO

ALTER TABLE [dbo].[ASSET]
  ADD CONSTRAINT [FK_ASSET_COSTCODE] FOREIGN KEY ([AST_CCDID]) REFERENCES [dbo].[COSTCODE] ([CCD_ROWID])
GO