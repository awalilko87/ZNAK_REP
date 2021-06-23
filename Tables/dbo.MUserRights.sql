CREATE TABLE [dbo].[MUserRights] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MUserRights_rowguid] DEFAULT (newid()),
  [userguid] [uniqueidentifier] NULL,
  [refguid] [uniqueidentifier] NULL,
  [type] [nvarchar](50) NULL,
  [rightscode] [nvarchar](255) NULL,
  [orgguid] [uniqueidentifier] NULL
)
ON [PRIMARY]
GO