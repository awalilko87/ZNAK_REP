CREATE TABLE [dbo].[SYUsers_historia] (
  [ID] [int] IDENTITY,
  [UserID] [nvarchar](30) NOT NULL CONSTRAINT [DF_SYUsers_historia_UserID] DEFAULT (''),
  [Password] [nvarchar](50) NOT NULL,
  [ChangePassDate] [datetime] NOT NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_SYUsers_historia] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
GO