CREATE TABLE [dbo].[SYFiles] (
  [FileID] [int] NULL,
  [FileSize] [int] NOT NULL,
  [FileContentType] [nvarchar](255) NOT NULL,
  [img] [image] NULL,
  [TableName] [nvarchar](50) NOT NULL,
  [ID] [nvarchar](50) NOT NULL,
  [Alt] [nvarchar](100) NOT NULL,
  [Description] [nvarchar](250) NOT NULL,
  [FilePath] [nvarchar](150) NULL,
  [CreateDate] [datetime] NULL CONSTRAINT [DF_SYFiles_CreateDate] DEFAULT (getdate()),
  [FileID2] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYFiles_FileID2] DEFAULT (newid()),
  [FileName] [nvarchar](300) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [PathID] [nvarchar](50) NULL,
  CONSTRAINT [PK_SYFiles] PRIMARY KEY NONCLUSTERED ([FileID2])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYFiles_insert_update_trigger] ON [dbo].[SYFiles]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FileID2 nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYFiles CURSOR FOR 
		SELECT FileID2
		FROM inserted
	OPEN insert_cursor_SYFiles
	FETCH NEXT FROM insert_cursor_SYFiles 
	INTO @FileID2
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FileID2 IN (SELECT FileID2 FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYFiles]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FileID2 = @FileID2

		FETCH NEXT FROM insert_cursor_SYFiles 
		INTO @FileID2
	END
	CLOSE insert_cursor_SYFiles	
	DEALLOCATE insert_cursor_SYFiles
END
GO