SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_GetByIDToUse](
  @FormID nvarchar(50) = '%',
	@UserID nvarchar(30) = '%',
	@TabGroupID nvarchar(50) = '',
	@TabID nvarchar(50) = ''
)
WITH ENCRYPTION
AS
	DECLARE @LangID nvarchar(50), @GroupID nvarchar(20)
	SELECT @LangID = ISNULL(LangID,''), @GroupID = ISNULL(UserGroupID,'') FROM SYUsers WHERE UserID = @UserID

	DECLARE @Filter nvarchar(2000),
		@TabFilter nvarchar(2000)
	SET @Filter = ''
	SELECT @TabFilter = ''

	SELECT @Filter = ISNULL(SqlWhere,'') FROM VS_Filters WHERE FormID = @FormID AND UserID = @UserID AND GroupID = @GroupID
	IF @Filter = ''
		SELECT @Filter = ISNULL(SqlWhere,'') FROM VS_Filters WHERE FormID = @FormID AND GroupID = @GroupID and UserID = ''	
		
	DECLARE @AddWhere nvarchar(2000)
	SET @AddWhere = ''
	SELECT @AddWhere = AddWhere FROM VS_Forms WHERE FormID = @FormID	
	DECLARE @WhereClause nvarchar(4000)
	SET @WhereClause = ''
	IF (LEN(@AddWhere) > 2 AND LEN(@Filter) > 2)
		SET @WhereClause = @AddWhere + ' AND ' + @Filter
	ELSE IF (LEN(@AddWhere) <= 2 AND LEN(@Filter) > 2)
		SET @WhereClause = @Filter
	ELSE IF (LEN(@AddWhere) > 2 AND LEN(@Filter) <= 2)
		SET @WhereClause = @AddWhere
	ELSE IF (LEN(@AddWhere) <= 2 AND LEN(@Filter) <= 2)
		SET @WhereClause = ''
	ELSE
		SET @WhereClause = '' 

	SELECT TOP 1 @TabFilter = ISNULL(SqlWhere,'') FROM VS_TabFilters (NOLOCK) WHERE TabGroupID = @TabGroupID AND TabID = @TabID 
		AND FormID = @FormID AND GroupID = @GroupID AND IsActive = 1
	
	IF @TabFilter != ''
	BEGIN
		IF @WhereClause != ''
		BEGIN 
			SELECT @WhereClause = @WhereClause+ ' AND ( ' +@TabFilter+' )'
		END
		ELSE
		BEGIN
			SELECT @WhereClause = ' WHERE (' + @TabFilter + ')'
		END
	END
	
    SELECT
        FormID, QueryStringGridFieldID, QueryStringFieldID, QueryStringFieldUserID, ISNULL(SYS_MsgForm.Caption, Title) Title,
        SQLSelect, SQLProc, SQLGridSelect, SQLUpdate, SQLDelete, IsVirtualTable,
        InDebug, ShowSaveButton, ShowDeleteButton, ShowNewButton, PopupReturn,
        GridHeight, GridWidth, EditAreaWidth, EditAreaHeight, GridHeaderHeight,
        ISNULL(ShowGrid,0) ShowGrid, ISNULL(ShowTree,0) ShowTree, ISNULL(RefreshGridAfterBtnClick,0) RefreshGridAfterBtnClick,
		    ISNULL(ShowVerticalTree, 0) ShowVerticalTree, ISNULL(ExpandTree, 0) ExpandTree, ISNULL(GTAutoSize,0)GTAutoSize, TableName, TablePrefix,
        SQLTreeSelect, AllowExcelExport, ISNULL(SYS_MsgForm.ButtonTextNew, VS_Forms.ButtonTextNew) ButtonTextNew, 
		    ISNULL(SYS_MsgForm.ButtonTextDelete, VS_Forms.ButtonTextDelete) ButtonTextDelete,
		    ISNULL(SYS_MsgForm.ButtonTextSave, VS_Forms.ButtonTextSave) ButtonTextSave,
        FieldTreeDescription, FieldTreeID, FieldTreeParentID, FormDescription, NoOverrideDefaulByLink,
        PreLoadDefault, AdminWhere, UserWhere, PageSize, AllowSorting, AllowPagging, ShowFilter, @WhereClause AS AddWhere,
        RegisterVariable, UpdateObject, UserID, @LangID LangID, ShowDataSpy,
		    ISNULL(SYS_MsgForm.AltSavePrompt, VS_Forms.AltSavePrompt) AltSavePrompt, 
		    ISNULL(SYS_MsgForm.AltRequirePrompt, VS_Forms.AltRequirePrompt) AltRequirePrompt,
        ISNULL(SYS_MsgForm.AltRecCountPrompt, VS_Forms.AltRecCountPrompt)AltRecCountPrompt,
		ISNULL(SYS_MsgForm.AltPageOfCounter, VS_Forms.AltPageOfCounter)AltPageOfCounter,
		 DisableSGWhere, DisableSOWhere, ObjType, ShowTLine,
		    TLGroupWidth, RowHeight, RemHTMLTag, MultiSelect, AddNewIfEmpty,
		    StartupCmd, NoSOAW, NoSSAW, AllowQuickFilter, ClearQuickFilter, TreeWidth,
        TreeHeight, CustOrder, TreeNullValue, LGT, pHeight,
        pWidth, Child, DBTab, ShowHelp, ShowHelpPdf, QSVariable,
        HideErr, SectionName, GroupID, AutoPageOff, p1,
        p2, b1, b2, ToTrans, HideTitle,
        DefFField, DynamicTitle, AllowEditGrid, EditDataspy, Customize,
		    CondFormatGrid, TryCatchSQL, EnableSystemTran, MultiOrg ,
		    ShowCal,CalHeight,CalWidth,CalShowEventStartTime,CalShowEventEndTime,CalShowWeekend,
		    CalStartDateField,CalEndDateField,CalEventNameField,CalEventDescField,CalEventIDField,
		    SQLSelectCal,CalTypeField,CalBGColorField,CalCheck,CalMove,CalPrint,CalSQLFD,CalMType,CalMoveSQL,
		    MultiSelectRefresh, RdlSchemaId,CalGanttWMD,CalGanttWWD,CalGanttWDH,CalGanttWHQ,
				CalGanttDZ,CalGanttDG,CalGanttZ,CalMonthNM,CalMonthNH,CalMonthH,CalGanttIDRes,CalGanttRes,
				CalGanttStart,CalGanttEnd,CalGanttWMW,CalGanttResTT,CalGanttDefX,CalDAD,CalGanttGroPar,
				CalEvMovePB,CalEvResizePB,CalAResources,CalAId, ShowGridColsConf, ShowMultifilterButtons, @Filter as AddWhereSystemFilter, ShowGridSummary,
				ExpandTreeToLevel, ExpandTreeLevel, TurnQuickFilterOn, WithoutPostbackOnQSC, CheckIfDataWhereChanged,
				AllowGridColumnReorder, ShowErrorsInDialogBox, GridEditMode, UseContextMenu, TruncGridContent, ShowMultifilterClearButtons
    FROM VS_Forms LEFT JOIN (SELECT * FROM SYS_MsgForm WHERE LangID = @LangID) SYS_MsgForm 
				ON VS_Forms.FormID = SYS_MsgForm.ObjectID AND SYS_MsgForm.ControlID = ''
         WHERE FormID LIKE @FormID
GO