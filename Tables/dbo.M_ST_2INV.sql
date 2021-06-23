CREATE TABLE [dbo].[M_ST_2INV] (
  [ROWGUID] [uniqueidentifier] NULL,
  [ROWID] [int] NOT NULL,
  [SIL_CODE] [nvarchar](60) NULL,
  [SIL_MAG] [nvarchar](80) NULL,
  [SIL_PLACE] [nvarchar](80) NULL,
  [SIN_STATUS] [nvarchar](60) NULL,
  [SIL_ASSCODE] [nvarchar](60) NULL,
  [SIL_ASSDESC] [nvarchar](80) NULL,
  [SIL_OLDQTY] [numeric](17) NULL,
  [SIL_ORG] [nvarchar](60) NULL,
  CONSTRAINT [PK_M_ST_2INV] PRIMARY KEY NONCLUSTERED ([ROWID])
)
ON [PRIMARY]
GO