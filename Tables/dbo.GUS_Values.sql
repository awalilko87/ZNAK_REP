CREATE TABLE [dbo].[GUS_Values] (
  [GUS_rowid] [int] IDENTITY,
  [GUS_year] [int] NULL,
  [GUS_percent] [numeric](8, 3) NULL,
  [GUS_CREUSER] [nvarchar](80) NULL,
  [GUS_CREDATE] [datetime] NULL,
  [GUS_UPDUSER] [nvarchar](80) NULL,
  [GUS_UPDDATE] [datetime] NULL,
  [GUS_TXT01] [nvarchar](30) NULL,
  [GUS_TXT02] [nvarchar](30) NULL,
  [GUS_TXT03] [nvarchar](60) NULL,
  [GUS_TXT04] [nvarchar](60) NULL,
  [GUS_TXT05] [nvarchar](120) NULL,
  [GUS_TXT06] [nvarchar](120) NULL,
  [GUS_NTX01] [numeric](10, 3) NULL,
  [GUS_NTX02] [numeric](10, 3) NULL,
  [GUS_NTX03] [numeric](10, 3) NULL,
  [GUS_DTX01] [datetime] NULL,
  [GUS_DTX02] [datetime] NULL
)
ON [PRIMARY]
GO