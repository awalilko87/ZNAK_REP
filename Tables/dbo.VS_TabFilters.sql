CREATE TABLE [dbo].[VS_TabFilters] (
  [FilterID] [nvarchar](50) NOT NULL CONSTRAINT [DF_VS_TabFilters_FilterID] DEFAULT (newid()),
  [FilterName] [nvarchar](50) NOT NULL,
  [TabGroupID] [nvarchar](50) NOT NULL,
  [FormID] [nvarchar](50) NOT NULL,
  [GroupID] [nvarchar](20) NOT NULL,
  [UserID] [nvarchar](30) NULL,
  [IsActive] [bit] NULL,
  [SqlWhere] [nvarchar](max) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [TabID] [nvarchar](250) NULL,
  [FilterField] [nvarchar](50) NULL,
  [FilterValue] [nvarchar](50) NULL,
  [FilterType] [int] NULL,
  CONSTRAINT [PK_VS_TabFilters] PRIMARY KEY NONCLUSTERED ([FilterID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO