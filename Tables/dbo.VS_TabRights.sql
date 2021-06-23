CREATE TABLE [dbo].[VS_TabRights] (
  [UserID] [nvarchar](30) NOT NULL,
  [TabGroup] [nvarchar](50) NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_TabRights] PRIMARY KEY NONCLUSTERED ([UserID], [TabGroup])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_TabRights_insert_update_trigger] ON [dbo].[VS_TabRights]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @UserID nvarchar(30),
			@TabGroup nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_TabRights CURSOR FOR 
		SELECT UserID, TabGroup
		FROM inserted
	OPEN insert_cursor_VS_TabRights
	FETCH NEXT FROM insert_cursor_VS_TabRights 
	INTO @UserID, @TabGroup
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @UserID IN (SELECT UserID FROM deleted WHERE TabGroup = @TabGroup)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_TabRights]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE UserID = @UserID
		AND TabGroup = @TabGroup

		FETCH NEXT FROM insert_cursor_VS_TabRights 
		INTO @UserID, @TabGroup
	END
	CLOSE insert_cursor_VS_TabRights	
	DEALLOCATE insert_cursor_VS_TabRights
END
GO