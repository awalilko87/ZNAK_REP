﻿CREATE TABLE [dbo].[PRVOBJ] (
  [ROWID] [int] IDENTITY,
  [PVO_OBJID] [int] NULL,
  [PVO_USERID] [nvarchar](30) NULL,
  [PVO_GROUPID] [nvarchar](20) NULL,
  [PVO_OBGID] [int] NULL,
  [PVO_ID] [nvarchar](50) NULL,
  CONSTRAINT [PK_PRVOBJ] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
GO

CREATE INDEX [E2IDX_PVO01]
  ON [dbo].[PRVOBJ] ([PVO_GROUPID])
  ON [PRIMARY]
GO

CREATE INDEX [E2IDX_PVO02]
  ON [dbo].[PRVOBJ] ([PVO_OBGID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[PRVOBJ]
  ADD CONSTRAINT [FK_PRVOBJ_GROUP] FOREIGN KEY ([PVO_GROUPID]) REFERENCES [dbo].[SYGroups] ([GroupID])
GO

ALTER TABLE [dbo].[PRVOBJ]
  ADD CONSTRAINT [FK_PRVOBJ_OBJ] FOREIGN KEY ([PVO_OBJID]) REFERENCES [dbo].[OBJ] ([OBJ_ROWID])
GO

ALTER TABLE [dbo].[PRVOBJ]
  ADD CONSTRAINT [FK_PRVOBJ_OBJGROUP] FOREIGN KEY ([PVO_OBGID]) REFERENCES [dbo].[OBJGROUP] ([OBG_ROWID])
GO

ALTER TABLE [dbo].[PRVOBJ]
  ADD CONSTRAINT [FK_PRVOBJ_USER] FOREIGN KEY ([PVO_USERID]) REFERENCES [dbo].[SYUsers] ([UserID])
GO