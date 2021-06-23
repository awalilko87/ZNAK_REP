CREATE TABLE [dbo].[VS_Trace] (
  [TRC_FORM] [nvarchar](30) NOT NULL,
  [TRC_ACTION] [nvarchar](30) NOT NULL,
  [TRC_START_DATE] [datetime] NOT NULL,
  [TRC_END_DATE] [datetime] NULL,
  [TRC_BANDWIDTH] [float] NULL,
  [TRC_USER] [nvarchar](30) NOT NULL,
  [TRC_ROWGUID] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_VS_Trace] PRIMARY KEY NONCLUSTERED ([TRC_ROWGUID])
)
ON [PRIMARY]
GO