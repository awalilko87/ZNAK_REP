CREATE TABLE [dbo].[EMPGROUP] (
  [EMG_ROWID] [int] IDENTITY,
  [EMG_CODE] [nvarchar](48) NOT NULL,
  [EMG_ORG] [nvarchar](30) NOT NULL,
  [EMG_DESC] [nvarchar](80) NULL,
  [EMG_NOTE] [ntext] NULL,
  [EMG_DATE] [datetime] NULL,
  [EMG_STATUS] [nvarchar](30) NULL,
  [EMG_TYPE] [nvarchar](30) NULL,
  [EMG_TYPE2] [nvarchar](30) NULL,
  [EMG_TYPE3] [nvarchar](30) NULL,
  [EMG_RSTATUS] [int] NULL,
  [EMG_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_EMPGROUP_CREUSER] DEFAULT (N'SA'),
  [EMG_CREDATE] [datetime] NULL CONSTRAINT [DF_EMPGROUP_CREDATE] DEFAULT (getdate()),
  [EMG_UPDUSER] [nvarchar](30) NULL,
  [EMG_UPDDATE] [datetime] NULL,
  [EMG_NOTUSED] [int] NULL,
  [EMG_ID] [nvarchar](50) NULL CONSTRAINT [DF_EMPGROUP_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [EMG_TXT01] [nvarchar](30) NULL,
  [EMG_TXT02] [nvarchar](30) NULL,
  [EMG_TXT03] [nvarchar](30) NULL,
  [EMG_TXT04] [nvarchar](30) NULL,
  [EMG_TXT05] [nvarchar](30) NULL,
  [EMG_TXT06] [nvarchar](80) NULL,
  [EMG_TXT07] [nvarchar](80) NULL,
  [EMG_TXT08] [nvarchar](255) NULL,
  [EMG_TXT09] [nvarchar](255) NULL,
  [EMG_NTX01] [numeric](24, 6) NULL,
  [EMG_NTX02] [numeric](24, 6) NULL,
  [EMG_NTX03] [numeric](24, 6) NULL,
  [EMG_NTX04] [numeric](24, 6) NULL,
  [EMG_NTX05] [numeric](24, 6) NULL,
  [EMG_COM01] [ntext] NULL,
  [EMG_COM02] [ntext] NULL,
  [EMG_DTX01] [datetime] NULL,
  [EMG_DTX02] [datetime] NULL,
  [EMG_DTX03] [datetime] NULL,
  [EMG_DTX04] [datetime] NULL,
  [EMG_DTX05] [datetime] NULL,
  CONSTRAINT [PK_EMPGROUP_1] PRIMARY KEY CLUSTERED ([EMG_CODE], [EMG_ORG]),
  CONSTRAINT [UQ_EMPGROUP] UNIQUE ([EMG_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[EMPGROUP]
  ADD CONSTRAINT [FK_EMPGROUP_ORG] FOREIGN KEY ([EMG_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO