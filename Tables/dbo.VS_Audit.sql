CREATE TABLE [dbo].[VS_Audit] (
  [AuditID] [nvarchar](50) NOT NULL,
  [TableName] [nvarchar](50) NULL,
  [FieldName] [nvarchar](50) NULL,
  [RowID] [nvarchar](400) NULL,
  [UserID] [nvarchar](30) NULL,
  [DateWhen] [datetime] NULL CONSTRAINT [DF_VS_Audit_DateWhen] DEFAULT (getdate()),
  [OldValue] [nvarchar](max) NULL,
  [NewValue] [nvarchar](max) NULL,
  [TableRowID] [nvarchar](100) NULL,
  [SystemID] [nvarchar](30) NOT NULL,
  [Oper] [nvarchar](10) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_Audit] PRIMARY KEY NONCLUSTERED ([AuditID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Audit_insert_update_trigger] ON [dbo].[VS_Audit]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @AuditID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Audit CURSOR FOR 
		SELECT AuditID
		FROM inserted
	OPEN insert_cursor_VS_Audit
	FETCH NEXT FROM insert_cursor_VS_Audit 
	INTO @AuditID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @AuditID IN (SELECT AuditID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Audit]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE AuditID = @AuditID

		FETCH NEXT FROM insert_cursor_VS_Audit 
		INTO @AuditID
	END
	CLOSE insert_cursor_VS_Audit	
	DEALLOCATE insert_cursor_VS_Audit
END
GO