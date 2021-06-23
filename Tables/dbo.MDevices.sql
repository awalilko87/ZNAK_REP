CREATE TABLE [dbo].[MDevices] (
  [deviceid] [nvarchar](255) NOT NULL,
  [code] [nvarchar](30) NOT NULL,
  [hres] [int] NULL,
  [vres] [int] NULL,
  [not_used] [bit] NULL,
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MDevices_rowguid] DEFAULT (newid()),
  CONSTRAINT [PK_MDevices] PRIMARY KEY NONCLUSTERED ([rowguid])
)
ON [PRIMARY]
GO