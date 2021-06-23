CREATE TABLE [dbo].[SYPrinterSettings] (
  [pst_id] [int] NOT NULL,
  [pst_doc_id] [nvarchar](50) NOT NULL,
  [pst_printer] [uniqueidentifier] NOT NULL,
  [pst_tray] [nvarchar](30) NULL,
  [pst_def_pr_flag] [bit] NULL CONSTRAINT [DF_SYPrinterSettings_pst_def_pr_flag] DEFAULT (0),
  [pst_bin_prn] [image] NULL,
  [pst_bin_pag] [image] NULL,
  [pst_form_id] [nvarchar](50) NULL,
  [pst_field_id] [nvarchar](50) NULL,
  [pst_print_method] [nvarchar](50) NULL,
  [pst_paper_size] [nvarchar](30) NULL,
  CONSTRAINT [PK_SYPrinterSettings] PRIMARY KEY NONCLUSTERED ([pst_id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO