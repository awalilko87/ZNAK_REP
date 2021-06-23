CREATE TABLE [dbo].[IE2_MPK] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [Active] [int] NOT NULL,
  [MCTXT] [nvarchar](30) NOT NULL,
  [KOKRS] [nvarchar](30) NULL,
  [KOSTL] [nvarchar](30) NULL,
  [DATBI] [nvarchar](10) NULL,
  [DATAB] [nvarchar](10) NULL,
  [BUKRS] [nvarchar](30) NULL,
  [GSBER] [nvarchar](30) NULL,
  [KOSAR] [nvarchar](30) NULL,
  [VERAK] [nvarchar](30) NULL,
  [VERAK_USER] [nvarchar](30) NULL,
  [WAERS] [nvarchar](30) NULL,
  [ERSDA] [nvarchar](10) NULL,
  [USNAM] [nvarchar](30) NULL,
  [ABTEI] [nvarchar](30) NULL,
  [SPRAS] [nvarchar](30) NULL,
  [FUNC_AREA] [nvarchar](30) NULL,
  [KOMPL] [nvarchar](30) NULL,
  [OBJNR] [nvarchar](30) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  [POSKI] [nvarchar](50) NULL,
  CONSTRAINT [PK_IE2_MPK] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO