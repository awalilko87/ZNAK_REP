CREATE TABLE [dbo].[VS_Reporttables] (
  [TableName] [nvarchar](50) NOT NULL,
  [FieldName] [nvarchar](50) NOT NULL,
  [Description] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Reporttables1] PRIMARY KEY NONCLUSTERED ([FieldName], [TableName])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Reporttables_insert_update_trigger] ON [dbo].[VS_Reporttables]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @TableName nvarchar(50),
			@FieldName nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Reporttables CURSOR FOR 
		SELECT TableName, FieldName
		FROM inserted
	OPEN insert_cursor_VS_Reporttables
	FETCH NEXT FROM insert_cursor_VS_Reporttables 
	INTO @TableName, @FieldName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @TableName IN (SELECT TableName FROM deleted WHERE FieldName = @FieldName)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Reporttables]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE TableName = @TableName
		AND FieldName = @FieldName

		FETCH NEXT FROM insert_cursor_VS_Reporttables 
		INTO @TableName, @FieldName
	END
	CLOSE insert_cursor_VS_Reporttables	
	DEALLOCATE insert_cursor_VS_Reporttables
END
GO