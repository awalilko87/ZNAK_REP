SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_AddStatements](
	@FormID nvarchar(50)
)
AS
DECLARE @RC int
, @FieldID nvarchar(50), @Caption nvarchar(500), @CaptionStyle nvarchar(500), @FieldName nvarchar(200), @TableName nvarchar(50)
, @IsPK bit, @ControlType nvarchar(50), @CaptionWidth int, @ControlWidth int, @NoColumn int, @NoRow int, @NoColspan int
, @Require bit, @RequireQuery nvarchar(150), @ControlSource nvarchar(4000), @ControlStyle nvarchar(4000), @Visible bit, @VisibleQuery nvarchar(150), @ReadOnly bit
, @ReadOnlyQuery nvarchar(150), @DefaultValue nvarchar(150), @DataType nvarchar(50), @DataTypeSQL nvarchar(50), @Length int, @ValidateQuery nvarchar(150)
, @TextRows int, @TextColumns int, @Tooltip nvarchar(150), @GridPk bit, @GridColIndex int, @GridColWidth int, @NotUse bit
, @AllowSort bit, @AllowFilter bit, @DisplayFieldFormat nvarchar(50), @DisplayGridFormat nvarchar(50), @ValidateErrMessage nvarchar(150)
, @GridColCaption nvarchar(50), @GridColCaptionStyle nvarchar(500), @CallbackMessage nvarchar(50), @CallbackQuery nvarchar(150), @GridAllign nvarchar(10)
, @CaptionAlign nvarchar(10), @ControlAlign nvarchar(10), @PanelGroup nvarchar(2), @FieldDesc nvarchar(150), @AllowReportParam bit, @TextTransform int
, @ControlHeight int, @InputMask nvarchar(100), @Autopostback bit, @UserID nvarchar(30), @LangID nvarchar(10)
, @RegisterInJS bit, @JSVariable nvarchar(50), @TLType int, @ExFromWhere bit, @TreePK bit, @IsFilter bit, @ACEnable bit
, @ServicePath nvarchar(100), @ServiceMethod nvarchar(100), @MinimumPrefixLength int, @CompletionSetCount int
, @ACSql nvarchar(4000), @OnChange nvarchar(150), @Is2Dir bit, @lPath nvarchar(150)

-- TODO: Set parameter values here.
SET @IsPK =0 SET @CaptionWidth = 0 SET @NoColspan = 0
SET @Require = 0 SET @RequireQuery = '' SET @Visible = 1 SET @VisibleQuery = '' SET @ReadOnly = 0
SET @ReadOnlyQuery = '' SET @DefaultValue = '' SET @DataType = '' SET @DataTypeSQL = '' SET @Length = 0
SET @ValidateQuery = '' SET @TextRows = 0 SET @TextColumns = 0 SET @GridPk = 0 SET @GridColIndex = 0
SET @GridColWidth = 0 SET @NotUse = 0 SET @AllowSort = 0 SET @AllowFilter = 0 SET @DisplayFieldFormat = ''
SET @DisplayGridFormat = '' SET @ValidateErrMessage = '' SET @GridColCaption = '' SET @CallbackMessage = ''
SET @CallbackQuery = '' SET @GridAllign = '' SET @CaptionAlign =''  SET @PanelGroup = 'A' 
SET @AllowReportParam = 0  SET @TextTransform = 0  SET @InputMask = ''  SET @Autopostback = 0 
SET @UserID = null  SET @LangID = null  SET @RegisterInJS = 0  SET @JSVariable = ''  SET @TLType= 0 
SET @ExFromWhere = 1 SET @TreePK = 0 SET @IsFilter = 0 SET @ACEnable = 0 SET @ServicePath = ''
SET @ServiceMethod = '' SET @MinimumPrefixLength = 0 SET @CompletionSetCount = 0 SET @ACSql = ''
SET @OnChange = '' SET @Is2Dir = 0 SET @Caption = '' SET @ControlType ='LBL' SET @TableName = '' 
SET @Tooltip = '' SET @ControlWidth = 600 SET @ControlSource = '' SET @ControlHeight = 0
/* Inne dla kazdego przycisku */

/* Komunikat zapisu */
SET @FieldID = 'LBL_SAVESTATEMENT'
SET @FieldName = '<span style="color:green;">{0}</span>'
SET @NoColumn = 1 
SET @NoRow = 1
SET @FieldDesc = 'Pole komunikatu zapisu danych' --ntext

EXECUTE @RC = [VS_FormFields_Update] @FieldID output, @FormID output,@Caption,@CaptionStyle,@FieldName,@TableName,@IsPK,@ControlType,@CaptionWidth,
	@ControlWidth,@NoColumn,@NoRow,@NoColspan,@Require,@RequireQuery,@ControlSource,@ControlStyle,@Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,
	@DefaultValue,@DataType,@DataTypeSQL,@Length,@ValidateQuery,@TextRows,@TextColumns,@Tooltip,@GridPk,@GridColIndex,@GridColWidth,@NotUse,
	@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,@GridColCaption,@GridColCaptionStyle,@CallbackMessage,
	@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,@AllowReportParam,@TextTransform,@ControlHeight,@InputMask,
	@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType,@ExFromWhere,@TreePK,@IsFilter,@ACEnable,null,@ServicePath,@ServiceMethod,
	@MinimumPrefixLength,@CompletionSetCount,@ACSql,@OnChange,@Is2Dir

/* Komunikat bledu */
SET @FieldID = 'LBL_ERRORSTATEMENT'
SET @FieldName = '<span style="color:red;">{1}</span>'
SET @NoColumn = 1 
SET @NoRow = 2
SET @FieldDesc = 'Pole komunikatu błędu' --ntext

EXECUTE @RC = [VS_FormFields_Update] @FieldID output, @FormID output,@Caption,@CaptionStyle,@FieldName,@TableName,@IsPK,@ControlType,@CaptionWidth,
	@ControlWidth,@NoColumn,@NoRow,@NoColspan,@Require,@RequireQuery,@ControlSource,@ControlStyle,@Visible,@VisibleQuery,@ReadOnly,@ReadOnlyQuery,
	@DefaultValue,@DataType,@DataTypeSQL,@Length,@ValidateQuery,@TextRows,@TextColumns,@Tooltip,@GridPk,@GridColIndex,@GridColWidth,@NotUse,
	@AllowSort,@AllowFilter,@DisplayFieldFormat,@DisplayGridFormat,@ValidateErrMessage,@GridColCaption,@GridColCaptionStyle,@CallbackMessage,
	@CallbackQuery,@GridAllign,@CaptionAlign,@ControlAlign,@PanelGroup,@FieldDesc,@AllowReportParam,@TextTransform,@ControlHeight,@InputMask,
	@Autopostback,@UserID,@LangID,@RegisterInJS,@JSVariable,@TLType,@ExFromWhere,@TreePK,@IsFilter,@ACEnable,null,@ServicePath,@ServiceMethod,
	@MinimumPrefixLength,@CompletionSetCount,@ACSql,@OnChange,@Is2Dir

GO