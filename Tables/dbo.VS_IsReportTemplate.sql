CREATE TABLE [dbo].[VS_IsReportTemplate] (
  [ReportID] [nvarchar](50) NOT NULL,
  [Template] [int] NULL,
  [ReportName] [nvarchar](200) NULL,
  [IsPrint] [int] NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL
)
ON [PRIMARY]
GO