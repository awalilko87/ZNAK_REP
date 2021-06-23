CREATE TABLE [dbo].[ENT] (
  [ENT_CODE] [nvarchar](10) NOT NULL,
  [ENT_DESC] [nvarchar](80) NULL,
  [ENT_TABLE] [nvarchar](30) NULL,
  [ENT_STATUS] [nvarchar](30) NULL,
  [ENT_RSTATUS] [int] NULL,
  [ENT_NOTUSED] [int] NULL CONSTRAINT [DF_ENT_ENT_NOTUSED] DEFAULT (0),
  [ENT_ORDER] [int] NULL,
  [ENT_DEFAULT] [int] NULL,
  [ENT_MULTIORG] [int] NULL,
  [ENT_PREFIX] [nvarchar](100) NULL,
  [ENT_SUFFIX] [nvarchar](100) NULL,
  CONSTRAINT [PK_ENT_1] PRIMARY KEY CLUSTERED ([ENT_CODE])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Tabela', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_TABLE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Status', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_STATUS'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Do odczytu', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_RSTATUS'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ywany', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_NOTUSED'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Sortowanie', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_ORDER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Domyślny', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_DEFAULT'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Wielosiedzibowość', 'SCHEMA', N'dbo', 'TABLE', N'ENT', 'COLUMN', N'ENT_MULTIORG'
GO