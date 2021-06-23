CREATE TABLE [dbo].[SYUserMenu] (
  [UserID] [nvarchar](30) NOT NULL CONSTRAINT [DF_SYUserMenu_UserID] DEFAULT (''),
  [MenuKey] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUserMenu_MenuKey] DEFAULT (''),
  [ModuleCode] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUserMenu_ModuleCode] DEFAULT (''),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [DisableInsert] [bit] NULL,
  [DisableEdit] [bit] NULL,
  [DisableDelete] [bit] NULL,
  [Open] [bit] NULL,
  CONSTRAINT [PK_SYUserMenu1] PRIMARY KEY NONCLUSTERED ([MenuKey], [UserID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYUserMenu_insert_update_trigger] ON [dbo].[SYUserMenu]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @UserID nvarchar(30),
			@MenuKey nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYUserMenu CURSOR FOR 
		SELECT UserID, MenuKey
		FROM inserted
	OPEN insert_cursor_SYUserMenu
	FETCH NEXT FROM insert_cursor_SYUserMenu 
	INTO @UserID, @MenuKey
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @UserID IN (SELECT UserID FROM deleted WHERE MenuKey = @MenuKey)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYUserMenu]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE UserID = @UserID
		AND MenuKey = @MenuKey

		FETCH NEXT FROM insert_cursor_SYUserMenu 
		INTO @UserID, @MenuKey
	END
	CLOSE insert_cursor_SYUserMenu	
	DEALLOCATE insert_cursor_SYUserMenu
END
GO