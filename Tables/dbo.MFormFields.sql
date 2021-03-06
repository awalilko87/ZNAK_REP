CREATE TABLE [dbo].[MFormFields] (
  [rowguid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_MFormFields_rowguid] DEFAULT (newid()),
  [formguid] [uniqueidentifier] NOT NULL,
  [tabname] [nvarchar](30) NOT NULL,
  [name] [nvarchar](30) NOT NULL,
  [caption] [nvarchar](30) NOT NULL,
  [listindex] [int] NOT NULL,
  [recordindex] [int] NOT NULL,
  [top] [int] NOT NULL,
  [left] [int] NOT NULL,
  [width] [int] NOT NULL,
  [height] [int] NOT NULL,
  [vlist] [bit] NOT NULL,
  [vrecord] [bit] NOT NULL,
  [vpic] [bit] NOT NULL,
  [roer] [bit] NOT NULL,
  [roir] [bit] NOT NULL,
  [font] [nvarchar](30) NULL,
  [fontcolor] [nvarchar](30) NULL,
  [fontsize] [tinyint] NULL,
  [fontstyle] [nvarchar](30) NULL,
  [iskey] [bit] NOT NULL,
  [slownik] [int] NULL,
  [lwidth] [int] NULL,
  [lheight] [int] NULL,
  [required] [bit] NOT NULL,
  [defaultsql] [nvarchar](4000) NULL,
  [slotype] [nvarchar](30) NULL,
  [cvl] [int] NOT NULL,
  [showinputpanel] [bit] NOT NULL,
  [filter] [bit] NOT NULL,
  [ispicture] [bit] NOT NULL,
  [orderby] [nvarchar](30) NULL,
  [multiline] [bit] NULL,
  [isscanflag] [bit] NULL,
  [lformat] [nvarchar](30) NULL,
  [rformat] [nvarchar](30) NULL,
  [lalignment] [nvarchar](30) NULL,
  [roel] [bit] NOT NULL,
  [roil] [bit] NOT NULL,
  [datatype] [nvarchar](30) NOT NULL,
  [defaultsqledit] [nvarchar](4000) NULL,
  [keyaction] [nvarchar](max) NULL,
  [filteroperator] [nvarchar](30) NOT NULL,
  [tmporderby] [bit] NULL,
  CONSTRAINT [PK_MFormFields] PRIMARY KEY NONCLUSTERED ([formguid], [name])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO