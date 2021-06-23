CREATE TABLE [dbo].[M_AST_INW] (
  [ROWGUID] [uniqueidentifier] NULL,
  [ROWID] [int] IDENTITY,
  [SIN_CODE] [nvarchar](60) NULL,
  [SIN_DESC] [nvarchar](60) NULL,
  [SIN_DATE] [nvarchar](60) NULL,
  [SIN_RESPON_DESC] [nvarchar](80) NULL,
  [SIN_STATUS] [nvarchar](30) NULL,
  [SIN_STATUS_DESC] [nvarchar](80) NULL,
  [SIN_ORG] [nvarchar](60) NULL,
  CONSTRAINT [PK_M_AST_INW] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO