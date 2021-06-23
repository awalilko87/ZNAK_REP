CREATE TABLE [dbo].[CSVIMPORT] (
  [KodZrodla] [nvarchar](6) NOT NULL,
  [Pole] [nvarchar](50) NOT NULL,
  [Wartosc] [nvarchar](50) NULL,
  CONSTRAINT [PK_REQCSVIMPORT] PRIMARY KEY CLUSTERED ([KodZrodla], [Pole])
)
ON [PRIMARY]
GO