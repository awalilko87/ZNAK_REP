CREATE TABLE [dbo].[SYModules] (
  [ModuleCode] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYModules_ModuleCode] DEFAULT (''),
  [ModuleDesc] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYModules_ModuleDesc] DEFAULT (''),
  [VerticalCaption] [nvarchar](200) NOT NULL CONSTRAINT [DF_SYModules_VerticalCaption] DEFAULT (''),
  [INIFileName] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYModules_INIFileName] DEFAULT (''),
  [Orders] [numeric](18, 5) NOT NULL CONSTRAINT [DF_SYModules_Orders] DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYModules] PRIMARY KEY NONCLUSTERED ([ModuleCode])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYModules_insert_update_trigger] ON [dbo].[SYModules]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ModuleCode nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYModules CURSOR FOR 
		SELECT ModuleCode
		FROM inserted
	OPEN insert_cursor_SYModules
	FETCH NEXT FROM insert_cursor_SYModules 
	INTO @ModuleCode
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ModuleCode IN (SELECT ModuleCode FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYModules]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ModuleCode = @ModuleCode

		FETCH NEXT FROM insert_cursor_SYModules 
		INTO @ModuleCode
	END
	CLOSE insert_cursor_SYModules	
	DEALLOCATE insert_cursor_SYModules
END
GO