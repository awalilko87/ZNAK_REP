CREATE TABLE [dbo].[SETTYPE] (
  [STT_ROWID] [int] IDENTITY,
  [STT_CODE] [nvarchar](30) NOT NULL,
  [STT_DESC] [nvarchar](80) NULL,
  [STT_MAIN] [smallint] NULL
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [ClusteredIndex-20150313-101444]
  ON [dbo].[SETTYPE] ([STT_CODE])
  ON [PRIMARY]
GO