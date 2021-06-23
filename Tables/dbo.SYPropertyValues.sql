CREATE TABLE [dbo].[SYPropertyValues] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_SYPropertyValues_rowguid] DEFAULT (newid()),
  [pmodule] [nvarchar](30) NOT NULL,
  [papp] [nvarchar](30) NOT NULL,
  [property] [nvarchar](30) NOT NULL,
  [pparent] [nvarchar](30) NOT NULL,
  [pvalue] [nvarchar](max) NULL,
  [pcreated] [datetime] NOT NULL,
  [pupdated] [datetime] NULL,
  [pupdatecount] [int] NULL,
  [pcode] [nvarchar](255) NOT NULL CONSTRAINT [DF_SYPropertyValues_pcode] DEFAULT (''),
  CONSTRAINT [PK_SYPropertyValues] PRIMARY KEY NONCLUSTERED ([pmodule], [papp], [property], [pparent], [pcode])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO