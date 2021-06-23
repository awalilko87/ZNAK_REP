CREATE TABLE [dbo].[ASPStateTempSessions] (
  [SessionId] [nvarchar](88) NOT NULL,
  [Created] [datetime] NOT NULL CONSTRAINT [DF_ASPStateTempSessions_Created] DEFAULT (getutcdate()),
  [Expires] [datetime] NOT NULL,
  [LockDate] [datetime] NOT NULL,
  [LockDateLocal] [datetime] NOT NULL,
  [LockCookie] [int] NOT NULL,
  [Timeout] [int] NOT NULL,
  [Locked] [bit] NOT NULL,
  [SessionItemShort] [image] NULL,
  [SessionItemLong] [image] NULL,
  [Flags] [int] NOT NULL CONSTRAINT [DF_ASPStateTempSessions_Flags] DEFAULT (0),
  CONSTRAINT [PK_ASPStateTempSessions] PRIMARY KEY NONCLUSTERED ([SessionId])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO