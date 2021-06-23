CREATE TABLE [dbo].[IE2_KST] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [Active] [int] NOT NULL,
  [ANLKL] [nvarchar](30) NOT NULL,
  [TXK50] [nvarchar](512) NULL,
  [BUKRS] [nvarchar](30) NULL,
  [KTOGR] [nvarchar](512) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  [SEGNR] [nvarchar](30) NULL,
  [NDPER_OD] [nvarchar](30) NULL,
  [NDPER_DO] [nvarchar](30) NULL,
  [TXTSEG] [nvarchar](50) NULL,
  [POSKI] [nvarchar](50) NULL,
  CONSTRAINT [PK_IE2_KST] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO