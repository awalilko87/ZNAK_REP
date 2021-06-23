CREATE TABLE [dbo].[SYPrinters] (
  [prn_guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_SYPrinters_prn_guid] DEFAULT (newid()),
  [prn_name] [nvarchar](255) NOT NULL,
  CONSTRAINT [PK_SYPrinters] PRIMARY KEY NONCLUSTERED ([prn_guid])
)
ON [PRIMARY]
GO