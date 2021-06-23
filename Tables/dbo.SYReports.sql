CREATE TABLE [dbo].[SYReports] (
  [ReportID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReports_ReportID] DEFAULT (''),
  [ReportGroupID] [nvarchar](50) NULL CONSTRAINT [DF_SYReports_ReportGroupID] DEFAULT (''),
  [ReportName] [nvarchar](50) NULL CONSTRAINT [DF_SYReports_ReportName] DEFAULT (''),
  [VisibilityFlags] [nvarchar](200) NULL CONSTRAINT [DF_SYReports_VisibilityFlags] DEFAULT (''),
  [OrderByClause] [numeric](18, 5) NULL CONSTRAINT [DF_SYReports_OrderByClause] DEFAULT (0),
  [ReportCaption] [nvarchar](500) NULL CONSTRAINT [DF_SYReports_ReportCaption] DEFAULT (''),
  [ReportType] [nvarchar](10) NULL CONSTRAINT [DF_SYReports_ReportType] DEFAULT (''),
  [DescAdmin] [nvarchar](2000) NULL CONSTRAINT [DF_SYReports_DescAdmin] DEFAULT (''),
  [DescUser] [nvarchar](max) NULL CONSTRAINT [DF_SYReports_DescUser] DEFAULT (''),
  [ConnType] [nvarchar](50) NULL CONSTRAINT [DF_SYReports_ConnType] DEFAULT ('OLEDB'),
  [RptFileID] [int] NULL,
  [FileInDB] [bit] NULL CONSTRAINT [DF_SYReports_FileInDB] DEFAULT (1),
  [OutputType] [nvarchar](10) NULL,
  [IsVisible] [bit] NULL CONSTRAINT [DF_SYReports_IsVisible] DEFAULT (0),
  [RptFileID2] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [ConnectionString] [nvarchar](30) NULL,
  CONSTRAINT [PK_SYReports] PRIMARY KEY NONCLUSTERED ([ReportID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYReports_insert_update_trigger] ON [dbo].[SYReports]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ReportID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYReports CURSOR FOR 
		SELECT ReportID
		FROM inserted
	OPEN insert_cursor_SYReports
	FETCH NEXT FROM insert_cursor_SYReports 
	INTO @ReportID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ReportID IN (SELECT ReportID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYReports]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ReportID = @ReportID

		FETCH NEXT FROM insert_cursor_SYReports 
		INTO @ReportID
	END
	CLOSE insert_cursor_SYReports	
	DEALLOCATE insert_cursor_SYReports
END
GO