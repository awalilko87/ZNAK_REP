CREATE TABLE [dbo].[COSTCLASSIFICATION] (
  [CCF_ROWID] [int] IDENTITY,
  [CCF_CODE] [nvarchar](30) NOT NULL,
  [CCF_ORG] [nvarchar](30) NOT NULL,
  [CCF_DESC] [nvarchar](80) NULL,
  [CCF_CREUSER] [nvarchar](30) NULL,
  [CCF_CREDATE] [datetime] NULL,
  [CCF_UPDUSER] [nvarchar](30) NULL,
  [CCF_UPDDATE] [datetime] NULL,
  [CCF_NOTUSED] [int] NULL,
  [CCF_SAP_Active] [nvarchar](30) NULL,
  [CCF_SAP_ANLKL] [nvarchar](30) NULL,
  [CCF_SAP_TXK50] [nvarchar](512) NULL,
  [CCF_SAP_BUKRS] [nvarchar](30) NULL,
  [CCF_SAP_KTOGR] [nvarchar](512) NULL,
  CONSTRAINT [PK_COSTCLASSIFICATION] PRIMARY KEY CLUSTERED ([CCF_CODE], [CCF_ORG]),
  CONSTRAINT [IX_COSTCLASSIFICATION] UNIQUE ([CCF_ROWID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[COSTCLASSIFICATION]
  ADD CONSTRAINT [FK_COSTCLASSIFICATION_ORG] FOREIGN KEY ([CCF_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Siedziba', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_ORG'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzył', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_CREUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzone', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_CREDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikował', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_UPDUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikowane', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_UPDDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nieaktywne', 'SCHEMA', N'dbo', 'TABLE', N'COSTCLASSIFICATION', 'COLUMN', N'CCF_NOTUSED'
GO