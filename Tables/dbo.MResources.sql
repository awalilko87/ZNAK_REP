CREATE TABLE [dbo].[MResources] (
  [rowid] [int] NOT NULL,
  [object] [nvarchar](30) NOT NULL,
  [itemid] [nvarchar](30) NOT NULL,
  [lang] [nvarchar](2) NOT NULL,
  [scode] [nvarchar](255) NOT NULL,
  CONSTRAINT [PK_MResources] PRIMARY KEY NONCLUSTERED ([object], [itemid], [lang])
)
ON [PRIMARY]
GO