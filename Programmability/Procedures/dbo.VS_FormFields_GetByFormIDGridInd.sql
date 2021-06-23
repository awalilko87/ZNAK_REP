SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetByFormIDGridInd](
    @FormID nvarchar(50) = '%',
    @Filtr nvarchar(50),
	@SortCol nvarchar(50)
)
WITH ENCRYPTION
AS
	IF (@SortCol = 'GridColIndex')
		SELECT
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
			Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
		FROM VS_FormFields
			 WHERE FormID = @FormID AND (FieldID LIKE '%' + @Filtr + '%' OR Caption LIKE '%' + @Filtr + '%' OR FieldName LIKE '%' + @Filtr + '%' OR ControlType LIKE '%' + @Filtr + '%')
		ORDER BY GridColIndex
	ELSE
		SELECT
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
			Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
		FROM VS_FormFields
			 WHERE FormID = @FormID AND (FieldID LIKE '%' + @Filtr + '%' OR Caption LIKE '%' + @Filtr + '%' OR FieldName LIKE '%' + @Filtr + '%' OR ControlType LIKE '%' + @Filtr + '%')
		ORDER BY CASE @SortCol 
			WHEN 'FieldID' THEN FieldID 
			WHEN 'Caption' THEN Caption
			WHEN 'FieldName' THEN FieldName
			WHEN 'ControlType' THEN ControlType
		END, NotUse, NoRow, NoColumn
GO