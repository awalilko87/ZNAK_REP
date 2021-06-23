﻿CREATE TABLE [dbo].[IE2_KLASYFIKATOR5] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [Active] [int] NOT NULL,
  [GDLGRP] [nvarchar](30) NOT NULL,
  [GDLGRP_TXT] [nvarchar](512) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  [POSKI] [nvarchar](50) NULL,
  CONSTRAINT [PK_IE2_KLASYFIKATOR5] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO