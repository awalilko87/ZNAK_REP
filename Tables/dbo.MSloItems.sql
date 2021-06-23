CREATE TABLE [dbo].[MSloItems] (
  [rowid] [int] NOT NULL,
  [sloid] [int] NOT NULL,
  [scode] [nvarchar](30) NOT NULL,
  [sdesc] [nvarchar](30) NOT NULL,
  CONSTRAINT [PK_MSloItems] PRIMARY KEY NONCLUSTERED ([sloid], [scode])
)
ON [PRIMARY]
GO