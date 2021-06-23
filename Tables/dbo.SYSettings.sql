CREATE TABLE [dbo].[SYSettings] (
  [KeyCode] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYSettings_KeyCode] DEFAULT (''),
  [ModuleCode] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYSettings_ModuleCode] DEFAULT (''),
  [SettingValue] [nvarchar](max) NULL CONSTRAINT [DF_SYSettings_SettingValue] DEFAULT (''),
  [Description] [nvarchar](500) NULL CONSTRAINT [DF_SYSettings_Description] DEFAULT (''),
  [Length] [int] NULL CONSTRAINT [DF_SYSettings_Length] DEFAULT (0),
  [Type] [nvarchar](50) NULL CONSTRAINT [DF_SYSettings_Type] DEFAULT (''),
  [DataSource] [nvarchar](max) NULL CONSTRAINT [DF_SYSettings_DataSource] DEFAULT (''),
  [OrderBy] [int] NULL CONSTRAINT [DF_SYSettings_OrderBy] DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [Visible] [bit] NULL CONSTRAINT [DF_SYSettings_Visible] DEFAULT (0),
  CONSTRAINT [PK_SYSettings] PRIMARY KEY NONCLUSTERED ([KeyCode], [ModuleCode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYSettings_insert_update_trigger] ON [dbo].[SYSettings]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @KeyCode nvarchar(50),
			@ModuleCode nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYSettings CURSOR FOR 
		SELECT KeyCode, ModuleCode
		FROM inserted
	OPEN insert_cursor_SYSettings
	FETCH NEXT FROM insert_cursor_SYSettings 
	INTO @KeyCode, @ModuleCode
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @KeyCode IN (SELECT KeyCode FROM deleted WHERE ModuleCode = @ModuleCode)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYSettings]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE KeyCode = @KeyCode
		AND ModuleCode = @ModuleCode

		FETCH NEXT FROM insert_cursor_SYSettings 
		INTO @KeyCode, @ModuleCode
	END
	CLOSE insert_cursor_SYSettings	
	DEALLOCATE insert_cursor_SYSettings
END
GO