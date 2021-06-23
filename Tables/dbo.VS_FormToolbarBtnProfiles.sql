CREATE TABLE [dbo].[VS_FormToolbarBtnProfiles] (
  [Org] [nvarchar](50) NOT NULL,
  [FormID] [nvarchar](50) NOT NULL,
  [FieldID] [nvarchar](50) NOT NULL,
  [UserGroupID] [nvarchar](50) NOT NULL,
  [ReadOnly] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UpdateUser] [nvarchar](100) NULL,
  CONSTRAINT [PK_VS_FormToolbarButtons] PRIMARY KEY NONCLUSTERED ([Org], [FormID], [FieldID], [UserGroupID])
)
ON [PRIMARY]
GO