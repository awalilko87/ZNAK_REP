CREATE TABLE [dbo].[_DICT_IMPORT] (
  [ROWID] [int] IDENTITY,
  [DT] [datetime] NULL,
  [DICT] [nvarchar](50) NULL,
  [E2_COUNT] [int] NULL,
  [E2_DISTCOUNT] [int] NULL,
  [ZMT_COUNT] [int] NULL,
  [DYEAR] [nvarchar](50) NULL,
  [DDESC] [nvarchar](50) NULL
)
ON [PRIMARY]
GO