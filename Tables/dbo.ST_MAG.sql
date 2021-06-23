CREATE TABLE [dbo].[ST_MAG] (
  [ROWID] [int] IDENTITY,
  [NAME] [varchar](80) NOT NULL,
  [ORG] [nvarchar](30) NOT NULL,
  [CODE] [varchar](30) NULL,
  [COUNTRY] [varchar](80) NULL,
  [CITY] [varchar](80) NULL,
  [STREET] [varchar](80) NULL,
  [NO] [varchar](30) NULL,
  [POSTAL] [varchar](30) NULL,
  [PERSON] [nvarchar](50) NULL,
  [MAG_GLOWNY] [int] NULL,
  [MAG_PODR] [nvarchar](50) NULL,
  [COSTMETHOD] [nvarchar](4) NOT NULL,
  [ISACCOUNT] [bit] NULL,
  CONSTRAINT [PK_st_mag_1] PRIMARY KEY CLUSTERED ([NAME]),
  CONSTRAINT [IX_st_mag] UNIQUE ([ROWID]),
  CONSTRAINT [CK_ST_MAG_COSTMETHOD] CHECK ([COSTMETHOD]='FIFO' OR [COSTMETHOD]='LIFO' OR [COSTMETHOD]='WA')
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Magazyny', 'SCHEMA', N'dbo', 'TABLE', N'ST_MAG'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'rowid', 'SCHEMA', N'dbo', 'TABLE', N'ST_MAG', 'COLUMN', N'ROWID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Nazwa magazynu', 'SCHEMA', N'dbo', 'TABLE', N'ST_MAG', 'COLUMN', N'NAME'
GO