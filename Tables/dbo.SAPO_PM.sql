CREATE TABLE [dbo].[SAPO_PM] (
  [PM_ROWID] [int] IDENTITY,
  [PM_OPER_TYPE] [nvarchar](30) NULL,
  [PM_ZMT_EQUNR] [nvarchar](80) NULL,
  [PM_IF_STATUS] [int] NULL DEFAULT (0),
  [PM_IF_SENTDATE] [datetime] NULL,
  [PM_IF_ERR] [nvarchar](max) NULL,
  [PM_IF_EQUNR] [nvarchar](30) NULL,
  [PM_ZMT_ROWID] [int] NULL,
  [PM_SAPUSER] [nvarchar](12) NULL,
  [PM_CREDATE] [datetime] NULL CONSTRAINT [DF_PM_CREDATE] DEFAULT (getdate()),
  CONSTRAINT [PK_SAPO_PM] PRIMARY KEY CLUSTERED ([PM_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO