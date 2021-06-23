CREATE TABLE [dbo].[SYUsers] (
  [UserID] [nvarchar](30) NOT NULL CONSTRAINT [DF_SYUsers_UserID] DEFAULT (''),
  [UserName] [nvarchar](100) NOT NULL CONSTRAINT [DF_SYUsers_UserName] DEFAULT (''),
  [Password] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUsers_Password] DEFAULT (''),
  [ADLogin] [nvarchar](30) NULL,
  [UserGroupID] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYUsers_UserGroupID] DEFAULT (''),
  [NoActive] [bit] NOT NULL CONSTRAINT [DF_SYUsers_NoActive] DEFAULT (0),
  [DefUrl] [nvarchar](1000) NULL,
  [LangID] [nvarchar](10) NULL,
  [SiteID] [nvarchar](20) NOT NULL CONSTRAINT [DF_SYUsers_SiteID] DEFAULT (''),
  [Email] [nvarchar](80) NULL CONSTRAINT [DF_SYUsers_Email] DEFAULT (''),
  [PasswordLastChange] [datetime] NULL,
  [AccountExpirationDate] [datetime] NULL,
  [DateLocked] [datetime] NULL,
  [Violations] [int] NOT NULL CONSTRAINT [DF_SYUsers_Violations] DEFAULT (0),
  [PIN] [nvarchar](4) NULL CONSTRAINT [DF_SYUsers_PIN] DEFAULT (''),
  [UserSignature] [nvarchar](100) NULL CONSTRAINT [DF_SYUsers_UserSignature] DEFAULT (''),
  [Module] [nvarchar](20) NULL CONSTRAINT [DF_SYUsers_Module] DEFAULT (''),
  [DepartmentID] [nvarchar](50) NULL CONSTRAINT [DF_SYUsers_DepartmentID] DEFAULT (''),
  [ASOID] [nvarchar](20) NULL CONSTRAINT [DF_SYUsers_ASOID] DEFAULT (''),
  [ScheduleFlags] [int] NOT NULL CONSTRAINT [DF_SYUsers_ScheduleFlags] DEFAULT (0),
  [MessageRights] [bigint] NULL CONSTRAINT [DF_SYUsers_MessageRights] DEFAULT (0),
  [MessagePhone] [nvarchar](50) NULL CONSTRAINT [DF_SYUsers_MessagePhone] DEFAULT (''),
  [MessageEmail] [nvarchar](50) NULL CONSTRAINT [DF_SYUsers_MessageEmail] DEFAULT (''),
  [FileID] [nvarchar](50) NULL,
  [InternalPhoneNumber] [int] NULL,
  [KPIorCal] [nvarchar](5) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [LastSuccessfulLogin] [datetime] NULL,
  [LastFailedLogin] [datetime] NULL,
  [MobileUser] [bit] NULL CONSTRAINT [DF_SYUsers_MobileUser] DEFAULT (0),
  [MobileAuthUser] [bit] NULL CONSTRAINT [DF_SYUsers_MobileAuthUser] DEFAULT (0),
  [ManageDataSpy] [bit] NOT NULL CONSTRAINT [DF_SYUsers_ManageDataSpy] DEFAULT (1),
  [UserGroupID2] [nvarchar](50) NOT NULL CONSTRAINT [DF_SYUsers_UserGroupID2] DEFAULT (''),
  [DefWorkerID] [nvarchar](30) NULL CONSTRAINT [DF_SYUsers_DefWorkerID] DEFAULT (''),
  [Admin] [bit] NOT NULL CONSTRAINT [DF_SYUsers_Admin] DEFAULT (0),
  [CreatedOn] [datetime] NULL,
  [User_STNID] [int] NULL,
  [tmpSiteID] [nvarchar](20) NULL,
  [SAPLogin] [nvarchar](30) NULL,
  [SAPRealizator] [int] NULL,
  [FirstName] [nvarchar](30) NULL,
  [LastName] [nvarchar](80) NULL,
  [LoginWith2fa] [bit] NOT NULL CONSTRAINT [DF_SYUsers_LoginWith2fa] DEFAULT (0),
  [POT_Rozliczenie] [int] NULL,
  [CPO_ROZLICZANIE] [bit] NULL,
  CONSTRAINT [PK_SYUsers] PRIMARY KEY CLUSTERED ([UserID])
)
ON [PRIMARY]
GO

CREATE INDEX [E2IDX_USR01]
  ON [dbo].[SYUsers] ([SAPRealizator])
  INCLUDE ([Email], [SAPLogin], [FirstName], [LastName])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[SYUsers_insert_update_trigger] ON [dbo].[SYUsers]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @UserID nvarchar(30),
			@Description nvarchar(255)

	DECLARE insert_cursor_SYUsers CURSOR FOR 
		SELECT UserID
		FROM inserted
	OPEN insert_cursor_SYUsers
	FETCH NEXT FROM insert_cursor_SYUsers 
	INTO @UserID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @UserID IN (SELECT UserID FROM deleted)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[SYUsers]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE UserID = @UserID

		FETCH NEXT FROM insert_cursor_SYUsers 
		INTO @UserID
	END
	CLOSE insert_cursor_SYUsers	
	DEALLOCATE insert_cursor_SYUsers
END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [dbo].[UserSetSTNID]
on [dbo].[SYUsers]
after insert
as
begin
	update u set
		 User_STNID = (select STN_ROWID from dbo.STATION where STN_CODE = substring(u.UserID,3,20) and STN_TYPE = 'STACJA')
		,DefUrl = '/Tabs3.aspx/?MID=ZMT_SP_OBJ_LS&TGR=ZMT_SP_OBJ&TAB=SP_OBJ_LS&FID=SP_OBJ_LS'
		,Module = 'ZMT'
	from dbo.SYUsers u
	inner join inserted i on i.UserID = u.UserID and left(i.UserID,2) = 'SP' and i.UserGroupID = 'SP'
end
GO