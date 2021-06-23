CREATE TABLE [dbo].[STA] (
  [STA_ENTITY] [nvarchar](10) NOT NULL,
  [STA_CODE] [nvarchar](30) NOT NULL,
  [STA_DESC] [nvarchar](80) NULL,
  [STA_CLASS] [nvarchar](30) NOT NULL CONSTRAINT [DF_STA_STA_CLASS] DEFAULT ('*'),
  [STA_TYPE] [nvarchar](30) NOT NULL CONSTRAINT [DF_STA_STA_TYPE] DEFAULT (N'*'),
  [STA_ORG] [nvarchar](30) NOT NULL CONSTRAINT [DF_STA_STA_ORG] DEFAULT (N'*'),
  [STA_ORDER] [int] NULL,
  [STA_DEFAULT] [int] NULL CONSTRAINT [DF_STA_STA_DEFAULT] DEFAULT (0),
  [STA_RFLAG] [int] NOT NULL CONSTRAINT [DF_STA_STA_RFLAG] DEFAULT (0),
  [STA_AXCODE] [nvarchar](30) NULL,
  [STA_D7CODE] [nvarchar](30) NULL,
  [STA_ICON] [nvarchar](255) NULL,
  [STA_NOTUSED] [int] NOT NULL CONSTRAINT [DF_STA_STA_NOTUSED] DEFAULT (0),
  CONSTRAINT [PK_STA_1] PRIMARY KEY CLUSTERED ([STA_ENTITY], [STA_CODE])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[STA]
  ADD CONSTRAINT [FK_STA_ENT] FOREIGN KEY ([STA_ENTITY]) REFERENCES [dbo].[ENT] ([ENT_CODE])
GO

ALTER TABLE [dbo].[STA]
  ADD CONSTRAINT [FK_STA_ORG] FOREIGN KEY ([STA_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Encja', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_ENTITY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Typ', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_TYPE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Sortowanie', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_ORDER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Domyślny', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_DEFAULT'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Rflag', 'SCHEMA', N'dbo', 'TABLE', N'STA', 'COLUMN', N'STA_RFLAG'
GO