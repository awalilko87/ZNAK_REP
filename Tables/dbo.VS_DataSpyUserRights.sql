CREATE TABLE [dbo].[VS_DataSpyUserRights] (
  [UserID] [nvarchar](50) NOT NULL,
  [DS_PRIV] [bit] NULL,
  [DS_PUB] [bit] NULL,
  [DS_GR] [bit] NULL,
  [DS_SITE] [bit] NULL,
  [DS_DEP] [bit] NULL,
  CONSTRAINT [PK_VS_DataSpyUserRights] PRIMARY KEY NONCLUSTERED ([UserID])
)
ON [PRIMARY]
GO