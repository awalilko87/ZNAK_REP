SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetByFormIDGroupProf](
    @FormID nvarchar(50) = '%',
	@UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS
	DECLARE @LangID nvarchar(50), @GroupID nvarchar(20)

	SELECT @LangID = LangID, @GroupID = ISNULL(UserGroupID,'') FROM SYUsers(NOLOCK) WHERE UserID = @UserID
	SELECT
        ff.FieldID, ff.FormID, ISNULL(SYS_MsgField.Caption, ff.Caption) Caption, CaptionStyle, FieldName, TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
				Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        TextColumns, ISNULL(SYS_MsgField.Tooltip, ff.Tooltip) Tooltip, GridPk, 
				CASE WHEN ISNULL(pg.GridColVisible,1)=1 AND ISNULL(ff.GridColIndex,1)>0 THEN
					ISNULL(pg.GridColIndex,ff.GridColIndex)
				ELSE
					0
				END GridColIndex, 
				ISNULL(pg.GridColWidth,ff.GridColWidth) GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ISNULL(SYS_MsgField.ValidateErrMessage, ff.ValidateErrMessage) ValidateErrMessage,
				ISNULL(SYS_MsgField.GridColCaption, ff.GridColCaption) GridColCaption,
				GridColCaptionStyle, ISNULL(SYS_MsgField.CallbackMessage, ff.CallbackMessage) CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, PanelGroup, '' FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, ff.UserID, @LangID LangID,
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, '' AS ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM VS_FormFields ff(NOLOCK)
			LEFT JOIN (SELECT * FROM SYS_MsgField (NOLOCK) WHERE LangID = @LangID AND ObjectType = 'FIELD' AND ObjectID = @FormID) SYS_MsgField 
				ON ff.FormID = SYS_MsgField.ObjectID AND SYS_MsgField.ControlID = ff.FieldID
			LEFT JOIN (SELECT * FROM dbo.VS_FormFieldProfilesGroup (NOLOCK) WHERE  FormID = @FormID AND UserGroupID=@GroupID) pg
				ON pg.FormID=ff.FormID AND pg.FieldID=ff.FieldID
    WHERE ff.FormID = @FormID AND NotUse = 0 AND isnull(ff.GridColWidth,0)>-1 and isnull(ff.GridColIndex,0)>0
	ORDER BY NotUse, NoRow, NoColumn DESC, ff.FieldID
GO