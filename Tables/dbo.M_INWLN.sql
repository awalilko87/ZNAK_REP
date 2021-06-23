CREATE TABLE [dbo].[M_INWLN] (
  [rowguid] [uniqueidentifier] NOT NULL,
  [ASS_CODE] [nvarchar](60) NULL,
  [ASS_DESC] [nvarchar](80) NULL,
  [ASS_UOM] [nvarchar](10) NULL,
  [INW_QTY] [numeric](8, 2) NULL,
  [CREUSER] [nvarchar](60) NULL,
  [CREDATE] [datetime] NULL,
  [ASS_PRICE] [numeric](8, 2) NULL,
  CONSTRAINT [PK_M_INWLN] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
GO