CREATE TABLE [dbo].[IE2_PSP] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [Active] [int] NOT NULL,
  [PSPNR] [nvarchar](30) NOT NULL,
  [POST1] [nvarchar](512) NULL,
  [POSID] [nvarchar](30) NULL,
  [OBJNR] [nvarchar](30) NULL,
  [ERNAM] [nvarchar](30) NULL,
  [ERDAT] [datetime] NULL,
  [AENAM] [nvarchar](30) NULL,
  [AEDAT] [datetime] NULL,
  [STSPR] [nvarchar](30) NULL,
  [VERNR] [nvarchar](30) NULL,
  [VERNA] [nvarchar](128) NULL,
  [ASTNR] [nvarchar](30) NULL,
  [ASTNA] [nvarchar](30) NULL,
  [VBUKR] [nvarchar](30) NULL,
  [VGSBR] [nvarchar](30) NULL,
  [VKOKR] [nvarchar](30) NULL,
  [PRCTR] [nvarchar](30) NULL,
  [PWHIE] [nvarchar](30) NULL,
  [ZUORD] [nvarchar](30) NULL,
  [PLFAZ] [datetime] NULL,
  [PLSEZ] [datetime] NULL,
  [KALID] [nvarchar](30) NULL,
  [VGPLF] [nvarchar](30) NULL,
  [EWPLF] [nvarchar](30) NULL,
  [ZTEHT] [nvarchar](30) NULL,
  [PLNAW] [nvarchar](30) NULL,
  [PROFL] [nvarchar](30) NULL,
  [BPROF] [nvarchar](30) NULL,
  [TXTSP] [nvarchar](30) NULL,
  [KOSTL] [nvarchar](30) NULL,
  [KTRG] [nvarchar](30) NULL,
  [SCPRF] [nvarchar](30) NULL,
  [IMPRF] [nvarchar](30) NULL,
  [PPROF] [nvarchar](30) NULL,
  [ZZKIER] [nvarchar](30) NULL,
  [STUFE] [nvarchar](30) NULL,
  [BANFN] [nvarchar](30) NULL,
  [BNFPO] [nvarchar](30) NULL,
  [ZEBKN] [nvarchar](30) NULL,
  [EBELN] [nvarchar](30) NULL,
  [EBELP] [nvarchar](30) NULL,
  [ZEKKN] [nvarchar](30) NULL,
  [PSPHI] [nvarchar](30) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL DEFAULT (1),
  [POSKI] [nvarchar](50) NULL,
  CONSTRAINT [PK_IE2_PSP] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO

CREATE INDEX [PG_20190118]
  ON [dbo].[IE2_PSP] ([POSKI])
  INCLUDE ([ROWID], [PSPNR], [POSID], [BANFN], [EBELN], [PSPHI], [DOC_NEW_INSERTED])
  ON [PRIMARY]
GO