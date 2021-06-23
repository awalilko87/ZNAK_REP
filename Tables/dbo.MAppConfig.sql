CREATE TABLE [dbo].[MAppConfig] (
  [rowid] [int] NOT NULL,
  [orgguid] [uniqueidentifier] NOT NULL,
  [key] [nvarchar](30) NOT NULL,
  [value] [nvarchar](255) NOT NULL,
  CONSTRAINT [PK_MAppConfig] PRIMARY KEY NONCLUSTERED ([orgguid], [key])
)
ON [PRIMARY]
GO