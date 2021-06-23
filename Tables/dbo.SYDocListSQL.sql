CREATE TABLE [dbo].[SYDocListSQL] (
  [DocType] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocType] DEFAULT (''),
  [DocSQL] [nvarchar](max) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocSQL] DEFAULT (''),
  [DocSQLWhere] [nvarchar](200) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocSQLWhere] DEFAULT (''),
  [DocSQLOrderBy] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocSQLOrderBy] DEFAULT (''),
  [Comment] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListSQL_Comment] DEFAULT (''),
  [DocSQLGroupBy] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocSQLGroupBy] DEFAULT (''),
  [DocSQLIDValue] [nvarchar](200) NOT NULL CONSTRAINT [DF_SYDocListSQL_DocSQLIDValue] DEFAULT (''),
  [Buttons] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQL_Buttons] DEFAULT (''),
  [Caption] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListSQL_Caption] DEFAULT (''),
  [PageSize] [int] NULL CONSTRAINT [DF_SYDocListSQL_PageSize] DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [NotAutoLoad] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQL_NotAutoLoad] DEFAULT (0),
  [AutoReload] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQL_AutoReload] DEFAULT (0),
  [GroupOn] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQL_GroupOn] DEFAULT (0),
  CONSTRAINT [PK_SYDocListSQL] PRIMARY KEY NONCLUSTERED ([DocType])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYDocListSQL_insert_update_trigger] ON [dbo].[SYDocListSQL]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DocType nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYDocListSQL CURSOR FOR 
		SELECT DocType
		FROM inserted
	OPEN insert_cursor_SYDocListSQL
	FETCH NEXT FROM insert_cursor_SYDocListSQL 
	INTO @DocType
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DocType IN (SELECT DocType FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYDocListSQL]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DocType = @DocType

		FETCH NEXT FROM insert_cursor_SYDocListSQL 
		INTO @DocType
	END
	CLOSE insert_cursor_SYDocListSQL	
	DEALLOCATE insert_cursor_SYDocListSQL
END
GO