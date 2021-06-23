CREATE TABLE [dbo].[SYOlap] (
  [Id] [int] IDENTITY,
  [UserId] [nvarchar](50) NOT NULL,
  [ViewDefinition] [nvarchar](max) NOT NULL,
  [ViewName] [nvarchar](100) NOT NULL,
  [FormId] [nvarchar](100) NOT NULL,
  CONSTRAINT [PK_SYOlap] PRIMARY KEY NONCLUSTERED ([Id])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO