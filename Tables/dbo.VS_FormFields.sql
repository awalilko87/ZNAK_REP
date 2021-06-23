CREATE TABLE [dbo].[VS_FormFields] (
  [FieldID] [nvarchar](50) NOT NULL,
  [FormID] [nvarchar](50) NOT NULL,
  [TableName] [nvarchar](50) NULL,
  [ControlType] [nvarchar](50) NULL,
  [CaptionWidth] [int] NULL,
  [ControlWidth] [int] NULL,
  [NoColumn] [int] NULL,
  [NoRow] [int] NULL,
  [NoColspan] [int] NULL,
  [RequireQuery] [nvarchar](max) NULL,
  [VisibleQuery] [nvarchar](max) NULL,
  [ReadOnlyQuery] [nvarchar](max) NULL,
  [DefaultValue] [nvarchar](max) NULL,
  [DataType] [nvarchar](50) NULL,
  [DataTypeSQL] [nvarchar](50) NULL,
  [Length] [int] NULL,
  [ValidateQuery] [nvarchar](max) NULL,
  [TextRows] [int] NULL,
  [TextColumns] [int] NULL,
  [Tooltip] [nvarchar](max) NULL,
  [GridColIndex] [int] NULL,
  [GridColWidth] [int] NULL CONSTRAINT [DF_VS_FormFields_GridColWidth] DEFAULT (0),
  [DisplayFieldFormat] [nvarchar](50) NULL,
  [DisplayGridFormat] [nvarchar](50) NULL,
  [CallbackMessage] [nvarchar](400) NULL,
  [CallbackQuery] [nvarchar](max) NULL,
  [GridAllign] [nvarchar](10) NULL,
  [CaptionAlign] [nvarchar](10) NULL,
  [ControlAlign] [nvarchar](10) NULL,
  [PanelGroup] [nvarchar](2) NULL,
  [FieldDesc] [nvarchar](max) NULL,
  [IsPK] [bit] NULL,
  [Require] [bit] NULL,
  [Visible] [bit] NULL,
  [ReadOnly] [bit] NULL,
  [GridPk] [bit] NULL,
  [NotUse] [bit] NULL,
  [AllowSort] [bit] NULL CONSTRAINT [DF_VS_FormFields_AllowSort] DEFAULT (0),
  [AllowFilter] [bit] NULL CONSTRAINT [DF_VS_FormFields_AllowFilter] DEFAULT (0),
  [AllowReportParam] [bit] NULL CONSTRAINT [DF_VS_FormFields_AllowReportParam] DEFAULT (0),
  [TextTransform] [int] NULL,
  [ControlHeight] [int] NULL,
  [InputMask] [nvarchar](100) NULL,
  [Autopostback] [bit] NULL,
  [UserID] [nvarchar](30) NULL,
  [LangID] [nvarchar](10) NULL,
  [RegisterInJS] [bit] NULL,
  [JSVariable] [nvarchar](50) NULL,
  [TLType] [int] NULL,
  [ExFromWhere] [bit] NULL,
  [TreePK] [bit] NULL,
  [IfFilter] [bit] NULL,
  [IsFilter] [bit] NULL,
  [ACEnable] [bit] NULL,
  [JACEnable] [bit] NULL,
  [JSpellCheck] [bit] NULL,
  [JSpellCheckSuggestion] [bit] NULL,
  [ServicePath] [nvarchar](100) NULL,
  [ServiceMethod] [nvarchar](100) NULL,
  [MinimumPrefixLength] [int] NULL,
  [CompletionSetCount] [int] NULL,
  [JACDelay] [int] NULL,
  [ACSql] [nvarchar](4000) NULL,
  [Caption] [nvarchar](500) NULL,
  [OnChange] [nvarchar](max) NULL,
  [Is2Dir] [bit] NULL,
  [FieldName] [nvarchar](200) NULL,
  [phtml] [nvarchar](300) NULL,
  [shtml] [nvarchar](300) NULL,
  [p1] [nvarchar](50) NULL,
  [p2] [nvarchar](50) NULL,
  [b1] [bit] NULL,
  [b2] [bit] NULL,
  [EditOnGrid] [bit] NULL,
  [ShowTooltip] [bit] NULL,
  [NoCustomize] [bit] NULL,
  [IsComputed] [bit] NULL,
  [NoUseRSTATUS] [bit] NULL,
  [NoRowspan] [int] NULL,
  [ControlSource] [nvarchar](max) NULL,
  [GridColCaption] [nvarchar](500) NULL,
  [LastUpdate] [datetime] NULL,
  [UpdateUser] [nvarchar](100) NULL,
  [UpdateInfo] [nvarchar](255) NULL,
  [LinkToTree] [bit] NULL,
  [CaptionStyle] [nvarchar](500) NULL,
  [ControlStyle] [nvarchar](max) NULL,
  [GridColCaptionStyle] [nvarchar](500) NULL,
  [VisibleOnReport] [bit] NULL,
  [RdlIsUrl] [bit] NULL,
  [CalMLocation] [nvarchar](50) NULL,
  [CalMActionType] [nvarchar](50) NULL,
  [ShowInGridSummary] [bit] NULL,
  [ClearMultiSelect] [bit] NULL,
  [HtmlEncode] [bit] NULL,
  [SaveFilesInOneFolder] [bit] NULL,
  [Autocallback] [bit] NULL,
  [TextEditorEnable] [bit] NULL,
  [ValidateErrMessage] [nvarchar](500) NULL,
  [DTXFilterByValue] [bit] NULL,
  CONSTRAINT [PK_VS_FormFields] PRIMARY KEY NONCLUSTERED ([FieldID], [FormID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_VS_FormFields_FormID]
  ON [dbo].[VS_FormFields] ([FormID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[VS_FormFields_insert_update_trigger] ON [dbo].[VS_FormFields]
AFTER INSERT, UPDATE
AS  
BEGIN
	SET NOCOUNT ON
	DECLARE @FormID nvarchar(50),
			@FieldID nvarchar(50),
			@Description nvarchar(255)

	DECLARE insert_cursor_VS_FormFields CURSOR FOR 
		SELECT FormID, FieldID
		FROM inserted
	OPEN insert_cursor_VS_FormFields
	FETCH NEXT FROM insert_cursor_VS_FormFields 
	INTO @FormID, @FieldID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @FormID IN (SELECT FormID FROM deleted WHERE FieldID = @FieldID)
			SET @Description = 'ZMIANA'
		ELSE
			SET @Description = 'NOWY REKORD'

		UPDATE [dbo].[VS_FormFields]
		SET LastUpdate = getdate(), UpdateUser = suser_sname() + '; ' + host_name(), UpdateInfo = @Description
		WHERE FormID = @FormID
		AND FieldID = @FieldID

		FETCH NEXT FROM insert_cursor_VS_FormFields 
		INTO @FormID, @FieldID
	END
	CLOSE insert_cursor_VS_FormFields	
	DEALLOCATE insert_cursor_VS_FormFields
END
GO