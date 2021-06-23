CREATE TABLE [dbo].[VS_KPI] (
  [ROWID] [int] IDENTITY,
  [KPI_ID] [int] NOT NULL,
  [KPI_DESC] [nvarchar](80) NULL,
  [KPI_SOURCE] [nvarchar](max) NULL,
  [KPI_WHERE] [nvarchar](max) NULL,
  [KPI_RPT] [nvarchar](max) NULL,
  [KPI_LINK] [nvarchar](max) NULL,
  [KPI_DEFIMAGE] [nvarchar](255) NULL,
  [KPI_ACTIVE] [int] NULL,
  [KPI_ORDER] [int] NULL,
  [KPI_TYPE] [bit] NULL,
  [RPT_TYPE] [bit] NULL,
  [INBOX_TYPE] [bit] NULL,
  [CHART_TYPE] [bit] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [KPI_FORMID] [nvarchar](50) NULL,
  [KPI_DATASPY] [nvarchar](100) NULL,
  [KPI_FONTSIZE] [int] NULL,
  [RSS_TYPE] [bit] NULL,
  CONSTRAINT [PK_VS_KPI] PRIMARY KEY NONCLUSTERED ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO