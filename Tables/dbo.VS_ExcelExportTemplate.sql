CREATE TABLE [dbo].[VS_ExcelExportTemplate] (
  [rowid] [int] IDENTITY,
  [templateFileId2] [nvarchar](36) NOT NULL,
  [templateName] [nvarchar](80) NOT NULL,
  [templateDesc] [nvarchar](4000) NULL,
  CONSTRAINT [PK_VS_ExcelExportTemplate] PRIMARY KEY NONCLUSTERED ([templateName])
)
ON [PRIMARY]
GO