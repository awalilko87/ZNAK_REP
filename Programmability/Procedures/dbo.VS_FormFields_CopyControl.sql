SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_CopyControl](
	@FormID nvarchar(50),
    @FieldID nvarchar(50),
	@NewFormID nvarchar(50),
	@NewControlID nvarchar(50)
)
WITH ENCRYPTION
AS

IF EXISTS (SELECT * FROM VS_FormFields WHERE FormID = @NewFormID AND FieldID = @NewControlID)
BEGIN
    RAISERROR ('1', 16, 1)
    RETURN
END
ELSE
BEGIN
	INSERT INTO VS_FormFields(
        FieldID, FormID, Caption, CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, [ReadOnly], ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, [Length], ValidateQuery, TextRows,
        TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ValidateErrMessage, GridColCaption, GridColCaptionStyle, CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, UserID, [LangID],
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay)
	SELECT
        @NewControlID, @NewFormID, Caption, CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, [ReadOnly], ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, [Length], ValidateQuery, TextRows,
        TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ValidateErrMessage, GridColCaption, GridColCaptionStyle, CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, isnull(PanelGroup, 'C') PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, UserID, [LangID],
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields
        WHERE FormID = @FormID AND FieldID = @FieldID
END

IF EXISTS (SELECT * FROM VS_Rights WHERE FormID = @NewFormID AND FieldID = @NewControlID)
BEGIN
    RAISERROR ('2', 16, 1)
    RETURN
END
ELSE
BEGIN
	INSERT INTO VS_Rights(
		UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
	SELECT 
		UserID, @NewFormID, @NewControlID, Cond, Rights, rReadOnly, rVisible, rRequire
	FROM VS_Rights
		WHERE FormID = @FormID AND FieldID = @FieldID
END
GO