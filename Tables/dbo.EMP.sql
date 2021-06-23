CREATE TABLE [dbo].[EMP] (
  [EMP_ROWID] [int] IDENTITY,
  [EMP_CODE] [nvarchar](30) NOT NULL,
  [EMP_ORG] [nvarchar](30) NOT NULL,
  [EMP_DESC] [nvarchar](80) NULL,
  [EMP_NOTE] [ntext] NULL,
  [EMP_DATE] [datetime] NULL,
  [EMP_STATUS] [nvarchar](30) NULL,
  [EMP_TYPE] [nvarchar](30) NULL,
  [EMP_TYPE2] [nvarchar](30) NULL,
  [EMP_TYPE3] [nvarchar](30) NULL,
  [EMP_RSTATUS] [int] NULL CONSTRAINT [DF_EMP_EMP_RSTATUS] DEFAULT (0),
  [EMP_CREDATE] [datetime] NULL CONSTRAINT [DF_EMP_EMP_CREDATE] DEFAULT (getdate()),
  [EMP_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_EMP_EMP_CREUSER] DEFAULT ('SA'),
  [EMP_UPDDATE] [datetime] NULL,
  [EMP_UPDUSER] [nvarchar](30) NULL,
  [EMP_NOTUSED] [int] NULL CONSTRAINT [DF_EMP_EMP_NOTUSED] DEFAULT (0),
  [EMP_ID] [nvarchar](50) NULL CONSTRAINT [DF_EMP_EMP_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [EMP_ENGAGE] [datetime] NULL,
  [EMP_MRCID] [int] NULL,
  [EMP_COSTCODEID] [nvarchar](30) NULL,
  [EMP_MAGID] [int] NULL,
  [EMP_PHONE] [nvarchar](30) NULL,
  [EMP_EMAIL] [nvarchar](80) NULL,
  [EMP_TRADEID] [int] NULL,
  [TXT01] [nvarchar](30) NULL,
  [TXT02] [nvarchar](30) NULL,
  [TXT03] [nvarchar](30) NULL,
  [TXT04] [nvarchar](30) NULL,
  [TXT05] [nvarchar](30) NULL,
  [TXT06] [nvarchar](80) NULL,
  [TXT07] [nvarchar](80) NULL,
  [TXT08] [nvarchar](255) NULL,
  [TXT09] [nvarchar](255) NULL,
  [NTX01] [numeric](24, 6) NULL,
  [NTX02] [numeric](24, 6) NULL,
  [NTX03] [numeric](24, 6) NULL,
  [NTX04] [numeric](24, 6) NULL,
  [NTX05] [numeric](24, 6) NULL,
  [COM01] [ntext] NULL,
  [COM02] [ntext] NULL,
  [DTX01] [datetime] NULL,
  [DTX02] [datetime] NULL,
  [DTX03] [datetime] NULL,
  [DTX04] [datetime] NULL,
  [DTX05] [datetime] NULL,
  [EMP_UR] [int] NULL CONSTRAINT [DF_EMP_EMP_UR] DEFAULT (0),
  [EMP_SUPID] [int] NULL,
  [EMP_GROUPID] [int] NULL,
  CONSTRAINT [PK_EMP] PRIMARY KEY NONCLUSTERED ([EMP_CODE]),
  CONSTRAINT [IX_EMP] UNIQUE CLUSTERED ([EMP_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[EMP]
  ADD CONSTRAINT [FK_EMP_EMPGROUP] FOREIGN KEY ([EMP_GROUPID]) REFERENCES [dbo].[EMPGROUP] ([EMG_ROWID])
GO

ALTER TABLE [dbo].[EMP]
  ADD CONSTRAINT [FK_EMP_MAGID] FOREIGN KEY ([EMP_MAGID]) REFERENCES [dbo].[ST_MAG] ([ROWID])
GO

ALTER TABLE [dbo].[EMP]
  ADD CONSTRAINT [FK_EMP_MRCID] FOREIGN KEY ([EMP_MRCID]) REFERENCES [dbo].[MRC] ([MRC_ROWID])
GO

ALTER TABLE [dbo].[EMP]
  ADD CONSTRAINT [FK_EMP_ORG] FOREIGN KEY ([EMP_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO