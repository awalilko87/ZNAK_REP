CREATE TABLE [dbo].[SAPO_ZWFOT32DON] (
  [OT32DON_ROWID] [int] IDENTITY,
  [OT32DON_LP] [int] NULL,
  [OT32DON_BUKRS] [nvarchar](12) NULL,
  [OT32DON_ANLN1] [nvarchar](12) NULL,
  [OT32DON_ANLN2] [nvarchar](8) NULL,
  [OT32DON_ANLN1_DO] [nvarchar](12) NULL,
  [OT32DON_ANLN2_DO] [nvarchar](8) NULL,
  [OT32DON_ZMT_ROWID] [int] NULL,
  [OT32DON_OT32ID] [int] NULL,
  [OT32DON_ANLN1_POSKI] [nvarchar](30) NULL,
  [OT32DON_ANLN1_DO_POSKI] [nvarchar](30) NULL,
  CONSTRAINT [PK_SAPO_ZWFOT32DON] PRIMARY KEY CLUSTERED ([OT32DON_ROWID])
)
ON [PRIMARY]
GO