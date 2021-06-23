CREATE TABLE [dbo].[ASPStateTempApplications] (
  [AppId] [int] NOT NULL,
  [AppName] [nvarchar](280) NOT NULL,
  CONSTRAINT [PK_ASPStateTempApplications] PRIMARY KEY NONCLUSTERED ([AppId])
)
ON [PRIMARY]
GO