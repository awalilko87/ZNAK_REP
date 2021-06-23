CREATE TABLE [dbo].[SAPIO_Statuses] (
  [SAS_ROWID] [int] NOT NULL,
  [SAS_CODE] [nvarchar](30) NULL,
  [SAS_DESC] [nvarchar](250) NULL,
  [SAS_UPDUSER] [nvarchar](30) NULL,
  [SAS_UPDDATE] [datetime] NULL,
  [SAS_CREUSER] [nvarchar](30) NOT NULL,
  [SAS_CREDATE] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([SAS_ROWID])
)
ON [PRIMARY]
GO