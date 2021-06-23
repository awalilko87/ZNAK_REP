CREATE TABLE [dbo].[MInterfaces] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MInterfaces_rowguid] DEFAULT (newid()),
  [orgguid] [uniqueidentifier] NOT NULL,
  [deviceguid] [uniqueidentifier] NOT NULL,
  [assemblyname] [nvarchar](255) NOT NULL,
  [assemblyver] [nvarchar](30) NOT NULL,
  [assemblydata] [varbinary](max) NOT NULL,
  [createdon] [datetime] NOT NULL,
  CONSTRAINT [PK_MInterfaces] PRIMARY KEY NONCLUSTERED ([orgguid], [deviceguid], [assemblyname], [assemblyver])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO