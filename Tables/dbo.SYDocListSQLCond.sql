CREATE TABLE [dbo].[SYDocListSQLCond] (
  [ConditionID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_ConditionID] DEFAULT (newid()),
  [DocID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_DocID] DEFAULT (''),
  [FieldID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_FieldID] DEFAULT (''),
  [Operator] [int] NOT NULL CONSTRAINT [DF_SYDocListSQLCond_Operator] DEFAULT (0),
  [Value1] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_Value1] DEFAULT (''),
  [Value1Type] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_Value1Type] DEFAULT (''),
  [Value2] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_Value2] DEFAULT (''),
  [Value2Type] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_Value2Type] DEFAULT (''),
  [ForeColor] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_ForeColor] DEFAULT (''),
  [BackColor] [nvarchar](10) NOT NULL CONSTRAINT [DF_SYDocListSQLCond_BackColor] DEFAULT (''),
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [FontBold] [bit] NOT NULL CONSTRAINT [DF_SYDocListSQLCond_FontBold] DEFAULT (''),
  CONSTRAINT [PK_SYDocListSQLCond] PRIMARY KEY NONCLUSTERED ([ConditionID], [DocID], [FieldID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYDocListSQLCond_insert_update_trigger] ON [dbo].[SYDocListSQLCond]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ConditionID nvarchar(50),
			@DocID nvarchar(50),
			@FieldID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYDocListSQLCond CURSOR FOR 
		SELECT ConditionID, DocID, FieldID
		FROM inserted
	OPEN insert_cursor_SYDocListSQLCond
	FETCH NEXT FROM insert_cursor_SYDocListSQLCond 
	INTO @ConditionID, @DocID, @FieldID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ConditionID IN (SELECT ConditionID FROM deleted WHERE DocID = @DocID AND FieldID = @FieldID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYDocListSQLCond]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ConditionID = @ConditionID
		AND FieldID = @FieldID
		AND DocID = @DocID

		FETCH NEXT FROM insert_cursor_SYDocListSQLCond 
		INTO @ConditionID, @DocID, @FieldID
	END
	CLOSE insert_cursor_SYDocListSQLCond	
	DEALLOCATE insert_cursor_SYDocListSQLCond
END
GO