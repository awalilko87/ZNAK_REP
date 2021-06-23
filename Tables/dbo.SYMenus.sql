CREATE TABLE [dbo].[SYMenus] (
  [ModuleName] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYMenus_ModuleName] DEFAULT (''),
  [MenuKey] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYMenus_MenuKey] DEFAULT (''),
  [MenuCaption] [nvarchar](4000) NOT NULL CONSTRAINT [DF_SYMenus_MenuCaption] DEFAULT (''),
  [MenuIcon] [nvarchar](4000) NOT NULL CONSTRAINT [DF_SYMenus_MenuIcon] DEFAULT (''),
  [MenuToolTip] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYMenus_MenuToolTip] DEFAULT (''),
  [GroupKey] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYMenus_GroupKey] DEFAULT (''),
  [IconKey] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYMenus_IconKey] DEFAULT (''),
  [HTTPLink] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYMenus_HTTPLink] DEFAULT (''),
  [ActionName] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYMenus_ActionName] DEFAULT (''),
  [Orders] [int] NOT NULL CONSTRAINT [DF_SYMenus_Orders] DEFAULT (0),
  [ToolTip] [nvarchar](max) NULL,
  [MenuRightsOn] [bit] NULL CONSTRAINT [DF_SYMenus_MenuRightsOn] DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [IsGroup] [bit] NOT NULL CONSTRAINT [DF_SYMenus_IsGroup] DEFAULT (0),
  [IsVisible] [bit] NOT NULL CONSTRAINT [DF_SYMenus_IsVisible] DEFAULT (1),
  [DisableInsert] [bit] NOT NULL CONSTRAINT [DF_SYMenus_DisableInsert] DEFAULT (0),
  [DisableEdit] [bit] NOT NULL CONSTRAINT [DF_SYMenus_DisableEdit] DEFAULT (0),
  [DisableDelete] [bit] NOT NULL CONSTRAINT [DF_SYMenus_DisableDelete] DEFAULT (0),
  CONSTRAINT [PK_SYMenus1] PRIMARY KEY NONCLUSTERED ([MenuKey], [ModuleName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYMenus_insert_update_trigger] ON [dbo].[SYMenus]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ModuleName nvarchar(50),
			@MenuKey nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYMenus CURSOR FOR 
		SELECT ModuleName, MenuKey
		FROM inserted
	OPEN insert_cursor_SYMenus
	FETCH NEXT FROM insert_cursor_SYMenus 
	INTO @ModuleName, @MenuKey
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ModuleName IN (SELECT ModuleName FROM deleted WHERE MenuKey = @MenuKey)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYMenus]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ModuleName = @ModuleName
		AND MenuKey = @MenuKey

		FETCH NEXT FROM insert_cursor_SYMenus 
		INTO @ModuleName, @MenuKey
	END
	CLOSE insert_cursor_SYMenus	
	DEALLOCATE insert_cursor_SYMenus
END
GO