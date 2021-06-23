CREATE TABLE [dbo].[MODERN_PROFILE_LN] (
  [MDL_ROWID] [int] IDENTITY,
  [MDL_MDPID] [int] NULL,
  [MDL_KSTCODE] [nvarchar](30) NULL,
  [MDL_CREDATE] [datetime] NULL,
  [MDL_CREUSER] [nvarchar](30) NULL,
  [MDL_UPDDATE] [datetime] NULL,
  [MDL_UPDUSER] [nvarchar](30) NULL
)
ON [PRIMARY]
GO