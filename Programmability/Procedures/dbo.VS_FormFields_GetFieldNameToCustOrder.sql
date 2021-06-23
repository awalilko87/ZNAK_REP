SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetFieldNameToCustOrder](
    @FormID nvarchar(50),
    @LangID nvarchar(30)
)
WITH ENCRYPTION
AS
	SELECT
        FieldID, FormID, coalesce(l.Caption,f.Caption) as Caption, f.FieldName,CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, [ReadOnly], ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, [Length], ValidateQuery, TextRows,
        TextColumns, f.Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        f.ValidateErrMessage, f.GridColCaption, GridColCaptionStyle, f.CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, isnull(PanelGroup, 'C') PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, UserID, f.[LangID],
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields f
	  left join VS_LANGMSGS l on l.ObjectType = 'FIELD' and l.ObjectID = f.FormID and l.ControlID = f.FieldID AND l.[LangID] = @LangID
        WHERE f.FormID = @FormID
        AND f.FieldName <> '' 
        AND (ExFromWhere = 0 OR ExFromWhere is null)
        AND GridColWidth > 0 
        AND GridColIndex > 0
        AND dbo.fn_TRIMHTMLTAGS(isnull(coalesce(l.Caption,f.Caption), '')) <> ''
        AND isnull(NotUse,0) = 0
	ORDER BY coalesce(l.Caption,f.Caption)
GO