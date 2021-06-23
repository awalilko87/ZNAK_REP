CREATE TABLE [dbo].[SAPI_DocStatus_Legend] (
  [SAP_STAT_CODE] [nvarchar](30) NOT NULL,
  [SAP_DESCRIPTION] [nvarchar](255) NULL,
  [OT11] [nvarchar](30) NULL,
  [OT12] [nvarchar](30) NULL,
  [OT21] [nvarchar](30) NULL,
  [OT31] [nvarchar](30) NULL,
  [OT32] [nvarchar](30) NULL,
  [OT33] [nvarchar](30) NULL,
  [OT40] [nvarchar](30) NULL,
  [OT41] [nvarchar](30) NULL,
  [OT42] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPI_DocStatus_Legend] PRIMARY KEY CLUSTERED ([SAP_STAT_CODE])
)
ON [PRIMARY]
GO