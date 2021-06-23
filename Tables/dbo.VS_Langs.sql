CREATE TABLE [dbo].[VS_Langs] (
  [LangID] [nvarchar](10) NOT NULL,
  [LangName] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Langs] PRIMARY KEY NONCLUSTERED ([LangID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Langs_insert_update_trigger] ON [dbo].[VS_Langs]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @LangName nvarchar(50),
			@LangID nvarchar(10),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Langs CURSOR FOR 
		SELECT LangName, LangID
		FROM inserted
	OPEN insert_cursor_VS_Langs
	FETCH NEXT FROM insert_cursor_VS_Langs 
	INTO @LangName, @LangID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @LangName IN (SELECT LangName FROM deleted WHERE LangID = @LangID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Langs]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE LangName = @LangName
		AND LangID = @LangID

		FETCH NEXT FROM insert_cursor_VS_Langs 
		INTO @LangName, @LangID
	END
	CLOSE insert_cursor_VS_Langs	
	DEALLOCATE insert_cursor_VS_Langs
END
GO