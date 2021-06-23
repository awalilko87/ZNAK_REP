SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[VS_FormFields_GetByFormIDNotToUse](
    @FormID nvarchar(50) = '%',
	  @UserID nvarchar(30) = '%'
)
WITH ENCRYPTION
AS

DECLARE @LangID nvarchar(50), @GroupID nvarchar(20)
--set statistics io on
	SELECT @LangID = LangID, @GroupID = ISNULL(UserGroupID,'') FROM SYUsers WHERE UserID = @UserID
	SELECT
        VS_FormFields.FieldID, 
        VS_FormFields.FormID, 
        ISNULL(SYS_MsgField.Caption, VS_FormFields.Caption) Caption, 
        CaptionStyle, 
        FieldName, 
        TableName,
        IsPK, ControlType, CaptionWidth, ControlWidth, NoColumn,
        NoRow, NoColspan, Require, RequireQuery, ControlSource, ControlStyle,
        Visible, VisibleQuery, ReadOnly, ReadOnlyQuery, DefaultValue,
        DataType, DataTypeSQL, Length, ValidateQuery, TextRows,
        TextColumns, ISNULL(SYS_MsgField.Tooltip, VS_FormFields.Tooltip) Tooltip, GridPk, 
		CASE 
		WHEN ISNULL(VS_FormFields.GridColIndex,1) < 1 THEN  ISNULL(VS_FormFields.GridColIndex,1)
		WHEN ISNULL(VS_FormFieldProfiles.GridColVisible,1)=1 AND ISNULL(VS_FormFieldProfilesGroup.GridColVisible,1)=1 THEN
			ISNULL(VS_FormFieldProfiles.GridColIndex,VS_FormFields.GridColIndex)
		ELSE
			0
		END GridColIndex,
		CASE WHEN VS_FormFields.GridColWidth < 0 THEN VS_FormFields.GridColWidth ELSE 
		ISNULL(VS_FormFieldProfilesGroup.GridColWidth, ISNULL(VS_FormFieldProfiles.GridColWidth,VS_FormFields.GridColWidth))END GridColWidth,
        NotUse, AllowSort, AllowFilter, DisplayFieldFormat, DisplayGridFormat,
        ISNULL(SYS_MsgField.ValidateErrMessage, VS_FormFields.ValidateErrMessage) ValidateErrMessage,
		ISNULL(SYS_MsgField.GridColCaption, VS_FormFields.GridColCaption) GridColCaption,
		GridColCaptionStyle, ISNULL(SYS_MsgField.CallbackMessage, VS_FormFields.CallbackMessage) CallbackMessage, CallbackQuery, GridAllign,
        CaptionAlign, ControlAlign, PanelGroup, '' FieldDesc, AllowReportParam, TextTransform,
        ControlHeight, InputMask, Autopostback, VS_FormFields.UserID, @LangID LangID,
        RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK,
        IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength,
        CompletionSetCount, '' AS ACSql, OnChange, Is2Dir, phtml,
        shtml, p1, p2, b1, b2,
        EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS,
		NoRowspan, LinkToTree, VisibleOnReport, RdlIsUrl,CalMLocation,CalMActionType,
		ShowInGridSummary, ClearMultiSelect, HtmlEncode, SaveFilesInOneFolder,
		Autocallback, JACEnable, TextEditorEnable, JSpellCheck, JSpellCheckSuggestion, JACDelay
    FROM dbo.VS_FormFields VS_FormFields (NOLOCK) 
    
	LEFT JOIN dbo.SYS_MsgField SYS_MsgField
		ON SYS_MsgField.LangID = @LangID 
		AND SYS_MsgField.ObjectType = 'FIELD' 
		AND SYS_MsgField.ObjectID = VS_FormFields.FormID
		AND SYS_MsgField.ControlID = VS_FormFields.FieldID

	LEFT JOIN dbo.VS_FormFieldProfiles VS_FormFieldProfiles(NOLOCK)
		ON VS_FormFieldProfiles.FormID=VS_FormFields.FormID
		AND VS_FormFieldProfiles.FieldID=VS_FormFields.FieldID
		AND VS_FormFieldProfiles.UserID=@UserID

	LEFT JOIN dbo.VS_FormFieldProfilesGroup VS_FormFieldProfilesGroup(nolock)
		ON VS_FormFieldProfilesGroup.FormID=VS_FormFields.FormID
		AND VS_FormFieldProfilesGroup.FieldID=VS_FormFields.FieldID
		AND VS_FormFieldProfilesGroup.UserGroupID=@GroupID
				  
    WHERE VS_FormFields.FormID = @FormID AND NotUse = 1
	ORDER BY NotUse, NoRow, NoColumn DESC, VS_FormFields.FieldID
GO