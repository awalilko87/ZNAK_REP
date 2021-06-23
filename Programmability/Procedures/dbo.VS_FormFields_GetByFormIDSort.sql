SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetByFormIDSort](
  @FormID nvarchar(50) = '%',
  @SortCol nvarchar(50),
  @Filtr nvarchar(50),
  @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
  IF @SortCol IN ('FieldID','Caption','FieldName','ControlType')
  BEGIN
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
        FieldID, FormID, 
        case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
			 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
			 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
		end as Caption, 
		CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ValidateErrMessage, GridColCaption, GridColCaptionStyle, CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, isnull(nullif(PanelGroup, ''), 'C') AS PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, FF.UserID, LangID,
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields FF
    left join LANGS LM ON LM.ObjectID = FF.FormID AND LM.ControlID = FF.FieldID AND LM.UserID = @_USERID_
    WHERE FormID = @FormID AND (FieldID LIKE '%' + @Filtr + '%' OR case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
								 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
								 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
							end LIKE '%' + @Filtr + '%' OR FieldName LIKE '%' + @Filtr + '%' OR ControlType LIKE '%' + @Filtr + '%')
	  ORDER BY CASE @SortCol 
		  WHEN 'FieldID' THEN FieldID 
      WHEN 'Caption' THEN case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
								 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
								 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
							end
		  WHEN 'FieldName' THEN FieldName
		  WHEN 'ControlType' THEN ControlType
  	END, NotUse, NoRow, NoColumn
  END
  ELSE IF @SortCol = 'GridColIndex'
  BEGIN
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
        FieldID, FormID, 
        case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
			 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
			 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
		end as Caption, 
		CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        TextColumns, Tooltip, GridPk, GridColIndex, GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ValidateErrMessage, GridColCaption, GridColCaptionStyle, CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, isnull(nullif(PanelGroup, ''), 'C') AS PanelGroup, FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, FF.UserID, LangID,
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields FF
      left join LANGS LM ON LM.ObjectID = FF.FormID AND LM.ControlID = FF.FieldID AND LM.UserID = @_USERID_
    WHERE FormID = @FormID AND (FieldID LIKE '%' + @Filtr + '%' OR case when coalesce(LM.Caption, FF.Caption, FF.FieldID) = '' then FF.FieldID
								 when coalesce(LM.Caption, FF.Caption, FF.FieldID) like '%[\/]%.%' then FF.FieldID
								 else coalesce(LM.Caption, FF.Caption, FF.FieldID) 
							end LIKE '%' + @Filtr + '%' OR FieldName LIKE '%' + @Filtr + '%' OR ControlType LIKE '%' + @Filtr + '%')
	  ORDER BY GridColIndex, NotUse, NoRow, NoColumn
  END
  
GO