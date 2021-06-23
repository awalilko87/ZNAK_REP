CREATE TABLE [dbo].[VS_FormRights] (
  [UserID] [nvarchar](30) NOT NULL,
  [FormID] [nvarchar](50) NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_FormRights] PRIMARY KEY NONCLUSTERED ([UserID], [FormID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_FormRights_insert_update_trigger] ON [dbo].[VS_FormRights]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FormID nvarchar(50),
			@UserID nvarchar(30),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_FormRights CURSOR FOR 
		SELECT FormID, UserID
		FROM inserted
	OPEN insert_cursor_VS_FormRights
	FETCH NEXT FROM insert_cursor_VS_FormRights 
	INTO @FormID, @UserID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FormID IN (SELECT FormID FROM deleted WHERE UserID = @UserID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_FormRights]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FormID = @FormID
		AND UserID = @UserID

		FETCH NEXT FROM insert_cursor_VS_FormRights 
		INTO @FormID, @UserID
	END
	CLOSE insert_cursor_VS_FormRights	
	DEALLOCATE insert_cursor_VS_FormRights
END
GO