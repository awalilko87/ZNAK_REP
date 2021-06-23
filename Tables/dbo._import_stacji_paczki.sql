CREATE TABLE [dbo].[_import_stacji_paczki] (
  [STACJA] [int] NOT NULL,
  [MPK] [nvarchar](30) NULL,
  [PACZKA] [tinyint] NULL,
  PRIMARY KEY CLUSTERED ([STACJA])
)
ON [PRIMARY]
GO