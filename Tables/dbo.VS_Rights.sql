CREATE TABLE [dbo].[VS_Rights] (
  [UserID] [nvarchar](30) NOT NULL CONSTRAINT [DF_VS_Rights_UserID] DEFAULT (''),
  [FormID] [nvarchar](50) NOT NULL,
  [FieldID] [nvarchar](50) NOT NULL,
  [Rights] [nvarchar](4000) NULL,
  [Cond] [nvarchar](100) NOT NULL CONSTRAINT [DF_VS_Rights_Cond] DEFAULT (''),
  [rReadOnly] [nvarchar](4000) NULL,
  [rVisible] [nvarchar](4000) NULL,
  [rRequire] [nvarchar](4000) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Rights1] PRIMARY KEY NONCLUSTERED ([FieldID], [FormID], [UserID], [Cond])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Rights_insert_update_trigger] ON [dbo].[VS_Rights]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @UserID nvarchar(30),
			@FormID nvarchar(50),
			@FieldID nvarchar(50),
			@Cond nvarchar(100),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Rights CURSOR FOR 
		SELECT UserID, FormID, FieldID, Cond
		FROM inserted
	OPEN insert_cursor_VS_Rights
	FETCH NEXT FROM insert_cursor_VS_Rights 
	INTO @UserID, @FormID, @FieldID, @Cond
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @UserID IN (SELECT UserID FROM deleted WHERE FormID = @FormID AND FieldID = @FieldID AND Cond = @Cond)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Rights]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE UserID = @UserID
		AND FormID = @FormID
		AND FieldID = @FieldID
		AND Cond = @Cond

		FETCH NEXT FROM insert_cursor_VS_Rights 
		INTO @UserID, @FormID, @FieldID, @Cond
	END
	CLOSE insert_cursor_VS_Rights	
	DEALLOCATE insert_cursor_VS_Rights
END
GO