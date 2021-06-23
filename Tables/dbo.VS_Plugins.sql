CREATE TABLE [dbo].[VS_Plugins] (
  [MOD_ROWID] [int] NOT NULL,
  [MOD_FullName] [nvarchar](255) NOT NULL,
  [MOD_Control] [nvarchar](255) NOT NULL,
  [MOD_Version] [nvarchar](30) NOT NULL,
  [MOD_FileName] [nvarchar](255) NOT NULL,
  [MOD_Data] [image] NOT NULL,
  [MOD_CreatedOn] [datetime] NOT NULL,
  [MOD_UpdatedOn] [datetime] NULL,
  [MOD_CreatedBy] [nvarchar](30) NOT NULL,
  [MOD_UpdatedBy] [nvarchar](30) NULL,
  CONSTRAINT [PK_VS_Plugins] PRIMARY KEY NONCLUSTERED ([MOD_FullName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO