CREATE TABLE [dbo].[SYContextMenu] (
  [ROWID] [int] IDENTITY,
  [PARENTID] [int] NULL,
  [FID] [nvarchar](30) NULL,
  [MENUPARENT] [nvarchar](30) NULL,
  [ITEMCAPTION] [nvarchar](30) NULL,
  [SECTION] [nvarchar](225) NULL,
  [COMMAND] [nvarchar](4000) NULL,
  [CALLMODE] [nvarchar](30) NULL,
  [CONTROLTYPE] [nvarchar](30) NULL,
  [IMGURL] [nvarchar](255) NULL,
  [ORDERINDEX] [int] NULL,
  [FIELDID] [nvarchar](30) NULL,
  [LINKFORMID] [nvarchar](max) NULL,
  [LINKFIELDID] [nvarchar](max) NULL,
  CONSTRAINT [PK_SYContextMenu] PRIMARY KEY NONCLUSTERED ([ROWID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO