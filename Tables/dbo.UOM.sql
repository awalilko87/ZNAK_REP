CREATE TABLE [dbo].[UOM] (
  [UOM_ROWID] [int] IDENTITY,
  [UOM_CODE] [nvarchar](30) NOT NULL,
  [UOM_DESC] [nvarchar](80) NULL,
  [UOM_PARENT] [nvarchar](30) NULL,
  [UOM_PARENTCONV] [numeric](30, 2) NULL,
  [UOM_CREDATE] [datetime] NULL,
  [UOM_CREUSER] [nvarchar](30) NULL,
  [UOM_NOTUSED] [int] NULL,
  [UOM_OPER] [nvarchar](50) NULL,
  [UOM_RESULT] [nvarchar](50) NULL,
  [UOM_ID] [nvarchar](50) NULL CONSTRAINT [DF_UOM_UOM_ID] DEFAULT (CONVERT([nvarchar](50),newid(),(0))),
  CONSTRAINT [PK_UOM] PRIMARY KEY CLUSTERED ([UOM_CODE]),
  CONSTRAINT [IX_UOM] UNIQUE ([UOM_ROWID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Jednostka', 'SCHEMA', N'dbo', 'TABLE', N'UOM', 'COLUMN', N'UOM_CODE'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nazwa', 'SCHEMA', N'dbo', 'TABLE', N'UOM', 'COLUMN', N'UOM_DESC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Jednostka nadrzędna', 'SCHEMA', N'dbo', 'TABLE', N'UOM', 'COLUMN', N'UOM_PARENT'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Przelicznik jedn. nadrzędnej', 'SCHEMA', N'dbo', 'TABLE', N'UOM', 'COLUMN', N'UOM_PARENTCONV'
GO