CREATE TABLE [dbo].[VS_KpiMessages] (
  [MessId] [int] IDENTITY,
  [Mess] [nvarchar](4000) NOT NULL,
  [UserID] [nvarchar](30) NULL,
  [GroupId] [nvarchar](20) NULL,
  [CreaDate] [datetime] NOT NULL CONSTRAINT [DF_VS_KpiMessages_CreaDate] DEFAULT (getdate()),
  [Flag] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_KpiMessages] PRIMARY KEY NONCLUSTERED ([MessId])
)
ON [PRIMARY]
GO