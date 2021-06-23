CREATE TABLE [dbo].[VS_Updates] (
  [upd_date] [datetime] NOT NULL,
  [upd_version] [nvarchar](30) NOT NULL,
  [upd_file] [nvarchar](255) NOT NULL,
  [upd_rowguid] [uniqueidentifier] NOT NULL DEFAULT (newid())
)
ON [PRIMARY]
GO