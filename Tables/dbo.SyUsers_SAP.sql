CREATE TABLE [dbo].[SyUsers_SAP] (
  [UserID] [nvarchar](30) NOT NULL,
  [SAP_LOGIN] [nvarchar](30) NULL,
  [NR_OSOB] [nvarchar](30) NULL,
  [NR_ID] [nvarchar](255) NULL,
  [NR_NAZWA] [nvarchar](255) NULL,
  [NR_IMIE] [nvarchar](255) NULL,
  [NR_NAZWISKO] [nvarchar](255) NULL,
  [NR_KLUCZ] [nvarchar](30) NULL
)
ON [PRIMARY]
GO