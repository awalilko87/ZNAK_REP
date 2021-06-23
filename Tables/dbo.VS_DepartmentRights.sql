CREATE TABLE [dbo].[VS_DepartmentRights] (
  [DepartmentID] [nvarchar](50) NOT NULL,
  [UserID] [nvarchar](30) NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_DepartmentRights] PRIMARY KEY NONCLUSTERED ([DepartmentID], [UserID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_DepartmentRights_insert_update_trigger] ON [dbo].[VS_DepartmentRights]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DepartmentID nvarchar(50),
			@UserID nvarchar(30),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_DepartmentRights CURSOR FOR 
		SELECT DepartmentID, UserID
		FROM inserted
	OPEN insert_cursor_VS_DepartmentRights
	FETCH NEXT FROM insert_cursor_VS_DepartmentRights 
	INTO @DepartmentID, @UserID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DepartmentID IN (SELECT DepartmentID FROM deleted WHERE UserID = @UserID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_DepartmentRights]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DepartmentID = @DepartmentID
		AND UserID = @UserID

		FETCH NEXT FROM insert_cursor_VS_DepartmentRights 
		INTO @DepartmentID, @UserID
	END
	CLOSE insert_cursor_VS_DepartmentRights	
	DEALLOCATE insert_cursor_VS_DepartmentRights
END
GO