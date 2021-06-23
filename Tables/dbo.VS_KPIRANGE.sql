CREATE TABLE [dbo].[VS_KPIRANGE] (
  [KPR_ID] [nvarchar](50) NOT NULL DEFAULT (newid()),
  [ROWID] [int] IDENTITY,
  [KPR_KPIID] [int] NOT NULL,
  [KPR_FROM] [int] NOT NULL,
  [KPR_TO] [int] NULL,
  [KPR_IMAGE] [nvarchar](255) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  CONSTRAINT [PK_VS_KPIRANGE] PRIMARY KEY NONCLUSTERED ([KPR_FROM], [KPR_KPIID])
)
ON [PRIMARY]
GO