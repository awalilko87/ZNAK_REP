CREATE TABLE [dbo].[e2sched_dictionary] (
  [Kod] [nvarchar](50) NOT NULL,
  [Nazwa] [nvarchar](50) NULL,
  [Opis] [nvarchar](max) NULL,
  [Typ] [nvarchar](50) NOT NULL,
  CONSTRAINT [PK_e2sched_dictionary] PRIMARY KEY CLUSTERED ([Kod])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO