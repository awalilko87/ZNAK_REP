CREATE TABLE [dbo].[MODERN_PROFILE] (
  [MDP_ROWID] [int] IDENTITY,
  [MDP_CODE] [nvarchar](30) NULL,
  [MDP_DESC] [nvarchar](80) NULL,
  [MDP_CREDATE] [datetime] NULL,
  [MDP_CREUSER] [nvarchar](30) NULL,
  [MDP_UPDDATE] [datetime] NULL,
  [MDP_UPDUSER] [nvarchar](30) NULL
)
ON [PRIMARY]
GO