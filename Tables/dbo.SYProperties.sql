CREATE TABLE [dbo].[SYProperties] (
  [pmodule] [nvarchar](30) NOT NULL,
  [papp] [nvarchar](30) NOT NULL,
  [pcode] [nvarchar](30) NOT NULL,
  [pparent] [nvarchar](30) NOT NULL,
  [pdesc] [nvarchar](255) NULL,
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_SYProperties_rowguid] DEFAULT (newid()),
  [ptype] [nvarchar](50) NULL,
  CONSTRAINT [PK_SYProperties] PRIMARY KEY NONCLUSTERED ([pmodule], [papp], [pcode], [pparent])
)
ON [PRIMARY]
GO