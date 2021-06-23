CREATE TABLE [dbo].[VS_Tabs] (
  [MenuID] [nvarchar](50) NOT NULL,
  [TabName] [nvarchar](50) NOT NULL,
  [MenuKey] [nvarchar](50) NULL,
  [TabCaption] [nvarchar](50) NULL,
  [FormID] [nvarchar](500) NULL,
  [Parameters] [nvarchar](500) NULL,
  [TabTooltip] [nvarchar](max) NULL,
  [Visible] [int] NULL,
  [TabOrder] [int] NULL,
  [TabType] [nvarchar](4) NULL,
  [NoUsed] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Tabs] PRIMARY KEY NONCLUSTERED ([MenuID], [TabName])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Tabs_insert_update_trigger] ON [dbo].[VS_Tabs]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @MenuID nvarchar(50),
			@TabName nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Tabs CURSOR FOR 
		SELECT MenuID, TabName
		FROM inserted
	OPEN insert_cursor_VS_Tabs
	FETCH NEXT FROM insert_cursor_VS_Tabs 
	INTO @MenuID, @TabName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @MenuID IN (SELECT MenuID FROM deleted WHERE TabName = @TabName)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Tabs]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE MenuID = @MenuID
		AND TabName = @TabName

		FETCH NEXT FROM insert_cursor_VS_Tabs 
		INTO @MenuID, @TabName
	END
	CLOSE insert_cursor_VS_Tabs	
	DEALLOCATE insert_cursor_VS_Tabs
END
GO