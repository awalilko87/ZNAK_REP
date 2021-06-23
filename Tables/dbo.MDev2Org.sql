CREATE TABLE [dbo].[MDev2Org] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MDev2Org_rowguid] DEFAULT (newid()),
  [deviceguid] [uniqueidentifier] NOT NULL,
  [orgguid] [uniqueidentifier] NOT NULL,
  CONSTRAINT [PK_MDev2Org] PRIMARY KEY NONCLUSTERED ([deviceguid], [orgguid])
)
ON [PRIMARY]
GO