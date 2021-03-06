SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_Update](
    @FieldID nvarchar(50) OUT,
    @FormID nvarchar(50) OUT,
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
    @ValidateErrMessage nvarchar(500),
    @GridColCaption nvarchar(500),
    @GridColCaptionStyle nvarchar(500),
    @CallbackMessage nvarchar(400),
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
    @phtml nvarchar(300) = null,
    @shtml nvarchar(300) = null,
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
	@JSpellCheck bit= NULL,
	@JSpellCheckSuggestion bit = NULL,	
	@JACDelay int = NULL
)

AS

IF @FieldID is null
    SET @FieldID = NewID()
IF @FieldID =''
    SET @FieldID = NewID()
IF @FormID is null
    SET @FormID = NewID()
IF @FormID =''
    SET @FormID = NewID()

IF NOT EXISTS (SELECT * FROM VS_FormFields WHERE FieldID = @FieldID AND FormID = @FormID)
BEGIN
    INSERT INTO VS_FormFields(
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
        Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay)
    VALUES (
        @FieldID, @FormID, @Caption, @CaptionStyle, @FieldName, @TableName,
        @IsPK, @ControlType, @CaptionWidth, @ControlWidth, @NoColumn,
        @NoRow, @NoColspan, @Require, @RequireQuery, @ControlSource, @ControlStyle,
        @Visible, @VisibleQuery, @ReadOnly, @ReadOnlyQuery, @DefaultValue,
        @DataType, @DataTypeSQL, @Length, @ValidateQuery, @TextRows,
        @TextColumns, @Tooltip, @GridPk, @GridColIndex, @GridColWidth,
        @NotUse, @AllowSort, @AllowFilter, @DisplayFieldFormat, @DisplayGridFormat,
        @ValidateErrMessage, @GridColCaption, @GridColCaptionStyle, @CallbackMessage, @CallbackQuery, @GridAllign,
        @CaptionAlign, @ControlAlign, @PanelGroup, @FieldDesc, @AllowReportParam, @TextTransform,
        @ControlHeight, @InputMask, @Autopostback, @UserID, @LangID,
        @RegisterInJS, @JSVariable, @TLType, @ExFromWhere, @TreePK,
        @IsFilter, @ACEnable, @ServicePath, @ServiceMethod, @MinimumPrefixLength,
        @CompletionSetCount, @ACSql, @OnChange, @Is2Dir, @phtml,
        @shtml, @p1, @p2, @b1, @b2,
        @EditOnGrid, @ShowTooltip, @NoCustomize, @IsComputed, @NoUseRSTATUS,
        @NoRowspan, @LinkToTree, @VisibleOnReport, @RdlIsUrl,@CalMLocation,@CalMActionType,
        @ShowInGridSummary, @ClearMultiSelect, @HtmlEncode, @SaveFilesInOneFolder,
        @Autocallback, @JACEnable, @TextEditorEnable, @JSpellCheck, @JSpellCheckSuggestion, @JACDelay)
END
ELSE
BEGIN
    UPDATE VS_FormFields SET
        Caption = @Caption, CaptionStyle = @CaptionStyle, FieldName = @FieldName, TableName = @TableName, IsPK = @IsPK, ControlType = @ControlType,
        CaptionWidth = @CaptionWidth, ControlWidth = @ControlWidth, NoColumn = @NoColumn, NoRow = @NoRow, NoColspan = @NoColspan,
        Require = @Require, RequireQuery = @RequireQuery, ControlSource = @ControlSource, ControlStyle = @ControlStyle, Visible = @Visible, VisibleQuery = @VisibleQuery,
        ReadOnly = @ReadOnly, ReadOnlyQuery = @ReadOnlyQuery, DefaultValue = @DefaultValue, DataType = @DataType, DataTypeSQL = @DataTypeSQL,
        Length = @Length, ValidateQuery = @ValidateQuery, TextRows = @TextRows, TextColumns = @TextColumns, Tooltip = @Tooltip,
        GridPk = @GridPk, GridColIndex = @GridColIndex, GridColWidth = @GridColWidth, NotUse = @NotUse, AllowSort = @AllowSort,
        AllowFilter = @AllowFilter, DisplayFieldFormat = @DisplayFieldFormat, DisplayGridFormat = @DisplayGridFormat, ValidateErrMessage = @ValidateErrMessage, GridColCaption = @GridColCaption,
        GridColCaptionStyle = @GridColCaptionStyle, CallbackMessage = @CallbackMessage, CallbackQuery = @CallbackQuery, GridAllign = @GridAllign, CaptionAlign = @CaptionAlign, ControlAlign = @ControlAlign,
        PanelGroup = @PanelGroup, FieldDesc = @FieldDesc, AllowReportParam = @AllowReportParam, TextTransform = @TextTransform, ControlHeight = @ControlHeight, InputMask = @InputMask,
        Autopostback = @Autopostback, UserID = @UserID, LangID = @LangID, RegisterInJS = @RegisterInJS, JSVariable = @JSVariable,
        TLType = @TLType, ExFromWhere = @ExFromWhere, TreePK = @TreePK, IsFilter = @IsFilter, ACEnable = @ACEnable,
        ServicePath = @ServicePath, ServiceMethod = @ServiceMethod, MinimumPrefixLength = @MinimumPrefixLength, CompletionSetCount = @CompletionSetCount, ACSql = @ACSql,
		OnChange = @OnChange, Is2Dir = @Is2Dir, phtml = @phtml, shtml = @shtml, p1 = @p1,
        p2 = @p2, b1 = @b1, b2 = @b2, EditOnGrid = @EditOnGrid, ShowTooltip = @ShowTooltip,
        NoCustomize = @NoCustomize, IsComputed = @IsComputed, NoUseRSTATUS = @NoUseRSTATUS, NoRowspan = @NoRowspan, LinkToTree = @LinkToTree,
        VisibleOnReport = @VisibleOnReport, RdlIsUrl = @RdlIsUrl,CalMLocation=@CalMLocation,CalMActionType=@CalMActionType,
        ShowInGridSummary = @ShowInGridSummary, ClearMultiSelect = @ClearMultiSelect, HtmlEncode = @HtmlEncode, SaveFilesInOneFolder = @SaveFilesInOneFolder,
        Autocallback = @Autocallback, JACEnable = @JACEnable, TextEditorEnable=@TextEditorEnable, JSpellCheck = @JSpellCheck, JSpellCheckSuggestion = @JSpellCheckSuggestion, JACDelay = @JACDelay
        WHERE FieldID = @FieldID AND FormID = @FormID
END
GO