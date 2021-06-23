CREATE TABLE [dbo].[IMPORT_SP_LOG] (
  [LSP_SQLIDENTITY] [int] IDENTITY,
  [LSP_STNCODE] [nvarchar](30) NULL,
  [LSP_STSCODE] [nvarchar](30) NULL,
  [LSP_PARAM] [nvarchar](30) NULL,
  [LSP_IMPORTUSER] [nvarchar](50) NULL,
  [LSP_REASON] [nvarchar](max) NULL,
  [LSP_DATE] [datetime] NULL,
  [lsp_stacja] [int] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO