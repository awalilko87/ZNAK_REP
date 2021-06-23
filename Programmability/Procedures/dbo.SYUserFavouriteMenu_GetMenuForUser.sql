SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserFavouriteMenu_GetMenuForUser](
     @UserID nvarchar(30),
     @GroupID nvarchar(20),
	 @LangID nvarchar(3)
)
WITH ENCRYPTION
AS

IF (@GroupID = 'SA')
	BEGIN
	  /*Ma zwracać tylko jeśli są elementy dla UserID*/
	  IF (select count(*) from SYUserFavouriteMenu where UserID = @UserID) > 0 
	  BEGIN
		  SELECT MenuKey = 'ULUBIONE', 
				 GroupKey = '', 
				 ModuleName = null, 
				 Orders = 0, 
				 IconKey = '', 
				 ActionName = null, 
				 MenuToolTip = '', 
				 HTTPLink = '', 
				 ToolTip = null, 
				 MenuRightsOn = cast(0 as bit), 
				 MenuCaption = (select top 1 ISNULL(Caption, 'Ulubione') from VS_LangMsgs where ObjectID = 'Header_Vision_Menu_Favourite' and LangID = @LangID), 
				 MenuIcon = '/Images/OfficeInfor/Vmenu/Favorites.png', 
				 IsGroup = cast(1 as bit), 
				 IsVisible = cast(1 as bit), 
				 DisableInsert = cast(0 as bit), 
				 DisableEdit = cast(0 as bit), 
				 DisableDelete = cast(0 as bit),
				 EncryptedLink = '',
				 [Open] = null
		  UNION ALL
		  SELECT MenuKey, 
				 GroupKey = 'ULUBIONE', 
				 ModuleName = null, 
				 Orders = 0, 
				 IconKey = null, 
				 ActionName = null, 
				 MenuToolTip, 
				 HTTPLink, 
				 ToolTip = null, 
				 MenuRightsOn = cast(0 as bit), 
				 MenuCaption, 
				 MenuIcon = '', 
				 IsGroup = cast(0 as bit), 
				 IsVisible = cast(1 as bit), 
				 DisableInsert = cast(0 as bit), 
				 DisableEdit = cast(0 as bit), 
				 DisableDelete = cast(0 as bit),
				 EncryptedLink = '',
				 [Open] = null
			FROM SYUserFavouriteMenu
			WHERE UserID = @UserID 
		END
		ELSE BEGIN
			SELECT MenuKey, 
					GroupKey = 'ULUBIONE', 
					ModuleName = null, 
					Orders = 0, 
					IconKey = null, 
					ActionName = null, 
					MenuToolTip, 
					HTTPLink, 
					ToolTip = null, 
					MenuRightsOn = cast(0 as bit), 
					MenuCaption, 
					MenuIcon = '', 
					IsGroup = cast(0 as bit), 
					IsVisible = cast(1 as bit), 
					DisableInsert = cast(0 as bit), 
					DisableEdit = cast(0 as bit), 
					DisableDelete = cast(0 as bit),
					EncryptedLink = '',
					[Open] = null
			FROM SYUserFavouriteMenu
			WHERE 1 = 0
		END
    END
    ELSE
    BEGIN
		IF (select count(*) from SYUserFavouriteMenu where UserID = @UserID) > 0 
		BEGIN
		SELECT MenuKey = 'ULUBIONE', 
				 GroupKey = '', 
				 ModuleName = null, 
				 Orders = 0, 
				 IconKey = null, 
				 ActionName = null, 
				 MenuToolTip = '', 
				 HTTPLink = '', 
				 ToolTip = null, 
				 MenuRightsOn = cast(0 as bit), 
				 MenuCaption = (select top 1 ISNULL(Caption, 'Ulubione') from VS_LangMsgs where ObjectID = 'Header_Vision_Menu_Favourite' and LangID = @LangID), 
				 MenuIcon = '/Images/OfficeInfor/Vmenu/Favorites.png', 
				 IsGroup = cast(1 as bit), 
				 IsVisible = cast(0 as bit), 
				 DisableInsert = cast(0 as bit), 
				 DisableEdit = cast(0 as bit), 
				 DisableDelete = cast(0 as bit),
				 EncryptedLink = '',
				 [Open] = null
		  UNION ALL
			SELECT MenuKey, 
				 GroupKey = 'ULUBIONE', 
				 ModuleName = null, 
				 Orders = 0, 
				 IconKey = null, 
				 ActionName = null, 
				 MenuToolTip, 
				 HTTPLink, 
				 ToolTip = null, 
				 MenuRightsOn = cast(0 as bit), 
				 MenuCaption, 
				 MenuIcon = '', 
				 IsGroup = cast(0 as bit), 
				 IsVisible = cast(0 as bit), 
				 DisableInsert = cast(0 as bit), 
				 DisableEdit = cast(0 as bit), 
				 DisableDelete = cast(0 as bit),
				 EncryptedLink = '',
				 [Open] = null
			FROM SYUserFavouriteMenu
			WHERE UserID = @UserID AND EXISTS (SELECT * FROM dbo.SYUserMenu WHERE UserID = @GroupID AND SYUserFavouriteMenu.MenuKey = SYUserMenu.MenuKey)
		END
		ELSE BEGIN
			SELECT MenuKey, 
					GroupKey = 'ULUBIONE', 
					ModuleName = null, 
					Orders = 0, 
					IconKey = null, 
					ActionName = null, 
					MenuToolTip, 
					HTTPLink, 
					ToolTip = null, 
					MenuRightsOn = cast(0 as bit), 
					MenuCaption, 
					MenuIcon = '', 
					IsGroup = cast(0 as bit), 
					IsVisible = cast(1 as bit), 
					DisableInsert = cast(0 as bit), 
					DisableEdit = cast(0 as bit), 
					DisableDelete = cast(0 as bit),
					EncryptedLink = '',
					[Open] = null
			FROM SYUserFavouriteMenu
			WHERE 1 = 0
		END
    END
GO