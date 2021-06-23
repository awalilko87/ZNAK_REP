﻿CREATE TABLE [dbo].[INVTSK] (
  [ITS_ROWID] [int] IDENTITY,
  [ITS_CODE] [nvarchar](30) NOT NULL,
  [ITS_ORG] [nvarchar](30) NOT NULL,
  [ITS_DESC] [nvarchar](80) NULL,
  [ITS_DATE] [datetime] NULL,
  [ITS_STATUS] [nvarchar](30) NULL,
  [ITS_TYPE] [nvarchar](30) NULL,
  [ITS_TYPE2] [nvarchar](30) NULL,
  [ITS_TYPE3] [nvarchar](30) NULL,
  [ITS_RSTATUS] [int] NULL,
  [ITS_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_ITS_ITS_CREUSER] DEFAULT (N'SA'),
  [ITS_CREDATE] [datetime] NULL CONSTRAINT [DF_ITS__CREDATE] DEFAULT (getdate()),
  [ITS_UPDUSER] [nvarchar](30) NULL,
  [ITS_UPDDATE] [datetime] NULL,
  [ITS_NOTUSED] [int] NULL CONSTRAINT [DF_ITS_ITS_NOTUSED] DEFAULT (0),
  [ITS_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_ITS_ITS_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [ITS_TXT01] [nvarchar](30) NULL,
  [ITS_TXT02] [nvarchar](30) NULL,
  [ITS_TXT03] [nvarchar](30) NULL,
  [ITS_TXT04] [nvarchar](30) NULL,
  [ITS_TXT05] [nvarchar](30) NULL,
  [ITS_TXT06] [nvarchar](80) NULL,
  [ITS_TXT07] [nvarchar](80) NULL,
  [ITS_TXT08] [nvarchar](255) NULL,
  [ITS_TXT09] [nvarchar](255) NULL,
  [ITS_TXT10] [nvarchar](80) NULL,
  [ITS_TXT11] [nvarchar](80) NULL,
  [ITS_TXT12] [nvarchar](80) NULL,
  [ITS_NTX01] [numeric](24, 6) NULL,
  [ITS_NTX02] [numeric](24, 6) NULL,
  [ITS_NTX03] [numeric](24, 6) NULL,
  [ITS_NTX04] [numeric](24, 6) NULL,
  [ITS_NTX05] [numeric](24, 6) NULL,
  [ITS_COM01] [ntext] NULL,
  [ITS_COM02] [ntext] NULL,
  [ITS_DTX01] [datetime] NULL,
  [ITS_DTX02] [datetime] NULL,
  [ITS_DTX03] [datetime] NULL,
  [ITS_DTX04] [datetime] NULL,
  [ITS_DTX05] [datetime] NULL,
  [ITS_NOTE] [nvarchar](255) NULL,
  [ITS_COSTCODEID] [int] NULL,
  [ITS_SAP_PSPNR] [nvarchar](30) NULL,
  [ITS_SAP_POST1] [nvarchar](512) NULL,
  [ITS_SAP_POSID] [nvarchar](30) NULL,
  [ITS_SAP_OBJNR] [nvarchar](30) NULL,
  [ITS_SAP_ERNAM] [nvarchar](30) NULL,
  [ITS_SAP_ERDAT] [datetime] NULL,
  [ITS_SAP_AENAM] [nvarchar](30) NULL,
  [ITS_SAP_AEDAT] [datetime] NULL,
  [ITS_SAP_STSPR] [nvarchar](30) NULL,
  [ITS_SAP_VERNR] [nvarchar](30) NULL,
  [ITS_SAP_VERNA] [nvarchar](128) NULL,
  [ITS_SAP_ASTNR] [nvarchar](30) NULL,
  [ITS_SAP_ASTNA] [nvarchar](30) NULL,
  [ITS_SAP_VBUKR] [nvarchar](30) NULL,
  [ITS_SAP_VGSBR] [nvarchar](30) NULL,
  [ITS_SAP_VKOKR] [nvarchar](30) NULL,
  [ITS_SAP_PRCTR] [nvarchar](30) NULL,
  [ITS_SAP_PWHIE] [nvarchar](30) NULL,
  [ITS_SAP_ZUORD] [nvarchar](30) NULL,
  [ITS_SAP_PLFAZ] [datetime] NULL,
  [ITS_SAP_PLSEZ] [datetime] NULL,
  [ITS_SAP_KALID] [nvarchar](30) NULL,
  [ITS_SAP_VGPLF] [nvarchar](30) NULL,
  [ITS_SAP_EWPLF] [nvarchar](30) NULL,
  [ITS_SAP_ZTEHT] [nvarchar](30) NULL,
  [ITS_SAP_PLNAW] [nvarchar](30) NULL,
  [ITS_SAP_PROFL] [nvarchar](30) NULL,
  [ITS_SAP_BPROF] [nvarchar](30) NULL,
  [ITS_SAP_TXTSP] [nvarchar](30) NULL,
  [ITS_SAP_KOSTL] [nvarchar](30) NULL,
  [ITS_SAP_KTRG] [nvarchar](30) NULL,
  [ITS_SAP_SCPRF] [nvarchar](30) NULL,
  [ITS_SAP_IMPRF] [nvarchar](30) NULL,
  [ITS_SAP_PPROF] [nvarchar](30) NULL,
  [ITS_SAP_ZZKIER] [nvarchar](30) NULL,
  [ITS_SAP_STUFE] [nvarchar](30) NULL,
  [ITS_SAP_BANFN] [nvarchar](30) NULL,
  [ITS_SAP_BNFPO] [nvarchar](30) NULL,
  [ITS_SAP_ZEBKN] [nvarchar](30) NULL,
  [ITS_SAP_EBELN] [nvarchar](30) NULL,
  [ITS_SAP_EBELP] [nvarchar](30) NULL,
  [ITS_SAP_ZEKKN] [nvarchar](30) NULL,
  [ITS_SAP_ACTIVE] [int] NULL,
  [ITS_SAP_PSPHI] [nvarchar](30) NULL,
  [ITS_SAP_POSKI] [nvarchar](50) NULL,
  CONSTRAINT [PK_ITS_1] PRIMARY KEY CLUSTERED ([ITS_CODE]),
  CONSTRAINT [UQ_ITS] UNIQUE ([ITS_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [PG_20161125]
  ON [dbo].[INVTSK] ([ITS_SAP_POSID])
  INCLUDE ([ITS_ROWID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[INVTSK]
  ADD CONSTRAINT [FK_ITS_COSTCODE] FOREIGN KEY ([ITS_COSTCODEID]) REFERENCES [dbo].[COSTCODE] ([CCD_ROWID])
GO

ALTER TABLE [dbo].[INVTSK]
  ADD CONSTRAINT [FK_ITS_ORG] FOREIGN KEY ([ITS_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO