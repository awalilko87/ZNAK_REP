CREATE TABLE [dbo].[VS_Doc] (
  [DocID] [nvarchar](50) NOT NULL,
  [Address] [nvarchar](50) NULL,
  [Screen] [nvarchar](100) NULL,
  [Version] [nvarchar](50) NULL,
  [Description] [nvarchar](1000) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Doc] PRIMARY KEY NONCLUSTERED ([DocID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Doc_insert_update_trigger] ON [dbo].[VS_Doc]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DocID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Doc CURSOR FOR 
		SELECT DocID
		FROM inserted
	OPEN insert_cursor_VS_Doc
	FETCH NEXT FROM insert_cursor_VS_Doc 
	INTO @DocID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DocID IN (SELECT DocID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Doc]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DocID = @DocID

		FETCH NEXT FROM insert_cursor_VS_Doc 
		INTO @DocID
	END
	CLOSE insert_cursor_VS_Doc	
	DEALLOCATE insert_cursor_VS_Doc
END
GO