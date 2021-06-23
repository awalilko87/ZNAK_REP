CREATE TABLE [dbo].[VS_DataSpyUsers] (
  [DataSpyID] [nvarchar](50) NOT NULL CONSTRAINT [DF_VS_DataSpyUsers_DataSpyID] DEFAULT (newid()),
  [UserOrGroupID] [nvarchar](30) NOT NULL,
  [Type] [nvarchar](1) NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_DataSpyUsers] PRIMARY KEY NONCLUSTERED ([DataSpyID], [UserOrGroupID], [Type])
)
ON [PRIMARY]
GO