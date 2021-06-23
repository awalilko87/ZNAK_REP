CREATE TABLE [dbo].[MMainMenu] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MMainMenu_rowguid] DEFAULT (newid()),
  [name] [nvarchar](30) NOT NULL,
  [desc] [nvarchar](255) NULL,
  [action] [nvarchar](255) NULL,
  [tabname] [nvarchar](30) NULL,
  [refguid] [uniqueidentifier] NULL,
  [resname] [nvarchar](30) NULL,
  [order] [int] NULL,
  [foradmin] [nvarchar](30) NULL,
  [orgguid] [uniqueidentifier] NULL,
  [parentguid] [uniqueidentifier] NULL,
  CONSTRAINT [PK_MMainMenu] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
GO