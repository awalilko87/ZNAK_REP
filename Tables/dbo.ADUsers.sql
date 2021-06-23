CREATE TABLE [dbo].[ADUsers] (
  [UserLogin] [nvarchar](30) NOT NULL,
  [DisplayName] [nvarchar](100) NULL,
  [EmailAddress] [nvarchar](255) NULL,
  [FirstName] [nvarchar](50) NULL,
  [LastName] [nvarchar](50) NULL,
  [MiddleName] [nvarchar](50) NULL,
  [TelephoneNumber] [nvarchar](30) NULL,
  [Company] [nvarchar](80) NULL,
  [Department] [nvarchar](80) NULL,
  [SAPLogin] [nvarchar](30) NULL,
  [Active] [tinyint] NULL CONSTRAINT [DF_ADUsers_Active] DEFAULT (1),
  CONSTRAINT [PK_ADUsers] PRIMARY KEY CLUSTERED ([UserLogin])
)
ON [PRIMARY]
GO