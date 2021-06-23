CREATE TABLE [dbo].[VENDOR] (
  [VEN_ROWID] [int] IDENTITY,
  [VEN_CODE] [nvarchar](50) NOT NULL,
  [VEN_ORG] [nvarchar](30) NOT NULL,
  [VEN_DESC] [nvarchar](255) NULL,
  [VEN_NOTE] [ntext] NULL,
  [VEN_DATE] [datetime] NULL,
  [VEN_STATUS] [nvarchar](30) NULL,
  [VEN_TYPE] [nvarchar](30) NULL,
  [VEN_TYPE2] [nvarchar](30) NULL,
  [VEN_TYPE3] [nvarchar](30) NULL,
  [VEN_RSTATUS] [int] NULL,
  [VEN_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_ST_SUPP__CREUSER] DEFAULT (N'SA'),
  [VEN_CREDATE] [datetime] NULL CONSTRAINT [DF_ST_SUPP__CREDATE] DEFAULT (getdate()),
  [VEN_UPDUSER] [nvarchar](30) NULL,
  [VEN_UPDDATE] [datetime] NULL,
  [VEN_NOTUSED] [int] NULL,
  [VEN_ID] [nvarchar](50) NULL CONSTRAINT [DF_ST_SUPP__ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [VEN_TXT01] [nvarchar](30) NULL,
  [VEN_TXT02] [nvarchar](30) NULL,
  [VEN_TXT03] [nvarchar](30) NULL,
  [VEN_TXT04] [nvarchar](30) NULL,
  [VEN_TXT05] [nvarchar](30) NULL,
  [VEN_TXT06] [nvarchar](80) NULL,
  [VEN_TXT07] [nvarchar](80) NULL,
  [VEN_TXT08] [nvarchar](255) NULL,
  [VEN_TXT09] [nvarchar](255) NULL,
  [VEN_NTX01] [numeric](24, 6) NULL,
  [VEN_NTX02] [numeric](24, 6) NULL,
  [VEN_NTX03] [numeric](24, 6) NULL,
  [VEN_NTX04] [numeric](24, 6) NULL,
  [VEN_NTX05] [numeric](24, 6) NULL,
  [VEN_COM01] [ntext] NULL,
  [VEN_COM02] [ntext] NULL,
  [VEN_DTX01] [datetime] NULL,
  [VEN_DTX02] [datetime] NULL,
  [VEN_DTX03] [datetime] NULL,
  [VEN_DTX04] [datetime] NULL,
  [VEN_DTX05] [datetime] NULL,
  [VEN_CITY] [nvarchar](80) NULL,
  [VEN_STREET] [nvarchar](255) NULL,
  [VEN_STATE] [nvarchar](50) NULL,
  [VEN_ZIPCODE] [nvarchar](50) NULL,
  [VEN_COUNTY] [nvarchar](50) NULL,
  [VEN_COUNTRY] [nvarchar](50) NULL,
  [VEN_PHONE1] [nvarchar](255) NULL,
  [VEN_PHONE2] [nvarchar](255) NULL,
  [VEN_PHONE3] [nvarchar](255) NULL,
  [VEN_FAX] [nvarchar](255) NULL,
  [VEN_EMAIL] [nvarchar](255) NULL,
  [VEN_WWW] [nvarchar](255) NULL,
  [VEN_LINEOFBUSINESSID] [nvarchar](50) NULL,
  [VEN_REGON] [nvarchar](50) NULL,
  [VEN_NIP] [nvarchar](50) NULL,
  [VEN_CURR] [nvarchar](30) NULL,
  [VEN_PAYTYPEID] [int] NULL,
  [VEN_EMPCODE] [nvarchar](30) NULL,
  [VEN_LEGALFORM] [nvarchar](30) NULL,
  [VEN_PURCHPOOL] [nvarchar](30) NULL,
  [VEN_DESTINATIONCODE] [nvarchar](30) NULL,
  [VEN_DELIVERYTERM] [nvarchar](30) NULL,
  [VEN_AXAID] [int] NULL,
  [VEN_ISSERVICE] [int] NULL CONSTRAINT [DF_ST_SUPP_VEN_ISSERVICE] DEFAULT (0),
  [VEN_CONTACTPERSON] [nvarchar](80) NULL,
  [VEN_SAP_Active] [int] NULL,
  [VEN_SAP_LIFNR] [nvarchar](30) NULL,
  [VEN_SAP_LAND1] [nvarchar](30) NULL,
  [VEN_SAP_NAME1] [nvarchar](512) NULL,
  [VEN_SAP_MCOD1] [nvarchar](512) NULL,
  [VEN_SAP_NAME2] [nvarchar](512) NULL,
  [VEN_SAP_NAME3] [nvarchar](512) NULL,
  [VEN_SAP_NAME4] [nvarchar](512) NULL,
  [VEN_SAP_ORT01] [nvarchar](30) NULL,
  [VEN_SAP_ORT02] [nvarchar](30) NULL,
  [VEN_SAP_PFACH] [nvarchar](30) NULL,
  [VEN_SAP_PSTL2] [nvarchar](30) NULL,
  [VEN_SAP_PSTLZ] [nvarchar](30) NULL,
  [VEN_SAP_MCOD2] [nvarchar](30) NULL,
  [VEN_SAP_STRAS] [nvarchar](80) NULL,
  [VEN_SAP_ADRNR] [nvarchar](30) NULL,
  [VEN_SAP_MCOD3] [nvarchar](30) NULL,
  [VEN_SAP_ANRED] [nvarchar](30) NULL,
  [VEN_SAP_BEGRU] [nvarchar](30) NULL,
  [VEN_SAP_ERDAT] [datetime] NULL,
  [VEN_SAP_ERNAM] [nvarchar](30) NULL,
  [VEN_SAP_KTOKK] [nvarchar](30) NULL,
  [VEN_SAP_KUNNR] [nvarchar](30) NULL,
  [VEN_SAP_SPRAS] [nvarchar](30) NULL,
  [VEN_SAP_STCD1] [nvarchar](30) NULL,
  [VEN_SAP_STCD2] [nvarchar](30) NULL,
  CONSTRAINT [PK_ST_SUPP_1] PRIMARY KEY CLUSTERED ([VEN_CODE]),
  CONSTRAINT [IX_ST_suppliers] UNIQUE ([VEN_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[VENDOR]
  ADD CONSTRAINT [FK_ST_SUPP_PAYTYPE] FOREIGN KEY ([VEN_PAYTYPEID]) REFERENCES [dbo].[PAYTYPE] ([PAY_ROWID])
GO

ALTER TABLE [dbo].[VENDOR]
  ADD CONSTRAINT [FK_VENDOR_ORG] FOREIGN KEY ([VEN_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Dostawcy towaru', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'rowid', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_ROWID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nazwa', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Miasto', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_CITY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ulica', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_STREET'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Województwo', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_STATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_ZIPCODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Powiat', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_COUNTY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kraj', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_COUNTRY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Telefon', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_PHONE1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Telefon wew', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_PHONE2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Telefon kom', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_PHONE3'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Fax', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_FAX'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Adres email', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_EMAIL'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Adres www', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_WWW'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Branża', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_LINEOFBUSINESSID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'REGON', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_REGON'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'NIP', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_NIP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Podstawa wyceny', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_CURR'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Warunki płatności', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_PAYTYPEID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod pracownika', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_EMPCODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Forma prawna', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_LEGALFORM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Obszar zakupu', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_PURCHPOOL'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod przeznaczenia', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_DESTINATIONCODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Warunki dostawy', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_DELIVERYTERM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Czy to firma serwisowa', 'SCHEMA', N'dbo', 'TABLE', N'VENDOR', 'COLUMN', N'VEN_ISSERVICE'
GO