CREATE TABLE [dbo].[STAMAIL] (
  [ROWID] [int] IDENTITY,
  [STM_USERID] [nvarchar](30) NULL,
  [STM_STATUS] [nvarchar](30) NULL,
  [STM_ENTITY] [nvarchar](30) NULL,
  [STM_CHNG] [int] NULL,
  [STM_P3D] [int] NULL,
  [STM_UPDUSER] [nvarchar](30) NULL,
  [STM_UPDDATE] [datetime] NULL
)
ON [PRIMARY]
GO