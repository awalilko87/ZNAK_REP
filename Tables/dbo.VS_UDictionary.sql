CREATE TABLE [dbo].[VS_UDictionary] (
  [ID] [int] IDENTITY,
  [pValue] [nvarchar](50) NULL,
  [pDesc] [nvarchar](150) NULL,
  [Type] [nvarchar](50) NULL,
  [Type2] [nvarchar](50) NULL,
  [Type3] [nvarchar](50) NULL,
  [Type4] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_UDictionary] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_UDictionary_insert_update_trigger] ON [dbo].[VS_UDictionary]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ID int,
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_UDictionary CURSOR FOR 
		SELECT ID
		FROM inserted
	OPEN insert_cursor_VS_UDictionary
	FETCH NEXT FROM insert_cursor_VS_UDictionary 
	INTO @ID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ID IN (SELECT ID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_UDictionary]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ID = @ID

		FETCH NEXT FROM insert_cursor_VS_UDictionary 
		INTO @ID
	END
	CLOSE insert_cursor_VS_UDictionary	
	DEALLOCATE insert_cursor_VS_UDictionary
END
GO