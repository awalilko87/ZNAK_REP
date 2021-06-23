CREATE TABLE [dbo].[PO_BIZ_DEC_ITEMS] (
  [BII_ROWID] [int] IDENTITY,
  [BII_BIZID] [int] NULL,
  [BII_STNID] [int] NULL,
  [BII_OBJID] [int] NULL,
  [BII_ASSET] [nvarchar](30) NULL,
  [BII_OBG] [nvarchar](10) NULL,
  [BII_STSID] [int] NULL,
  [BII_PRICE] [numeric](30, 6) NULL,
  [BII_NETTO] [numeric](24, 6) NULL,
  [BII_WART_ODSP] [numeric](24, 6) NULL
)
ON [PRIMARY]
GO