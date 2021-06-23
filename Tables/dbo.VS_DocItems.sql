CREATE TABLE [dbo].[VS_DocItems] (
  [ItemID] [nvarchar](50) NOT NULL,
  [DocID] [nvarchar](50) NULL,
  [Number] [int] NULL,
  [Name] [nvarchar](150) NULL,
  [Type] [nvarchar](20) NULL,
  [Decription] [nvarchar](1000) NULL,
  [Example] [nvarchar](1500) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_DocItems] PRIMARY KEY NONCLUSTERED ([ItemID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_DocItems_insert_update_trigger] ON [dbo].[VS_DocItems]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ItemID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_DocItems CURSOR FOR 
		SELECT ItemID
		FROM inserted
	OPEN insert_cursor_VS_DocItems
	FETCH NEXT FROM insert_cursor_VS_DocItems 
	INTO @ItemID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ItemID IN (SELECT ItemID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_DocItems]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ItemID = @ItemID

		FETCH NEXT FROM insert_cursor_VS_DocItems 
		INTO @ItemID
	END
	CLOSE insert_cursor_VS_DocItems	
	DEALLOCATE insert_cursor_VS_DocItems
END
GO