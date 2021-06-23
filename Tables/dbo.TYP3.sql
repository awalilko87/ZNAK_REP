﻿CREATE TABLE [dbo].[TYP3] (
  [TYP3_ROWID] [int] IDENTITY,
  [TYP3_TYP2ID] [int] NOT NULL,
  [TYP3_CODE] [nvarchar](30) NOT NULL,
  [TYP3_DESC] [nvarchar](80) NULL,
  [TYP3_ORDER] [int] NULL,
  CONSTRAINT [PK_TYP3] PRIMARY KEY CLUSTERED ([TYP3_TYP2ID], [TYP3_CODE]),
  CONSTRAINT [IX_TYP3] UNIQUE ([TYP3_ROWID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TYP3]
  ADD CONSTRAINT [FK_TYP3_TYP2] FOREIGN KEY ([TYP3_TYP2ID]) REFERENCES [dbo].[TYP2] ([TYP2_ROWID])
GO