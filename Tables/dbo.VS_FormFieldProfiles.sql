CREATE TABLE [dbo].[VS_FormFieldProfiles] (
  [FormID] [nvarchar](50) NOT NULL,
  [FieldID] [nvarchar](50) NOT NULL,
  [UserID] [nvarchar](30) NOT NULL,
  [GridColIndex] [int] NULL,
  [GridColWidth] [int] NULL,
  [GridColCaption] [nvarchar](500) NULL,
  [GridColVisible] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_FormFieldProfiles] PRIMARY KEY NONCLUSTERED ([FormID], [FieldID], [UserID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_FormFieldProfiles_insert_update_trigger] ON [dbo].[VS_FormFieldProfiles]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FormID nvarchar(50),
			@FieldID nvarchar(50),
			@UserID nvarchar(30),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_FormFieldProfiles CURSOR FOR 
		SELECT FormID, @FieldID, @UserID
		FROM inserted
	OPEN insert_cursor_VS_FormFieldProfiles
	FETCH NEXT FROM insert_cursor_VS_FormFieldProfiles 
	INTO @FormID, @FieldID, @UserID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FormID IN (SELECT FormID FROM deleted WHERE FieldID = @FieldID AND UserID = @UserID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_FormFieldProfiles]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FormID = @FormID
		AND FieldID = @FieldID
		AND UserID = @UserID

		FETCH NEXT FROM insert_cursor_VS_FormFieldProfiles 
		INTO @FormID, @FieldID, @UserID
	END
	CLOSE insert_cursor_VS_FormFieldProfiles	
	DEALLOCATE insert_cursor_VS_FormFieldProfiles
END
GO