CREATE TABLE [dbo].[VS_LangMsgs] (
  [LangID] [nvarchar](10) NOT NULL,
  [ObjectID] [nvarchar](150) NOT NULL,
  [ControlID] [nvarchar](50) NOT NULL,
  [ObjectType] [nvarchar](20) NOT NULL,
  [Tooltip] [nvarchar](4000) NULL,
  [ValidateErrMessage] [nvarchar](150) NULL,
  [GridColCaption] [nvarchar](500) NULL,
  [CallbackMessage] [nvarchar](50) NULL,
  [ButtonTextNew] [nvarchar](150) NULL,
  [ButtonTextDelete] [nvarchar](150) NULL,
  [ButtonTextSave] [nvarchar](150) NULL,
  [AltSavePrompt] [nvarchar](100) NULL,
  [AltRequirePrompt] [nvarchar](100) NULL,
  [AltRecCountPrompt] [nvarchar](100) NULL,
  [AltPageOfCounter] [nvarchar](100) NULL,
  [Caption] [nvarchar](4000) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_LangMsgs1] PRIMARY KEY NONCLUSTERED ([ControlID], [ObjectID], [ObjectType], [LangID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_LangMsgs_insert_update_trigger] ON [dbo].[VS_LangMsgs]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ObjectType nvarchar(20),
			@LangID nvarchar(10),
			@ControlID nvarchar(50),
			@ObjectID nvarchar(150),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_LangMsgs CURSOR FOR 
		SELECT ObjectID, LangID, ControlID, ObjectType
		FROM inserted
	OPEN insert_cursor_VS_LangMsgs
	FETCH NEXT FROM insert_cursor_VS_LangMsgs 
	INTO @ObjectID, @LangID, @ControlID, @ObjectType
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ObjectID IN (SELECT ObjectID FROM deleted WHERE LangID = @LangID AND ControlID = @ControlID AND ObjectType = @ObjectType)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_LangMsgs]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ObjectID = @ObjectID
		AND LangID = @LangID
		AND ControlID = @ControlID
		AND ObjectType = @ObjectType

		FETCH NEXT FROM insert_cursor_VS_LangMsgs 
		INTO @ObjectID, @LangID, @ControlID, @ObjectType
	END
	CLOSE insert_cursor_VS_LangMsgs	
	DEALLOCATE insert_cursor_VS_LangMsgs
END
GO