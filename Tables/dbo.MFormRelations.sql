CREATE TABLE [dbo].[MFormRelations] (
  [msformguid] [uniqueidentifier] NOT NULL,
  [slformguid] [uniqueidentifier] NOT NULL,
  [mskey] [nvarchar](30) NULL,
  [slkey] [nvarchar](30) NULL,
  [caption] [nvarchar](30) NULL,
  [rowid] [int] NOT NULL,
  [tabname] [nvarchar](30) NULL,
  [sltabname] [nvarchar](30) NULL,
  [wizardguid] [uniqueidentifier] NOT NULL,
  [parentheader] [nvarchar](1024) NULL,
  [lp] [tinyint] NULL,
  [beforeaction] [nvarchar](512) NULL,
  [afteraction] [nvarchar](512) NULL,
  [orgguid] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_MFormRelations] PRIMARY KEY NONCLUSTERED ([msformguid], [slformguid], [wizardguid])
)
ON [PRIMARY]
GO