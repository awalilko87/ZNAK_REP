CREATE TABLE [dbo].[SYDocListSQLFD] (
  [DocID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_DocID] DEFAULT (''),
  [FieldID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_FieldID] DEFAULT (''),
  [Caption] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Caption] DEFAULT (''),
  [Width] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Width] DEFAULT (0),
  [Format] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Format] DEFAULT (''),
  [Justification] [nvarchar](1) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Justification] DEFAULT (''),
  [Calculate] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Calculate] DEFAULT (''),
  [Remarks] [nvarchar](1000) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Remarks] DEFAULT (''),
  [ColOrder] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColOrder] DEFAULT (-1),
  [FType] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_FType] DEFAULT (''),
  [ColTop] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColTop] DEFAULT (0),
  [ColLeft] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColLeft] DEFAULT (0),
  [ColWidth] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColWidth] DEFAULT (1),
  [ColHeight] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColHeight] DEFAULT (1),
  [ColSetNmbr] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColSetNmbr] DEFAULT (-1),
  [ColBackColor] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColBackColor] DEFAULT (''),
  [ColForeColor] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColForeColor] DEFAULT (''),
  [SumaryDisplayFormat] [nvarchar](50) NULL CONSTRAINT [DF_SYDocListSQLFD_SumaryDisplayFormat] DEFAULT (''),
  [SumaryType] [int] NULL CONSTRAINT [DF_SYDocListSQLFD_SumaryType] DEFAULT (6),
  [GroupSumaryDisplayFormat] [nvarchar](50) NULL CONSTRAINT [DF_SYDocListSQLFD_GroupSumaryDisplayFormat] DEFAULT (''),
  [GroupSumaryType] [int] NULL CONSTRAINT [DF_SYDocListSQLFD_GroupSumaryType] DEFAULT (6),
  [GroupSumaryColumnOnly] [int] NULL CONSTRAINT [DF_SYDocListSQLFD_GroupSumaryColumnOnly] DEFAULT (1),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [Visible] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_Visible] DEFAULT (0),
  [ColBold] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQLFD_ColBold] DEFAULT (0),
  CONSTRAINT [PK_SYDocListSQLFD] PRIMARY KEY NONCLUSTERED ([DocID], [FieldID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYDocListSQLFD_insert_update_trigger] ON [dbo].[SYDocListSQLFD]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DocID nvarchar(50),
			@FieldID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYDocListSQLFD CURSOR FOR 
		SELECT DocID, FieldID
		FROM inserted
	OPEN insert_cursor_SYDocListSQLFD
	FETCH NEXT FROM insert_cursor_SYDocListSQLFD 
	INTO @DocID, @FieldID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DocID IN (SELECT DocID FROM deleted WHERE FieldID = @FieldID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYDocListSQLFD]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DocID = @DocID
		AND FieldID = @FieldID

		FETCH NEXT FROM insert_cursor_SYDocListSQLFD 
		INTO @DocID, @FieldID
	END
	CLOSE insert_cursor_SYDocListSQLFD	
	DEALLOCATE insert_cursor_SYDocListSQLFD
END
GO