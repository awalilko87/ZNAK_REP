CREATE TABLE [dbo].[VS_DataSpy] (
  [DataSpyID] [nvarchar](50) NOT NULL CONSTRAINT [DF_VS_DataSpy_DataSpyID] DEFAULT (newid()),
  [FormID] [nvarchar](50) NULL,
  [ParentID] [nvarchar](50) NULL,
  [SpyName] [nvarchar](100) NULL,
  [BrackedLeft] [bit] NULL,
  [BrackedRight] [bit] NULL,
  [FilterField] [nvarchar](250) NULL,
  [FilterType] [int] NULL,
  [FilterValue] [nvarchar](500) NULL,
  [FilterOperator] [nvarchar](3) NULL,
  [SpyOrder] [int] NULL,
  [IsPublic] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [CustOrder] [nvarchar](150) NULL,
  [IsPrivate] [bit] NULL,
  [IsGroup] [bit] NULL,
  [UserID] [nvarchar](30) NULL,
  [IsTemp] [bit] NULL,
  [Created] [datetime] NULL,
  [IsSite] [bit] NULL,
  [IsDepartment] [bit] NULL,
  [OutputWhere] [nvarchar](max) NULL,
  [CustomWhere] [nvarchar](max) NULL,
  [CustomWhereOperator] [nvarchar](3) NULL,
  [FilterTypeName] [nvarchar](30) NULL,
  [FilterValueTwo] [nvarchar](500) NULL,
  [BrackedLeftCount] [int] NULL,
  [BrackedRightCount] [int] NULL,
  CONSTRAINT [PK_VS_DataSpy] PRIMARY KEY NONCLUSTERED ([DataSpyID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TGR_DataSpy_tmp_delete]
ON [dbo].[VS_DataSpy] 
AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete v
	from dbo.VS_DataSpy v (nolock) 
	inner join inserted i on  i.UserID = v.UserID 
							and i.FormID = v.FormID 
							and i.IsTemp = v.IsTemp
							and i.IsTemp = 1
							and i.DataSpyID <> v.DataSpyID
END

GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_DataSpy_insert_update_trigger] ON [dbo].[VS_DataSpy]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @DataSpyID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_DataSpy CURSOR FOR 
		SELECT DataSpyID
		FROM inserted
	OPEN insert_cursor_VS_DataSpy
	FETCH NEXT FROM insert_cursor_VS_DataSpy 
	INTO @DataSpyID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @DataSpyID IN (SELECT DataSpyID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_DataSpy]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE DataSpyID = @DataSpyID

		FETCH NEXT FROM insert_cursor_VS_DataSpy 
		INTO @DataSpyID
	END
	CLOSE insert_cursor_VS_DataSpy	
	DEALLOCATE insert_cursor_VS_DataSpy
END
GO