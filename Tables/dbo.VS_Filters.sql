CREATE TABLE [dbo].[VS_Filters] (
  [FormID] [nvarchar](50) NOT NULL,
  [TableName] [nvarchar](250) NULL,
  [GroupID] [nvarchar](20) NOT NULL,
  [UserID] [nvarchar](30) NOT NULL,
  [IsPrivate] [bit] NULL,
  [SqlWhere] [nvarchar](max) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Filters] PRIMARY KEY NONCLUSTERED ([FormID], [GroupID], [UserID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Filters_insert_update_trigger] ON [dbo].[VS_Filters]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FormID nvarchar(50),
			@GroupID nvarchar(20),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Filters CURSOR FOR 
		SELECT FormID, GroupID
		FROM inserted
	OPEN insert_cursor_VS_Filters
	FETCH NEXT FROM insert_cursor_VS_Filters 
	INTO @FormID, @GroupID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FormID IN (SELECT FormID FROM deleted WHERE GroupID = @GroupID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Filters]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FormID = @FormID
		AND GroupID = @GroupID

		FETCH NEXT FROM insert_cursor_VS_Filters 
		INTO @FormID, @GroupID
	END
	CLOSE insert_cursor_VS_Filters	
	DEALLOCATE insert_cursor_VS_Filters
END
GO