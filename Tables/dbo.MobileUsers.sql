CREATE TABLE [dbo].[MobileUsers] (
  [UserID] [nvarchar](20) NOT NULL CONSTRAINT [DF_MobileUsers_UserID] DEFAULT (''),
  [UserName] [nvarchar](100) NOT NULL CONSTRAINT [DF_MobileUsers_UserName] DEFAULT (''),
  [Password] [nvarchar](50) NOT NULL CONSTRAINT [DF_MobileUsers_Password] DEFAULT (''),
  [Module] [nvarchar](20) NULL CONSTRAINT [DF_MobileUsers_Module] DEFAULT (''),
  [UserGroupID] [nvarchar](20) NULL CONSTRAINT [DF_MobileUsers_UserGroupID] DEFAULT (''),
  [LangID] [nvarchar](10) NULL,
  [Admin] [bit] NOT NULL CONSTRAINT [DF_MobileUsers_Admin] DEFAULT (0),
  [NoActive] [bit] NOT NULL CONSTRAINT [DF_MobileUsers_NoActive] DEFAULT (0),
  [orgguid] [uniqueidentifier] NULL,
  [rowguid] [uniqueidentifier] NULL CONSTRAINT [DF_MobileUsers_rowguid] DEFAULT (newid()),
  CONSTRAINT [PK_MobileUsers] PRIMARY KEY NONCLUSTERED ([UserID])
)
ON [PRIMARY]
GO