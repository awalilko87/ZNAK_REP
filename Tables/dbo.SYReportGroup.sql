CREATE TABLE [dbo].[SYReportGroup] (
  [ReportGroupId] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReportGroup_ReportGroupId] DEFAULT (''),
  [ReportGroupName] [nvarchar](50) NULL,
  [VisibilityFlags] [nvarchar](200) NULL,
  [OrderByClause] [numeric](18, 5) NULL,
  [MenuItemID] [nvarchar](50) NULL,
  [DefaultReport] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [IsVisible] [bit] NULL,
  CONSTRAINT [PK_SYReportGroup] PRIMARY KEY NONCLUSTERED ([ReportGroupId])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYReportGroup_insert_update_trigger] ON [dbo].[SYReportGroup]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ReportGroupId nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYReportGroup CURSOR FOR 
		SELECT ReportGroupId
		FROM inserted
	OPEN insert_cursor_SYReportGroup
	FETCH NEXT FROM insert_cursor_SYReportGroup 
	INTO @ReportGroupId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ReportGroupId IN (SELECT ReportGroupId FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYReportGroup]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ReportGroupId = @ReportGroupId

		FETCH NEXT FROM insert_cursor_SYReportGroup 
		INTO @ReportGroupId
	END
	CLOSE insert_cursor_SYReportGroup	
	DEALLOCATE insert_cursor_SYReportGroup
END
GO