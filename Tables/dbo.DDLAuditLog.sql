CREATE TABLE [dbo].[DDLAuditLog] (
  [ID] [int] IDENTITY,
  [ActionTime] [datetime] NULL,
  [UserID] [varchar](256) NULL,
  [EventType] [varchar](256) NULL,
  [ObjectName] [varchar](256) NULL,
  [AppName] [varchar](256) NULL,
  [HostName] [varchar](256) NULL,
  [EventData] [xml] NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO