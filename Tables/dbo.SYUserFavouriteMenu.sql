CREATE TABLE [dbo].[SYUserFavouriteMenu] (
  [UserID] [nvarchar](30) NOT NULL CONSTRAINT [DF_SYUserFavouriteMenu_UserID] DEFAULT (''),
  [MenuKey] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUserFavouriteMenu_MenuKey] DEFAULT (''),
  [MenuCaption] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUserFavouriteMenu_MenuCaption] DEFAULT (''),
  [MenuToolTip] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYUserFavouriteMenu_MenuToolTip] DEFAULT (''),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [HTTPLink] [nvarchar](4000) NULL,
  CONSTRAINT [PK_SYUserFavouriteMenu] PRIMARY KEY NONCLUSTERED ([MenuKey], [UserID])
)
ON [PRIMARY]
GO