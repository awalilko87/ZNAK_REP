CREATE TABLE [dbo].[VS_TLines] (
  [TLineID] [nvarchar](50) NOT NULL,
  [FormID] [nvarchar](50) NULL,
  [Caption] [nvarchar](150) NULL,
  [FieldGroup] [nvarchar](50) NULL,
  [FieldStart] [nvarchar](50) NULL,
  [FieldEnd] [nvarchar](50) NULL,
  [FieldValue] [nvarchar](50) NULL,
  [FieldValueType] [nvarchar](3) NULL,
  [UnitTL1] [nvarchar](10) NULL,
  [UnitTL2] [nvarchar](10) NULL,
  [UnitTL3] [nvarchar](10) NULL,
  [AllowResizeH] [bit] NULL,
  [ShowGroupField] [bit] NULL,
  [CustomColor] [bit] NULL,
  [BGColor] [nvarchar](20) NULL,
  [BGColorStart] [nvarchar](20) NULL,
  [BGColorEnd] [nvarchar](20) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_TLines] PRIMARY KEY NONCLUSTERED ([TLineID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_TLines_insert_update_trigger] ON [dbo].[VS_TLines]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @TLineID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_TLines CURSOR FOR 
		SELECT TLineID
		FROM inserted
	OPEN insert_cursor_VS_TLines
	FETCH NEXT FROM insert_cursor_VS_TLines 
	INTO @TLineID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @TLineID IN (SELECT TLineID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_TLines]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE TLineID = @TLineID

		FETCH NEXT FROM insert_cursor_VS_TLines 
		INTO @TLineID
	END
	CLOSE insert_cursor_VS_TLines	
	DEALLOCATE insert_cursor_VS_TLines
END
GO