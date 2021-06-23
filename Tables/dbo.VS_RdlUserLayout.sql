CREATE TABLE [dbo].[VS_RdlUserLayout] (
  [Rowid] [int] IDENTITY,
  [FormID] [nvarchar](30) NOT NULL,
  [SchemaID] [nvarchar](30) NOT NULL,
  [UserID] [nvarchar](30) NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [SchemaData] [xml] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [IsDefault] [bit] NOT NULL CONSTRAINT [DF_VS_RdlUserLayout_IsDefault] DEFAULT (0),
  [IsLastPreset] [bit] NOT NULL CONSTRAINT [DF_VS_RdlUserLayout_IsLastPreset] DEFAULT (0),
  CONSTRAINT [PK_VS_RdlUserLayout] PRIMARY KEY NONCLUSTERED ([Rowid], [FormID], [SchemaID], [UserID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO