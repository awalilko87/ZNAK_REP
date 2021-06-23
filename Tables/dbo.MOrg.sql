CREATE TABLE [dbo].[MOrg] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MOrg_rowguid] DEFAULT (newid()),
  [code] [nvarchar](30) NOT NULL,
  [desc] [nvarchar](512) NULL,
  CONSTRAINT [PK_MOrg] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
GO