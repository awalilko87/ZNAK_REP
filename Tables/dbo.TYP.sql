CREATE TABLE [dbo].[TYP] (
  [TYP_ROWID] [int] IDENTITY,
  [TYP_ENTITY] [nvarchar](10) NOT NULL,
  [TYP_CODE] [nvarchar](30) NOT NULL,
  [TYP_DESC] [nvarchar](80) NULL,
  [TYP_ORG] [nvarchar](30) NOT NULL CONSTRAINT [DF_TYP_TYP_ORG] DEFAULT (N'*'),
  [TYP_ORDER] [int] NULL,
  [TYP_DEFAULT] [int] NULL CONSTRAINT [DF_TYP_TYP_DEFAULT] DEFAULT (0),
  [TYP_CLASS] [nvarchar](30) NULL,
  [TYP_WRKCTRJOB] [nchar](10) NULL,
  [TYP_PRODID] [nvarchar](30) NULL,
  [TYP_JOBID] [nvarchar](30) NULL,
  [TYP_PRZESTLINII] [int] NULL,
  [TYP_DOWNTIME] [int] NULL,
  [TYP_NOTUSED] [int] NULL CONSTRAINT [DF_TYP_TYP_NOTUSED] DEFAULT (0),
  CONSTRAINT [PK_TYP] PRIMARY KEY CLUSTERED ([TYP_ENTITY], [TYP_CODE]),
  CONSTRAINT [UQ_TYP] UNIQUE ([TYP_ROWID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TYP]
  ADD CONSTRAINT [FK_TYP_ORG] FOREIGN KEY ([TYP_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Encja', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_ENTITY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Moduł', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_ORG'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Sortowanie', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_ORDER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Domyślny', 'SCHEMA', N'dbo', 'TABLE', N'TYP', 'COLUMN', N'TYP_DEFAULT'
GO