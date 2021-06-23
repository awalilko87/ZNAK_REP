CREATE TABLE [dbo].[VS_Reports] (
  [ReportID] [nvarchar](50) NOT NULL,
  [ReportName] [nvarchar](50) NULL,
  [SQLSelect] [nvarchar](3500) NULL,
  [SQLFrom] [nvarchar](200) NULL,
  [SQLWhere] [nvarchar](200) NULL,
  [SQLOrderBy] [nvarchar](100) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UserID] [nvarchar](20) NULL,
  [IsPublic] [bit] NULL,
  [IsRdl] [bit] NULL,
  CONSTRAINT [PK_VS_Reports] PRIMARY KEY NONCLUSTERED ([ReportID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Reports_insert_update_trigger] ON [dbo].[VS_Reports]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ReportID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Reports CURSOR FOR 
		SELECT ReportID
		FROM inserted
	OPEN insert_cursor_VS_Reports
	FETCH NEXT FROM insert_cursor_VS_Reports 
	INTO @ReportID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ReportID IN (SELECT ReportID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Reports]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ReportID = @ReportID

		FETCH NEXT FROM insert_cursor_VS_Reports 
		INTO @ReportID
	END
	CLOSE insert_cursor_VS_Reports	
	DEALLOCATE insert_cursor_VS_Reports
END
GO