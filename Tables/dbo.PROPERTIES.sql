﻿CREATE TABLE [dbo].[PROPERTIES] (
  [PRO_CODE] [nvarchar](30) NOT NULL,
  [PRO_TYPE] [nvarchar](4) NULL,
  [PRO_TEXT] [nvarchar](80) NULL,
  [PRO_MIN] [nvarchar](40) NULL,
  [PRO_MAX] [nvarchar](40) NULL,
  [PRO_UPDATECOUNT] [numeric](38) NULL DEFAULT (0),
  [PRO_CREATED] [datetime] NULL DEFAULT (getdate()),
  [PRO_UPDATED] [datetime] NULL DEFAULT (getdate()),
  [PRO_ROWID] [int] IDENTITY,
  [PRO_TYPE_DESC] [nvarchar](80) NULL,
  [PRO_SQLTYPE] [nvarchar](80) NULL,
  [PRO_SQLSIZE] [nvarchar](80) NULL,
  [PRO_NOTUSED] [smallint] NULL,
  [PRO_PM_KLASA] [nvarchar](30) NULL,
  [PRO_PM_CECHA] [nvarchar](30) NULL,
  CONSTRAINT [PRIK_PRO] PRIMARY KEY NONCLUSTERED ([PRO_CODE]),
  CONSTRAINT [UNQSQL_PRO] UNIQUE CLUSTERED ([PRO_ROWID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROPERTIES] WITH NOCHECK
  ADD CONSTRAINT [CHK1_PRO] CHECK ([pro_type]=N'DTX' OR [pro_type]=N'NTX' OR [pro_type]=N'TXT' OR [pro_type]=N'DDL')
GO

ALTER TABLE [dbo].[PROPERTIES] WITH NOCHECK
  ADD CONSTRAINT [NN01_PRO] CHECK ([PRO_TYPE] IS NOT NULL)
GO

ALTER TABLE [dbo].[PROPERTIES] WITH NOCHECK
  ADD CONSTRAINT [NN02_PRO] CHECK ([PRO_TEXT] IS NOT NULL)
GO