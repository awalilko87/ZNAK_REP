CREATE TABLE [dbo].[ORG] (
  [ORG_CODE] [nvarchar](30) NOT NULL,
  [ORG_DESC] [nvarchar](80) NOT NULL,
  [ORG_STATUS] [nvarchar](30) NULL,
  [ORG_DEFAULTVEN] [nvarchar](30) NULL,
  [ORG_FONTCOLOR] [nvarchar](50) NULL,
  [ORG_COLOR] [nvarchar](50) NULL,
  [ORG_RSTATUS] [int] NULL,
  [ORG_NOTUSED] [int] NULL,
  [ORG_ORDER] [int] NULL,
  [ORG_DEFAULT] [int] NULL,
  [ORG_MODULE] [nvarchar](30) NOT NULL,
  [ORG_CITY] [nvarchar](50) NULL,
  [ORG_NIP] [nvarchar](30) NULL,
  [ORG_STREET] [nvarchar](80) NULL,
  [ORG_REGON] [nvarchar](30) NULL,
  [ORG_ZIP] [nvarchar](30) NULL,
  [ORG_BANKNOM] [nvarchar](80) NULL,
  [ORG_AXCODE] [nvarchar](50) NULL,
  [ORG_LOGO] [nvarchar](50) NULL,
  [ROWID] [int] IDENTITY,
  CONSTRAINT [PK_ORG] PRIMARY KEY CLUSTERED ([ORG_CODE]),
  CONSTRAINT [UQ_ORG] UNIQUE ([ORG_CODE]) WITH (ALLOW_PAGE_LOCKS = OFF)
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Miasto', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_CITY'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'NIP', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_NIP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ulica', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_STREET'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Regon', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_REGON'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod pocztowy', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_ZIP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nr. rachunku', 'SCHEMA', N'dbo', 'TABLE', N'ORG', 'COLUMN', N'ORG_BANKNOM'
GO