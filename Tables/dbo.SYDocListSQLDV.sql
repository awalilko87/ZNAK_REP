CREATE TABLE [dbo].[SYDocListSQLDV] (
  [DocID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLDV_DocID] DEFAULT (''),
  [FieldName] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLDV_FieldName] DEFAULT (''),
  [FieldValue] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLDV_FieldValue] DEFAULT (''),
  [Display] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLDV_Display] DEFAULT (''),
  [Remarks] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListSQLDV_Remarks] DEFAULT (''),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYDocListSQLDV] PRIMARY KEY NONCLUSTERED ([DocID], [FieldName], [FieldValue])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYDocListSQLDV_insert_update_trigger] ON [dbo].[SYDocListSQLDV]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DocID nvarchar(50),
			@FieldName nvarchar(50),
			@FieldValue nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYDocListSQLDV CURSOR FOR 
		SELECT DocID, FieldName, FieldValue
		FROM inserted
	OPEN insert_cursor_SYDocListSQLDV
	FETCH NEXT FROM insert_cursor_SYDocListSQLDV 
	INTO @DocID, @FieldName, @FieldValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DocID IN (SELECT DocID FROM deleted WHERE FieldName = @FieldName AND FieldValue = @FieldValue)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYDocListSQLDV]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DocID = @DocID
		AND FieldName = @FieldName
		AND FieldValue = @FieldValue

		FETCH NEXT FROM insert_cursor_SYDocListSQLDV 
		INTO @DocID, @FieldName, @FieldValue
	END
	CLOSE insert_cursor_SYDocListSQLDV	
	DEALLOCATE insert_cursor_SYDocListSQLDV
END
GO