CREATE TABLE [dbo].[VS_PluginSettings] (
  [MenuID] [nvarchar](30) NOT NULL,
  [TabName] [nvarchar](30) NOT NULL,
  [PluginID] [int] NOT NULL,
  [BaseConfig] [xml] NOT NULL,
  [CustomConfig] [xml] NOT NULL,
  CONSTRAINT [PK_VS_PluginSettings] PRIMARY KEY NONCLUSTERED ([MenuID], [TabName], [PluginID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO