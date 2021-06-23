CREATE TABLE [dbo].[SYReportSelects] (
  [ReportID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReportSelects_ReportID] DEFAULT (''),
  [TableName] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYReportSelects_TableName] DEFAULT (''),
  [SQLStmt] [nvarchar](max) NULL CONSTRAINT [DF_SYReportSelects_SQLStmt] DEFAULT (''),
  [HostFieldName] [nvarchar](50) NULL CONSTRAINT [DF_SYReportSelects_HostFieldName] DEFAULT (''),
  [Sheet] [int] NULL,
  [GlobalSett] [bit] NULL,
  [BLeft] [bit] NULL,
  [BTop] [bit] NULL,
  [BBottom] [bit] NULL,
  [BRight] [bit] NULL,
  [ForeColor] [nvarchar](10) NULL,
  [ForeColorAlt] [nvarchar](10) NULL,
  [Font] [nvarchar](50) NULL,
  [FontSize] [int] NULL,
  [BGColor] [nvarchar](10) NULL,
  [BGColorAlt] [nvarchar](10) NULL,
  [SheetName] [nvarchar](50) NULL,
  [MainObject] [nvarchar](50) NULL,
  [OrderBy] [int] NULL,
  [Dynamic] [bit] NULL,
  [DynamicStartPos] [nvarchar](50) NULL,
  [Description] [nvarchar](max) NULL,
  [BLeftWeight] [nvarchar](15) NULL,
  [BTopWeight] [nvarchar](15) NULL,
  [BBottomWeight] [nvarchar](15) NULL,
  [BRightWeight] [nvarchar](15) NULL,
  [BLeftLineStyle] [nvarchar](15) NULL,
  [BTopLineStyle] [nvarchar](15) NULL,
  [BBottomLineStyle] [nvarchar](15) NULL,
  [BRightLineStyle] [nvarchar](15) NULL,
  [TextQuantifier] [nvarchar](50) NULL,
  [NoUsed] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYReportSelects] PRIMARY KEY NONCLUSTERED ([ReportID], [TableName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYReportSelects_insert_update_trigger] ON [dbo].[SYReportSelects]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @TableName nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYReportSelects CURSOR FOR 
		SELECT TableName
		FROM inserted
	OPEN insert_cursor_SYReportSelects
	FETCH NEXT FROM insert_cursor_SYReportSelects 
	INTO @TableName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @TableName IN (SELECT TableName FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYReportSelects]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE TableName = @TableName

		FETCH NEXT FROM insert_cursor_SYReportSelects 
		INTO @TableName
	END
	CLOSE insert_cursor_SYReportSelects	
	DEALLOCATE insert_cursor_SYReportSelects
END
GO