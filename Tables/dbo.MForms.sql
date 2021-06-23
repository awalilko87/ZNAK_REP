CREATE TABLE [dbo].[MForms] (
  [rowid] [int] NOT NULL,
  [tabname] [nvarchar](30) NOT NULL,
  [caption] [nvarchar](30) NOT NULL,
  [header] [nvarchar](512) NULL,
  [sqlaftersave] [nvarchar](4000) NULL,
  [listaftersave] [nvarchar](1) NULL,
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MForms_rowguid] DEFAULT (newid()),
  [orgguid] [uniqueidentifier] NULL,
  [where] [nvarchar](512) NULL,
  [startcmds] [nvarchar](max) NULL,
  [BAdd] [bit] NULL,
  [BEdit] [bit] NULL,
  [BDelete] [bit] NULL,
  [PageSize] [int] NULL,
  [passifonerecord] [bit] NULL,
  CONSTRAINT [PK_MForms] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO