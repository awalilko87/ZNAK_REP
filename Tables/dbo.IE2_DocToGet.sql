CREATE TABLE [dbo].[IE2_DocToGet] (
  [ROWID] [int] IDENTITY,
  [TYPE] [nvarchar](10) NOT NULL,
  [CODE] [nvarchar](30) NOT NULL,
  [TOGET] [tinyint] NOT NULL CONSTRAINT [DF_IE2_DocToGet_TOGET] DEFAULT (0),
  [STATION] [nvarchar](30) NULL,
  [CREDATE] [datetime] NULL CONSTRAINT [DF_IE2_DocToGet_CREDATE] DEFAULT (getdate()),
  [UPDDATE] [datetime] NULL,
  [MESSAGE] [nvarchar](1000) NULL
)
ON [PRIMARY]
GO