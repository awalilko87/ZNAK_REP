CREATE TABLE [dbo].[ACCOUNT] (
  [ACC_ROWID] [int] IDENTITY,
  [ACC_CODE] [nvarchar](30) NOT NULL,
  [ACC_ORG] [nvarchar](30) NOT NULL,
  [ACC_DESC] [nvarchar](80) NULL,
  [ACC_NOTUSED] [int] NULL,
  [ACC_PRODID] [int] NULL,
  [ACC_MAGID] [int] NULL,
  [ACC_MRCID] [int] NULL,
  [ACC_CREDATE] [datetime] NULL,
  [ACC_CREUSER] [nvarchar](30) NULL,
  [ACC_UPDDATE] [datetime] NULL,
  [ACC_UPDUSER] [nvarchar](30) NULL,
  CONSTRAINT [PK_ACCOUNT] PRIMARY KEY CLUSTERED ([ACC_CODE], [ACC_ORG]),
  CONSTRAINT [UQ_ACCOUNT] UNIQUE ([ACC_ROWID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACCOUNT]
  ADD CONSTRAINT [FK_ACCOUNT_MRC] FOREIGN KEY ([ACC_MRCID]) REFERENCES [dbo].[MRC] ([MRC_ROWID])
GO

ALTER TABLE [dbo].[ACCOUNT]
  ADD CONSTRAINT [FK_ACCOUNT_st_mag] FOREIGN KEY ([ACC_MAGID]) REFERENCES [dbo].[ST_MAG] ([ROWID])
GO