CREATE TABLE [dbo].[MTableToPull] (
  [tabname] [nvarchar](30) NOT NULL,
  [key] [nvarchar](4000) NOT NULL,
  [rowid] [int] NOT NULL,
  [commitsql] [nvarchar](4000) NULL,
  [trackchanges] [nvarchar](1) NOT NULL,
  [orgguid] [uniqueidentifier] NOT NULL,
  [commitImportSql] [nvarchar](512) NULL,
  [todrop] [bit] NOT NULL,
  CONSTRAINT [PK_MTableToPull] PRIMARY KEY NONCLUSTERED ([tabname])
)
ON [PRIMARY]
GO