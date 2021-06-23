CREATE TABLE [dbo].[SYUserActivity] (
  [ID] [int] IDENTITY,
  [UserID] [nvarchar](30) NULL,
  [SessionID] [nvarchar](50) NULL,
  [lSid] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [Login] [datetime] NULL,
  [IsAutoRefresh] [bit] NULL,
  CONSTRAINT [PK_SYUserActivity] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_SYUserActivity_UserID_SessionID]
  ON [dbo].[SYUserActivity] ([UserID], [SessionID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYUserActivity_insert_update_trigger] ON [dbo].[SYUserActivity]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ID int,
			@Description nvarchar(255)
		--	@IsAutoRefresh int

	DECLARE insert_cursor_SYUserActivity CURSOR FOR 
		SELECT ID--, IsAutoRefresh
		FROM inserted
	OPEN insert_cursor_SYUserActivity
	FETCH NEXT FROM insert_cursor_SYUserActivity 
	INTO @ID--, @IsAutoRefresh 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ID IN (SELECT ID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'
		
		
		UPDATE [dbo].[SYUserActivity]
		SET  UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ID = @ID
		

		FETCH NEXT FROM insert_cursor_SYUserActivity 
		INTO @ID --, @IsAutoRefresh 
	END
	CLOSE insert_cursor_SYUserActivity	
	DEALLOCATE insert_cursor_SYUserActivity
END
GO