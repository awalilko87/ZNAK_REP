CREATE TABLE [dbo].[IE2_DocStatus] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [GUID] [nvarchar](50) NULL,
  [POZ] [nvarchar](5) NULL,
  [STAT_DATE] [datetime] NULL,
  [STAT_CODE] [nvarchar](30) NULL,
  [DOC_TYPE] [nvarchar](30) NULL,
  [DOC_KEY] [nvarchar](30) NULL,
  [COLS] [nvarchar](max) NULL,
  [VALS] [nvarchar](max) NULL,
  [DOC_NEW_INSERTED] [smallint] NULL CONSTRAINT [DF__IE2_DocSt__DOC_N__77B7409E] DEFAULT (1),
  CONSTRAINT [PK_IE2_DocStatus] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO