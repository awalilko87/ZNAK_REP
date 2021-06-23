CREATE TABLE [dbo].[VS_Departments] (
  [DepartmentID] [nvarchar](50) NOT NULL,
  [DepartmentName] [nvarchar](200) NULL,
  [DepartmentAddress] [nvarchar](250) NULL,
  [DepartmentZipCode] [nvarchar](50) NULL,
  [DepartmentCity] [nvarchar](300) NULL,
  [DepartmentTRN] [nvarchar](50) NULL,
  [DepartmentKRS] [nvarchar](150) NULL,
  [DepartmentPhone] [nvarchar](200) NULL,
  [DepartmentEmail] [nvarchar](150) NULL,
  [AgentCode] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Departments] PRIMARY KEY NONCLUSTERED ([DepartmentID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Departments_insert_update_trigger] ON [dbo].[VS_Departments]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DepartmentID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Departments CURSOR FOR 
		SELECT DepartmentID
		FROM inserted
	OPEN insert_cursor_VS_Departments
	FETCH NEXT FROM insert_cursor_VS_Departments 
	INTO @DepartmentID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DepartmentID IN (SELECT DepartmentID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Departments]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DepartmentID = @DepartmentID

		FETCH NEXT FROM insert_cursor_VS_Departments 
		INTO @DepartmentID
	END
	CLOSE insert_cursor_VS_Departments	
	DEALLOCATE insert_cursor_VS_Departments
END
GO