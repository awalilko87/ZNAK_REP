CREATE TABLE [dbo].[E2KMAILS] (
  [ID] [int] NOT NULL,
  [MGTYPE] [nvarchar](50) NOT NULL,
  [TO] [nvarchar](500) NOT NULL,
  [DW] [nvarchar](500) NOT NULL,
  [SUBJECT] [nvarchar](100) NOT NULL,
  [STATUS] [nvarchar](20) NOT NULL,
  [REPORTNAME] [nvarchar](200) NOT NULL,
  [REPORTPARAMS] [nvarchar](500) NOT NULL,
  [SOURCE] [nvarchar](50) NOT NULL,
  [CREATEDATE] [datetime] NOT NULL,
  [ATTACHNAME] [nvarchar](200) NULL,
  [TABLENAME] [nvarchar](50) NULL,
  [TABLEROWID] [int] NULL,
  [REPORT_FORMAT_TYPE] [nvarchar](3) NULL,
  [MESSAGE] [nvarchar](max) NULL,
  [ATTACH] [varbinary](max) NULL,
  CONSTRAINT [PK_E2KMAILS] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO