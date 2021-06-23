CREATE TABLE [dbo].[SYLog] (
  [ID] [int] IDENTITY,
  [UserID] [nvarchar](30) NULL,
  [Operation] [nvarchar](4000) NULL,
  [Created] [datetime] NULL CONSTRAINT [DF_SYLog_Created] DEFAULT (getdate()),
  [Type] [nvarchar](50) NULL,
  [SessionID] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYLog] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYLog_insert_update_trigger] ON [dbo].[SYLog]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ID int,
			@Description nvarchar(255)

	DECLARE insert_cursor_SYLog CURSOR FOR 
		SELECT ID
		FROM inserted
	OPEN insert_cursor_SYLog
	FETCH NEXT FROM insert_cursor_SYLog 
	INTO @ID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ID IN (SELECT ID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYLog]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ID = @ID

		FETCH NEXT FROM insert_cursor_SYLog 
		INTO @ID
	END
	CLOSE insert_cursor_SYLog	
	DEALLOCATE insert_cursor_SYLog
END
GO