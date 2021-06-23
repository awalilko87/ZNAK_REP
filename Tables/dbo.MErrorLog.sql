CREATE TABLE [dbo].[MErrorLog] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MErrorLog_rowguid] DEFAULT (newid()),
  [deviceid] [nvarchar](255) NOT NULL,
  [title] [nvarchar](255) NOT NULL,
  [message] [nvarchar](max) NULL,
  CONSTRAINT [PK_MErrorLog] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO