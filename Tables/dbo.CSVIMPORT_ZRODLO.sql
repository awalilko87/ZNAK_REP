﻿CREATE TABLE [dbo].[CSVIMPORT_ZRODLO] (
  [ROWID] [int] IDENTITY,
  [KodZrodla] [nvarchar](50) NOT NULL,
  [NazwaZrodla] [nvarchar](200) NULL,
  CONSTRAINT [PK_CSVIMPORT_Zrodlo1] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO