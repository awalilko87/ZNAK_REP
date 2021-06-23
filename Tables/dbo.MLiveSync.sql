CREATE TABLE [dbo].[MLiveSync] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MLiveSync_rowguid] DEFAULT (newid()),
  [deviceguid] [uniqueidentifier] NOT NULL,
  [sequence] [int] NOT NULL,
  [created] [datetime] NOT NULL,
  [command] [nvarchar](30) NOT NULL,
  [argument] [nvarchar](max) NULL,
  [result] [nvarchar](max) NOT NULL,
  [sta] [nvarchar](5) NULL,
  CONSTRAINT [PK_MLiveSync] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO