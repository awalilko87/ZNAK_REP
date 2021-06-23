CREATE TABLE [dbo].[PSP] (
  [PSP_ROWID] [int] IDENTITY,
  [PSP_CODE] [nvarchar](30) NOT NULL,
  [PSP_ORG] [nvarchar](30) NOT NULL,
  [PSP_DESC] [nvarchar](80) NULL,
  [PSP_DATE] [datetime] NULL,
  [PSP_STATUS] [nvarchar](30) NULL,
  [PSP_TYPE] [nvarchar](30) NULL,
  [PSP_TYPE2] [nvarchar](30) NULL,
  [PSP_TYPE3] [nvarchar](30) NULL,
  [PSP_RSTATUS] [int] NULL,
  [PSP_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_PSP_PSP_CREUSER] DEFAULT (N'SA'),
  [PSP_CREDATE] [datetime] NULL CONSTRAINT [DF_PSP__CREDATE] DEFAULT (getdate()),
  [PSP_UPDUSER] [nvarchar](30) NULL,
  [PSP_UPDDATE] [datetime] NULL,
  [PSP_NOTUSED] [int] NULL CONSTRAINT [DF_PSP_PSP_NOTUSED] DEFAULT (0),
  [PSP_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_PSP_PSP_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [PSP_TXT01] [nvarchar](30) NULL,
  [PSP_TXT02] [nvarchar](30) NULL,
  [PSP_TXT03] [nvarchar](30) NULL,
  [PSP_TXT04] [nvarchar](30) NULL,
  [PSP_TXT05] [nvarchar](30) NULL,
  [PSP_TXT06] [nvarchar](80) NULL,
  [PSP_TXT07] [nvarchar](80) NULL,
  [PSP_TXT08] [nvarchar](255) NULL,
  [PSP_TXT09] [nvarchar](255) NULL,
  [PSP_TXT10] [nvarchar](80) NULL,
  [PSP_TXT11] [nvarchar](80) NULL,
  [PSP_TXT12] [nvarchar](80) NULL,
  [PSP_NTX01] [numeric](24, 6) NULL,
  [PSP_NTX02] [numeric](24, 6) NULL,
  [PSP_NTX03] [numeric](24, 6) NULL,
  [PSP_NTX04] [numeric](24, 6) NULL,
  [PSP_NTX05] [numeric](24, 6) NULL,
  [PSP_COM01] [ntext] NULL,
  [PSP_COM02] [ntext] NULL,
  [PSP_DTX01] [datetime] NULL,
  [PSP_DTX02] [datetime] NULL,
  [PSP_DTX03] [datetime] NULL,
  [PSP_DTX04] [datetime] NULL,
  [PSP_DTX05] [datetime] NULL,
  [PSP_NOTE] [nvarchar](255) NULL,
  [PSP_COSTCODEID] [int] NULL,
  [PSP_ITSID] [int] NULL,
  [PSP_SAP_PSPNR] [nvarchar](30) NULL,
  [PSP_SAP_POST1] [nvarchar](512) NULL,
  [PSP_SAP_POSID] [nvarchar](30) NULL,
  [PSP_SAP_OBJNR] [nvarchar](30) NULL,
  [PSP_SAP_ERNAM] [nvarchar](30) NULL,
  [PSP_SAP_ERDAT] [datetime] NULL,
  [PSP_SAP_AENAM] [nvarchar](30) NULL,
  [PSP_SAP_AEDAT] [datetime] NULL,
  [PSP_SAP_STSPR] [nvarchar](30) NULL,
  [PSP_SAP_VERNR] [nvarchar](30) NULL,
  [PSP_SAP_VERNA] [nvarchar](128) NULL,
  [PSP_SAP_ASTNR] [nvarchar](30) NULL,
  [PSP_SAP_ASTNA] [nvarchar](30) NULL,
  [PSP_SAP_VBUKR] [nvarchar](30) NULL,
  [PSP_SAP_VGSBR] [nvarchar](30) NULL,
  [PSP_SAP_VKOKR] [nvarchar](30) NULL,
  [PSP_SAP_PRCTR] [nvarchar](30) NULL,
  [PSP_SAP_PWHIE] [nvarchar](30) NULL,
  [PSP_SAP_ZUORD] [nvarchar](30) NULL,
  [PSP_SAP_PLFAZ] [datetime] NULL,
  [PSP_SAP_PLSEZ] [datetime] NULL,
  [PSP_SAP_KALID] [nvarchar](30) NULL,
  [PSP_SAP_VGPLF] [nvarchar](30) NULL,
  [PSP_SAP_EWPLF] [nvarchar](30) NULL,
  [PSP_SAP_ZTEHT] [nvarchar](30) NULL,
  [PSP_SAP_PLNAW] [nvarchar](30) NULL,
  [PSP_SAP_PROFL] [nvarchar](30) NULL,
  [PSP_SAP_BPROF] [nvarchar](30) NULL,
  [PSP_SAP_TXTSP] [nvarchar](30) NULL,
  [PSP_SAP_KOSTL] [nvarchar](30) NULL,
  [PSP_SAP_KTRG] [nvarchar](30) NULL,
  [PSP_SAP_SCPRF] [nvarchar](30) NULL,
  [PSP_SAP_IMPRF] [nvarchar](30) NULL,
  [PSP_SAP_PPROF] [nvarchar](30) NULL,
  [PSP_SAP_ZZKIER] [nvarchar](30) NULL,
  [PSP_SAP_STUFE] [nvarchar](30) NULL,
  [PSP_SAP_BANFN] [nvarchar](30) NULL,
  [PSP_SAP_BNFPO] [nvarchar](30) NULL,
  [PSP_SAP_ZEBKN] [nvarchar](30) NULL,
  [PSP_SAP_EBELN] [nvarchar](30) NULL,
  [PSP_SAP_EBELP] [nvarchar](30) NULL,
  [PSP_SAP_ZEKKN] [nvarchar](30) NULL,
  [PSP_SAP_ACTIVE] [int] NULL,
  [PSP_SAP_PSPHI] [nvarchar](30) NULL,
  CONSTRAINT [UQ_PSP] UNIQUE ([PSP_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [E2IDX_PSP01]
  ON [dbo].[PSP] ([PSP_ITSID])
  ON [PRIMARY]
GO

CREATE INDEX [PG_20161125]
  ON [dbo].[PSP] ([PSP_SAP_POSID])
  INCLUDE ([PSP_CODE])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[PSP]
  ADD CONSTRAINT [FK_PSP_COSTCODE] FOREIGN KEY ([PSP_COSTCODEID]) REFERENCES [dbo].[COSTCODE] ([CCD_ROWID])
GO

ALTER TABLE [dbo].[PSP]
  ADD CONSTRAINT [FK_PSP_ORG] FOREIGN KEY ([PSP_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO