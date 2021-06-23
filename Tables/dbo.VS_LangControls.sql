CREATE TABLE [dbo].[VS_LangControls] (
  [LangID] [nvarchar](10) NOT NULL,
  [FormID] [nvarchar](50) NOT NULL,
  [ControlID] [nvarchar](50) NOT NULL,
  [Caption] [nvarchar](200) NULL,
  [Tooltip] [nvarchar](50) NULL,
  [ValidateErrMessage] [nvarchar](150) NULL,
  [GridColCaption] [nvarchar](50) NULL,
  [CallbackMessage] [nvarchar](50) NULL,
  [ButtonTextNew] [nvarchar](150) NULL,
  [ButtonTextDelete] [nvarchar](150) NULL,
  [ButtonTextSave] [nvarchar](150) NULL,
  [AltSavePrompt] [nvarchar](100) NULL,
  [AltRequirePrompt] [nvarchar](100) NULL,
  [AltRecCountPrompt] [nvarchar](100) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_LangControls1] PRIMARY KEY NONCLUSTERED ([ControlID], [FormID], [LangID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_LangControls_insert_update_trigger] ON [dbo].[VS_LangControls]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FormID nvarchar(50),
			@LangID nvarchar(10),
			@ControlID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_LangControls CURSOR FOR 
		SELECT FormID, LangID, ControlID
		FROM inserted
	OPEN insert_cursor_VS_LangControls
	FETCH NEXT FROM insert_cursor_VS_LangControls 
	INTO @FormID, @LangID, @ControlID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FormID IN (SELECT FormID FROM deleted WHERE LangID = @LangID AND ControlID = @ControlID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_LangControls]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FormID = @FormID
		AND LangID = @LangID
		AND ControlID = @ControlID

		FETCH NEXT FROM insert_cursor_VS_LangControls 
		INTO @FormID, @LangID, @ControlID
	END
	CLOSE insert_cursor_VS_LangControls	
	DEALLOCATE insert_cursor_VS_LangControls
END
GO