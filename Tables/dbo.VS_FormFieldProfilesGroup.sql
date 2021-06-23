CREATE TABLE [dbo].[VS_FormFieldProfilesGroup] (
  [FormID] [nvarchar](50) NOT NULL,
  [FieldID] [nvarchar](50) NOT NULL,
  [UserGroupID] [nvarchar](20) NOT NULL,
  [GridColIndex] [int] NULL,
  [GridColWidth] [int] NULL,
  [GridColCaption] [nvarchar](500) NULL,
  [GridColVisible] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_FormFieldProfilesGroup] PRIMARY KEY NONCLUSTERED ([FormID], [FieldID], [UserGroupID])
)
ON [PRIMARY]
GO