CREATE TABLE [dbo].[SYGroups] (
  [GroupID] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYGroups_GroupID] DEFAULT (''),
  [GroupName] [nvarchar](100) NULL,
  [Module] [nvarchar](30) NULL,
  [Typ] [nvarchar](50) NULL,
  [Typ2] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYGroups] PRIMARY KEY NONCLUSTERED ([GroupID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYGroups_insert_update_trigger] ON [dbo].[SYGroups]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @GroupName nvarchar(100),
			@GroupID nvarchar(20),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYGroups CURSOR FOR 
		SELECT GroupName, GroupID
		FROM inserted
	OPEN insert_cursor_SYGroups
	FETCH NEXT FROM insert_cursor_SYGroups 
	INTO @GroupName, @GroupID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @GroupName IN (SELECT GroupName FROM deleted WHERE GroupID = @GroupID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYGroups]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE GroupName = @GroupName
		AND GroupID = @GroupID

		FETCH NEXT FROM insert_cursor_SYGroups 
		INTO @GroupName, @GroupID
	END
	CLOSE insert_cursor_SYGroups	
	DEALLOCATE insert_cursor_SYGroups
END
GO