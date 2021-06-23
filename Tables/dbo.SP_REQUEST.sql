﻿CREATE TABLE [dbo].[SP_REQUEST] (
  [SRQ_ROWID] [int] IDENTITY,
  [SRQ_CODE] [nvarchar](30) NOT NULL,
  [SRQ_ORG] [nvarchar](30) NOT NULL,
  [SRQ_DESC] [nvarchar](80) NULL,
  [SRQ_DATE] [datetime] NULL,
  [SRQ_STATUS] [nvarchar](30) NULL,
  [SRQ_TYPE] [nvarchar](30) NULL,
  [SRQ_TYPE2] [nvarchar](30) NULL,
  [SRQ_TYPE3] [nvarchar](30) NULL,
  [SRQ_RSTATUS] [int] NULL,
  [SRQ_CREUSER] [nvarchar](30) NULL CONSTRAINT [DF_SRQ_SRQ_CREUSER] DEFAULT (N'SA'),
  [SRQ_CREDATE] [datetime] NULL CONSTRAINT [DF_SRQ__CREDATE] DEFAULT (getdate()),
  [SRQ_UPDUSER] [nvarchar](30) NULL,
  [SRQ_UPDDATE] [datetime] NULL,
  [SRQ_NOTUSED] [int] NULL CONSTRAINT [DF_SRQ_SRQ_NOTUSED] DEFAULT (0),
  [SRQ_ID] [nvarchar](50) NOT NULL CONSTRAINT [DF_SRQ_SRQ_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  [SRQ_OBJID] [int] NULL,
  [SRQ_STNID_FROM] [int] NULL,
  [SRQ_KL5ID_FROM] [int] NULL,
  [SRQ_STNID_TO] [int] NULL,
  [SRQ_KL5ID_TO] [int] NULL,
  [SRQ_REPLACEMENT] [nvarchar](100) NULL,
  [SRQ_WORKFLOW_STATUS] [int] NULL,
  [SRQ_WORKFLOW_USER] [nvarchar](30) NULL,
  [SRQ_WORFKLOW_DATE] [smalldatetime] NULL,
  [SRQ_WORKFLOW_TYPE] [nvarchar](30) NULL,
  [SRQ_WORKFLOW_ID] [int] NULL,
  [SRQ_ACCUSER] [nvarchar](30) NULL,
  [SRQ_ACCDATE] [datetime] NULL,
  [SRQ_NOTE] [nvarchar](max) NULL,
  [SRQ_OT33ID] [int] NULL,
  [SRQ_OT31ID] [int] NULL,
  [SRQ_OT42ID] [int] NULL,
  [SRQ_OT41ID] [int] NULL,
  [SRQ_OT32ID] [int] NULL,
  [SRQ_REASON] [nvarchar](2000) NULL,
  [SRQ_NR_ZAW_PM] [int] NULL,
  CONSTRAINT [PK_SRQ_1] PRIMARY KEY CLUSTERED ([SRQ_ROWID]),
  CONSTRAINT [UQ_SRQ] UNIQUE ([SRQ_ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [UQ_SRQ_OBJID_STATUS]
  ON [dbo].[SP_REQUEST] ([SRQ_STATUS], [SRQ_OBJID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[SP_REQUEST]
  ADD CONSTRAINT [FK_SRQ_OBJ] FOREIGN KEY ([SRQ_OBJID]) REFERENCES [dbo].[OBJ] ([OBJ_ROWID])
GO