SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetByFormID](
    @FormID nvarchar(50) = '%',
	@Filtr nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
	WITH LANGS AS(
		SELECT 
		 LM.Caption,
		 LM.ObjectID,
		 LM.ControlID,
		 U.UserID
        FROM VS_LangMsgs LM
          JOIN SYUsers U ON LM.[LangID] = U.[LangID]
        WHERE LM.ObjectType = 'FIELD' 
        AND isnull(LM.Caption,'') <> ''
	)
    SELECT
        FF.FieldID, FF.FormID, 
		case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
			 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
			 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
		end as Caption, 
		FF.CaptionStyle, FF.FieldName, FF.TableName,
        FF.IsPK, FF.ControlType, FF.CaptionWidth, FF.ControlWidth, FF.NoColumn,
        FF.NoRow, FF.NoColspan, FF.Require, RequireQuery, ControlSource, ControlStyle,
        FF.Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        FF.DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        FF.TextColumns, FF.Tooltip, GridPk, GridColIndex, GridColWidth,
        FF.NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        FF.ValidateErrMessage, FF.GridColCaption, GridColCaptionStyle, FF.CallbackMessage, CallbackQuery, GridAllign,
        FF.CaptionAlign, ControlAlign, isnull(nullif(PanelGroup, ''), 'C') AS PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        FF.ControlHeight, InputMask, Autopostback, FF.UserID, FF.[LangID],
        FF.RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        FF.IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        FF.CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        FF.shtml, p1, p2, b1, b2,
        FF.EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		FF.NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		FF.ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		FF.Autocallback, FF.JACEnable, FF.TextEditorEnable, FF.JSpellCheck, FF.JSpellCheckSuggestion, FF.JACDelay
    FROM VS_FormFields FF
      left join LANGS LM ON LM.ObjectID = FF.FormID AND LM.ControlID = FF.FieldID AND LM.UserID = @_USERID_
         WHERE FF.FormID = @FormID 
         AND (FF.FieldID LIKE '%' + @Filtr + '%' 
           OR FF.Caption LIKE '%' + @Filtr + '%' 
           OR FF.FieldName LIKE '%' + @Filtr + '%' 
           OR FF.ControlType LIKE '%' + @Filtr + '%'
           OR coalesce(LM.Caption, FF.Caption) like '%' + @Filtr + '%')
	ORDER BY NotUse, PanelGroup, NoRow, NoColumn, FieldID
GO