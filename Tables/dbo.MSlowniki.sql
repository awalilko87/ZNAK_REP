CREATE TABLE [dbo].[MSlowniki] (
  [rowid] [int] NOT NULL,
  [caption] [nvarchar](30) NOT NULL,
  [swhere] [nvarchar](255) NOT NULL,
  [fromsel] [nvarchar](30) NULL,
  [fields] [nvarchar](80) NULL,
  CONSTRAINT [PK_MSlowniki] PRIMARY KEY NONCLUSTERED ([rowid])
)
ON [PRIMARY]
GO