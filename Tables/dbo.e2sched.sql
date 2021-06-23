CREATE TABLE [dbo].[e2sched] (
  [rowid] [int] IDENTITY,
  [eqdate] [datetime] NOT NULL DEFAULT (getdate()),
  [userid] [nvarchar](30) NOT NULL,
  [dd] [int] NOT NULL,
  [dh] [int] NOT NULL,
  [lp] [int] NOT NULL,
  [typcz] [varchar](30) NOT NULL,
  [typpow] [varchar](30) NOT NULL,
  [status] [varchar](30) NOT NULL,
  [opedesc] [varchar](255) NULL,
  [ud1] [varchar](30) NULL,
  [ud2] [varchar](30) NULL,
  [ud3] [varchar](30) NULL,
  [dm] [int] NOT NULL DEFAULT (0),
  [lastupdate] [datetime] NOT NULL DEFAULT (getdate()),
  [updateuser] [varchar](100) NOT NULL DEFAULT (isnull(suser_name(),suser_sname())),
  [rowguid] [varchar](36) NULL,
  [enddate] [datetime] NULL,
  CONSTRAINT [PK_E2SCHED] PRIMARY KEY NONCLUSTERED ([rowid])
)
ON [PRIMARY]
GO