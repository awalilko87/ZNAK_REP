CREATE TABLE [dbo].[SYDocListFilters] (
  [FilterID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListFilters_FilterID] DEFAULT (''),
  [DocTypeID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListFilters_DocTypeID] DEFAULT (''),
  [LabelText] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYDocListFilters_LabelText] DEFAULT (''),
  [LabelWidth] [bigint] NOT NULL CONSTRAINT [DF_SYDocListFilters_LabelWidth] DEFAULT (0),
  [FilterType] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListFilters_FilterType] DEFAULT (''),
  [FilterWidth] [bigint] NOT NULL CONSTRAINT [DF_SYDocListFilters_FilterWidth] DEFAULT (0),
  [DefaultValue] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYDocListFilters_DefaultValue] DEFAULT (''),
  [FilterOrder] [int] NOT NULL CONSTRAINT [DF_SYDocListFilters_FilterOrder] DEFAULT (0),
  [Roles] [nvarchar](2000) NOT NULL CONSTRAINT [DF_SYDocListFilters_Roles] DEFAULT (''),
  [DataSource] [nvarchar](max) NOT NULL CONSTRAINT [DF_SYDocListFilters_DataSource] DEFAULT (''),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [Visible] [bit] NOT NULL CONSTRAINT [DF_SYDocListFilters_Visible] DEFAULT (0),
  CONSTRAINT [PK_SYDocListFilters] PRIMARY KEY NONCLUSTERED ([FilterID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYDocListFilters_insert_update_trigger] ON [dbo].[SYDocListFilters]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FilterID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYDocListFilters CURSOR FOR 
		SELECT FilterID
		FROM inserted
	OPEN insert_cursor_SYDocListFilters
	FETCH NEXT FROM insert_cursor_SYDocListFilters 
	INTO @FilterID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FilterID IN (SELECT FilterID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYDocListFilters]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FilterID = @FilterID

		FETCH NEXT FROM insert_cursor_SYDocListFilters 
		INTO @FilterID
	END
	CLOSE insert_cursor_SYDocListFilters	
	DEALLOCATE insert_cursor_SYDocListFilters
END
GO