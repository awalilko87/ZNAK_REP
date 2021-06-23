CREATE TABLE [dbo].[VS_FormHeader] (
  [FormID] [nvarchar](50) NOT NULL,
  [Panel] [nvarchar](1) NOT NULL,
  [FieldID] [nvarchar](50) NULL,
  [Caption] [nvarchar](50) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [UpdateUser] [nvarchar](100) NULL,
  CONSTRAINT [PK_VS_FormHeader] PRIMARY KEY CLUSTERED ([FormID], [Panel])
)
ON [PRIMARY]
GO