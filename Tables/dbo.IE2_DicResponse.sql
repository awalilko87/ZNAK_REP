CREATE TABLE [dbo].[IE2_DicResponse] (
  [ROWID] [bigint] IDENTITY,
  [i_DateTime] [datetime] NOT NULL,
  [DIC] [nvarchar](50) NOT NULL,
  [COLS] [nvarchar](max) NULL,
  [VALS] [nvarchar](max) NULL,
  [STMT] [nvarchar](max) NULL,
  [ERRORMESSAGE] [nvarchar](max) NULL,
  CONSTRAINT [PK_IE2_DicResponse] PRIMARY KEY CLUSTERED ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO