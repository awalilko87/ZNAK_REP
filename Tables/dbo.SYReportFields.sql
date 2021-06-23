CREATE TABLE [dbo].[SYReportFields] (
  [ReportID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReportFields_ReportID] DEFAULT (''),
  [FieldID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReportFields_FieldID] DEFAULT (''),
  [Caption] [nvarchar](100) NULL,
  [FieldType] [nvarchar](1) NULL,
  [RowSQL] [nvarchar](500) NULL,
  [EmptyValue] [nvarchar](1) NULL,
  [OrderByClause] [numeric](18, 5) NULL,
  [DefLength] [numeric](18, 5) NULL,
  [DefListHeight] [numeric](18, 5) NULL,
  [SQLFieldToDisp] [nvarchar](50) NULL,
  [SQLFieldToKey] [nvarchar](50) NULL,
  [HostFieldName] [nvarchar](50) NULL,
  [DefaultValue] [nvarchar](500) NULL,
  [Height] [int] NOT NULL CONSTRAINT [DF_SYReportFields_Height] DEFAULT (0),
  [Width] [int] NOT NULL CONSTRAINT [DF_SYReportFields_Width] DEFAULT (0),
  [NoUsed] [bit] NULL,
  [Description] [nvarchar](max) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [AllowEmpty] [bit] NULL,
  CONSTRAINT [PK_SYReportFields] PRIMARY KEY NONCLUSTERED ([ReportID], [FieldID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYReportFields_insert_update_trigger] ON [dbo].[SYReportFields]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ReportID nvarchar(50),
			@FieldID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYReportFields CURSOR FOR 
		SELECT ReportID, FieldID
		FROM inserted
	OPEN insert_cursor_SYReportFields
	FETCH NEXT FROM insert_cursor_SYReportFields 
	INTO @ReportID, @FieldID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ReportID IN (SELECT ReportID FROM deleted WHERE FieldID = @FieldID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYReportFields]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ReportID = @ReportID
		AND FieldID = @FieldID

		FETCH NEXT FROM insert_cursor_SYReportFields 
		INTO @ReportID, @FieldID
	END
	CLOSE insert_cursor_SYReportFields	
	DEALLOCATE insert_cursor_SYReportFields
END
GO