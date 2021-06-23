CREATE TABLE [dbo].[ZWFOT_SAP_MESSAGES] (
  [OTM_OTID] [int] NULL,
  [OTM_OTXXID] [int] NULL,
  [OTM_DATE] [datetime] NULL,
  [OTM_OT_TYPE] [nvarchar](10) NULL,
  [OTM_TYPE] [nvarchar](10) NULL,
  [OTM_MESSAGE] [nvarchar](max) NULL,
  [OTM_ERRID] [int] NULL,
  [OTM_USERID] [nvarchar](30) NULL,
  [OTM_STAID] [int] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO