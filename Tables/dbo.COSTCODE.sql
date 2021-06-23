CREATE TABLE [dbo].[COSTCODE] (
  [CCD_ROWID] [int] IDENTITY,
  [CCD_CODE] [nvarchar](30) NOT NULL,
  [CCD_ORG] [nvarchar](30) NOT NULL,
  [CCD_DESC] [nvarchar](80) NULL,
  [CCD_CREUSER] [nvarchar](30) NULL,
  [CCD_CREDATE] [datetime] NULL,
  [CCD_UPDUSER] [nvarchar](30) NULL,
  [CCD_UPDDATE] [datetime] NULL,
  [CCD_NOTUSED] [int] NULL,
  [CCD_SAP_MCTXT] [nvarchar](200) NULL,
  [CCD_SAP_KOKRS] [nvarchar](200) NULL,
  [CCD_SAP_KOSTL] [nvarchar](200) NULL,
  [CCD_SAP_DATBI] [datetime] NULL,
  [CCD_SAP_DATAB] [datetime] NULL,
  [CCD_SAP_BUKRS] [nvarchar](200) NULL,
  [CCD_SAP_GSBER] [nvarchar](200) NULL,
  [CCD_SAP_KOSAR] [nvarchar](200) NULL,
  [CCD_SAP_VERAK] [nvarchar](200) NULL,
  [CCD_SAP_VERAK_USER] [nvarchar](200) NULL,
  [CCD_SAP_WAERS] [nvarchar](200) NULL,
  [CCD_SAP_ERSDA] [datetime] NULL,
  [CCD_SAP_USNAM] [nvarchar](200) NULL,
  [CCD_SAP_ABTEI] [nvarchar](200) NULL,
  [CCD_SAP_SPRAS] [nvarchar](200) NULL,
  [CCD_SAP_FUNC_AREA] [nvarchar](200) NULL,
  [CCD_SAP_KOMPL] [nvarchar](200) NULL,
  [CCD_SAP_OBJNR] [nvarchar](200) NULL,
  [CCD_SAP_ACTIVE] [int] NULL,
  CONSTRAINT [PK_COSTCODE] PRIMARY KEY CLUSTERED ([CCD_CODE], [CCD_ORG]),
  CONSTRAINT [IX_COSTCODE] UNIQUE ([CCD_ROWID]),
  CONSTRAINT [UQ_CCD_CODE] UNIQUE ([CCD_CODE])
)
ON [PRIMARY]
GO

CREATE INDEX [PG_20161125]
  ON [dbo].[COSTCODE] ([CCD_SAP_KOSTL])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[COSTCODE]
  ADD CONSTRAINT [FK_COSTCODE_ORG] FOREIGN KEY ([CCD_ORG]) REFERENCES [dbo].[ORG] ([ORG_CODE]) ON UPDATE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Kod', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Siedziba', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_ORG'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Opis', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzył', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_CREUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Utworzone', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_CREDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikował', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_UPDUSER'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Modyfikowane', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_UPDDATE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nieaktywne', 'SCHEMA', N'dbo', 'TABLE', N'COSTCODE', 'COLUMN', N'CCD_NOTUSED'
GO