CREATE TABLE [dbo].[VS_ExcelExport] (
  [rowid] [int] IDENTITY,
  [formId] [nvarchar](50) NOT NULL,
  [parentId] [nvarchar](50) NOT NULL,
  [templateId] [int] NOT NULL,
  [sheetOrder] [int] NOT NULL,
  [sheetPositionX] [int] NULL,
  [sheetPositionY] [int] NULL,
  [userId] [nvarchar](50) NULL,
  [groupId] [nvarchar](50) NULL,
  [addHeader] [bit] NULL,
  [overrideTabsNames] [bit] NULL,
  CONSTRAINT [PK_VS_ExcelExport] PRIMARY KEY NONCLUSTERED ([formId], [parentId])
)
ON [PRIMARY]
GO