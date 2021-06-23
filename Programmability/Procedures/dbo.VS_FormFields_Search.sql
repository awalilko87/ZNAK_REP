SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_Search](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
    @Caption nvarchar(500),
    @CaptionStyle nvarchar(500),
    @FieldName nvarchar(200),
    @TableName nvarchar(50),
    @IsPK bit,
    @ControlType nvarchar(50),
    @CaptionWidth int,
    @ControlWidth int,
    @NoColumn int,
    @NoRow int,
    @NoColspan int,
    @Require bit,
    @RequireQuery nvarchar(max),
    @ControlSource nvarchar(max),
    @ControlStyle nvarchar(max),
    @Visible bit,
    @VisibleQuery nvarchar(max),
    @ReadOnly bit,
    @ReadOnlyQuery nvarchar(max),
    @DefaultValue nvarchar(max),
    @DataType nvarchar(50),
    @DataTypeSQL nvarchar(50),
    @Length int,
    @ValidateQuery nvarchar(max),
    @TextRows int,
    @TextColumns int,
    @Tooltip nvarchar(max),
    @GridPk bit,
    @GridColIndex int,
    @GridColWidth int,
    @NotUse bit,
    @AllowSort bit,
    @AllowFilter bit,
    @DisplayFieldFormat nvarchar(50),
    @DisplayGridFormat nvarchar(50),
    @ValidateErrMessage nvarchar(150),
    @GridColCaption nvarchar(500),
    @GridColCaptionStyle nvarchar(500),
    @CallbackMessage nvarchar(50),
    @CallbackQuery nvarchar(max),
    @GridAllign nvarchar(10),
    @CaptionAlign nvarchar(10),
    @ControlAlign nvarchar(10),
    @PanelGroup nvarchar(2),
    @FieldDesc nvarchar(max),
    @AllowReportParam bit,
    @TextTransform int,
    @ControlHeight int,
    @InputMask nvarchar(100),
    @Autopostback bit,
    @UserID nvarchar(30),
    @LangID nvarchar(10),
    @RegisterInJS bit,
    @JSVariable nvarchar(50),
    @TLType int,
    @ExFromWhere bit,
    @TreePK bit,
    @IsFilter bit,
    @ACEnable bit,	
    @ServicePath nvarchar(100),
    @ServiceMethod nvarchar(100),
    @MinimumPrefixLength int,
    @CompletionSetCount int,	
    @ACSql nvarchar(4000),
	@OnChange nvarchar(max),
    @Is2Dir bit,
    @phtml nvarchar(300),
    @shtml nvarchar(300),
    @p1 nvarchar(50) = null,
    @p2 nvarchar(50) = null,
    @b1 bit = null,
    @b2 bit = null,
    @EditOnGrid bit = null,
    @ShowTooltip bit = null,
    @NoCustomize bit = null,
    @IsComputed bit = null,
    @NoUseRSTATUS bit = null,
    @NoRowspan int = null,
	@LinkToTree bit = null,
	@VisibleOnReport bit = null,
	@RdlIsUrl bit = null,
	@CalMLocation nvarchar(50) = null,
	@CalMActionType nvarchar(50) = null,
	@ShowInGridSummary bit = NULL,
	@ClearMultiSelect bit = NULL,
	@HtmlEncode bit = NULL,
	@SaveFilesInOneFolder bit = NULL,
	@Autocallback bit = NULL,
	@JACEnable bit = NULL,	
	@TextEditorEnable bit = NULL,
	@JSpellCheck bit = NULL,
	@JSpellCheckSuggestion bit = NULL,
	@JACDelay int = NULL
)
WITH ENCRYPTION
AS

    SELECT
        FieldID, FormID, Caption, CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ValidateErrMessage, GridColCaption, GridColCaptionStyle, CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, UserID, LangID,
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
        NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
        ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder, 
        Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields
            /* WHERE Caption = @Caption AND FieldName = @FieldName AND TableName = @TableName AND IsPK = @IsPK AND ControlType = @ControlType AND
            CaptionWidth = @CaptionWidth AND ControlWidth = @ControlWidth AND NoColumn = @NoColumn AND NoRow = @NoRow AND NoColspan = @NoColspan AND
            Require = @Require AND RequireQuery = @RequireQuery AND ControlSource = @ControlSource AND Visible = @Visible AND VisibleQuery = @VisibleQuery AND
            ReadOnly = @ReadOnly AND ReadOnlyQuery = @ReadOnlyQuery AND DefaultValue = @DefaultValue AND DataType = @DataType AND DataTypeSQL = @DataTypeSQL AND
            Length = @Length AND ValidateQuery = @ValidateQuery AND TextRows = @TextRows AND TextColumns = @TextColumns AND Tooltip = @Tooltip AND
            GridPk = @GridPk AND GridColIndex = @GridColIndex AND GridColWidth = @GridColWidth AND NotUse = @NotUse AND AllowSort = @AllowSort AND
            AllowFilter = @AllowFilter AND DisplayFieldFormat = @DisplayFieldFormat AND DisplayGridFormat = @DisplayGridFormat AND ValidateErrMessage = @ValidateErrMessage AND GridColCaption = @GridColCaption AND
            CallbackMessage = @CallbackMessage AND CallbackQuery = @CallbackQuery AND GridAllign = @GridAllign AND CaptionAlign = @CaptionAlign AND PanelGroup = @PanelGroup AND
            FieldDesc = @FieldDesc AND AllowReportParam = @AllowReportParam AND TextTransform = @TextTransform AND ControlHeight = @ControlHeight AND InputMask = @InputMask AND
            Autopostback = @Autopostback AND UserID = @UserID AND LangID = @LangID AND RegisterInJS = @RegisterInJS AND JSVariable = @JSVariable AND
            TLType = @TLType AND ExFromWhere = @ExFromWhere AND TreePK = @TreePK AND IsFilter = @IsFilter AND ACEnable = @ACEnable AND JACEnable = @JACEnable AND JSpellCheck = @JSpellCheck AND
            ServicePath = @ServicePath AND ServiceMethod = @ServiceMethod AND MinimumPrefixLength = @MinimumPrefixLength AND CompletionSetCount = @CompletionSetCount AND ACSql = @ACSql
			AND OnChange = @OnChange AND Is2Dir = @Is2Dir AND phtml = @phtml AND shtml = @shtml AND p1 = @p1 AND
            p2 = @p2 AND b1 = @b1 AND b2 = @b2 AND EditOnGrid = @EditOnGrid AND ShowTooltip = @ShowTooltip AND
            NoCustomize = @NoCustomize AND IsComputed = @IsComputed AND NoUseRSTATUS = @NoUseRSTATUS AND NoRowspan = @NoRowspan */
GO