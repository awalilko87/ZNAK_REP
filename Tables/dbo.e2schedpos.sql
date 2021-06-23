CREATE TABLE [dbo].[e2schedpos] (
  [rowid] [int] IDENTITY,
  [eqid] [int] NOT NULL,
  [schid] [int] NOT NULL,
  [lastupdate] [datetime] NOT NULL DEFAULT (getdate()),
  [updateuser] [varchar](100) NOT NULL DEFAULT (isnull(suser_name(),suser_sname())),
  [empproinsp] [varchar](100) NULL,
  [datadop] [datetime] NULL,
  [rowguid] [varchar](36) NULL,
  CONSTRAINT [PK_E2SCHEDPOS] PRIMARY KEY CLUSTERED ([rowid])
)
ON [PRIMARY]
GO