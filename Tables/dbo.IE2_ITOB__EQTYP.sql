﻿CREATE TABLE [dbo].[IE2_ITOB__EQTYP] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [EQTYP] [nvarchar](30) NULL,
  [TYPTX] [nvarchar](30) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  CONSTRAINT [PK_ITOB__EQTYP] PRIMARY KEY NONCLUSTERED ([ROWID])
)
ON [PRIMARY]
GO