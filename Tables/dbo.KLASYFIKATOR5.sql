CREATE TABLE [dbo].[KLASYFIKATOR5] (
  [KL5_ROWID] [int] IDENTITY,
  [KL5_CODE] [nvarchar](30) NOT NULL,
  [KL5_ORG] [nvarchar](30) NOT NULL,
  [KL5_DESC] [nvarchar](80) NULL,
  [KL5_CREUSER] [nvarchar](30) NULL,
  [KL5_CREDATE] [datetime] NULL,
  [KL5_UPDUSER] [nvarchar](30) NULL,
  [KL5_UPDDATE] [datetime] NULL,
  [KL5_NOTUSED] [int] NULL,
  [KL5_SAP_GDLGRP] [nvarchar](30) NULL,
  [KL5_SAP_GDLGRP_TXT] [nvarchar](512) NULL,
  [KL5_SAP_ACTIVE] [int] NULL,
  CONSTRAINT [PK_KLASYFIKATOR5] PRIMARY KEY CLUSTERED ([KL5_CODE], [KL5_ORG]),
  CONSTRAINT [IX_KLASYFIKATOR5] UNIQUE ([KL5_ROWID])
)
ON [PRIMARY]
GO

CREATE INDEX [KL5_CODE]
  ON [dbo].[KLASYFIKATOR5] ([KL5_CODE])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[KLASYFIKATOR5]
  ADD CONSTRAINT [FK_KLASYFIKATOR5_ORG] FOREIGN KEY ([KL5_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Siedziba', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_ORG'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzył', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_CREUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzone', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_CREDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikował', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_UPDUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikowane', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_UPDDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nieaktywne', 'SCHEMA', N'dbo', 'TABLE', N'KLASYFIKATOR5', 'COLUMN', N'KL5_NOTUSED'
GO