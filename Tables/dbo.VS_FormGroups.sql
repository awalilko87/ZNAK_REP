CREATE TABLE [dbo].[VS_FormGroups] (
  [GroupID] [nvarchar](20) NOT NULL,
  [ParentID] [nvarchar](50) NULL,
  [GroupDesc] [nvarchar](300) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_FormGroups] PRIMARY KEY NONCLUSTERED ([GroupID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_FormGroups_insert_update_trigger] ON [dbo].[VS_FormGroups]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @GroupID nvarchar(20),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_FormGroups CURSOR FOR 
		SELECT GroupID
		FROM inserted
	OPEN insert_cursor_VS_FormGroups
	FETCH NEXT FROM insert_cursor_VS_FormGroups 
	INTO @GroupID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @GroupID IN (SELECT GroupID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_FormGroups]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE GroupID = @GroupID

		FETCH NEXT FROM insert_cursor_VS_FormGroups 
		INTO @GroupID
	END
	CLOSE insert_cursor_VS_FormGroups	
	DEALLOCATE insert_cursor_VS_FormGroups
END
GO