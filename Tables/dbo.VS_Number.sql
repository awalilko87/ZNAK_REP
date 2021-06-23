CREATE TABLE [dbo].[VS_Number] (
  [ID] [nvarchar](50) NOT NULL,
  [Pref] [nvarchar](50) NOT NULL,
  [No] [int] NULL,
  [Suf] [nvarchar](50) NOT NULL,
  [LastNo] [nvarchar](50) NULL,
  [MaxNo] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [LenNo] [int] NULL,
  CONSTRAINT [PK_VS_Number] PRIMARY KEY NONCLUSTERED ([ID], [Pref], [Suf])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_Number_insert_update_trigger] ON [dbo].[VS_Number]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @ID nvarchar(50),
			@Pref nvarchar(50),
			@Suf nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_Number CURSOR FOR 
		SELECT ID, Pref, Suf
		FROM inserted
	OPEN insert_cursor_VS_Number
	FETCH NEXT FROM insert_cursor_VS_Number 
	INTO @ID, @Pref, @Suf
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ID IN (SELECT ID FROM deleted WHERE Pref = @Pref AND Suf = @Suf)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_Number]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE ID = @ID
		AND Pref = @Pref
		AND Suf = @Suf

		FETCH NEXT FROM insert_cursor_VS_Number 
		INTO @ID, @Pref, @Suf
	END
	CLOSE insert_cursor_VS_Number	
	DEALLOCATE insert_cursor_VS_Number
END
GO