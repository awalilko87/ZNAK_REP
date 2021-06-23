CREATE TABLE [dbo].[MFormButtons] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MFormButtons_rowguid] DEFAULT (newid()),
  [formguid] [uniqueidentifier] NOT NULL,
  [action] [nvarchar](max) NOT NULL,
  [resname] [nvarchar](255) NULL,
  [text] [nvarchar](30) NULL,
  [parentguid] [uniqueidentifier] NULL,
  [state] [nvarchar](8) NULL,
  [order] [tinyint] NULL,
  [width] [int] NULL,
  [height] [int] NULL,
  CONSTRAINT [PK_MFormButtons] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO