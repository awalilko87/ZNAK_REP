SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, QueryStringGridFieldID, QueryStringFieldID, QueryStringFieldUserID, Title,
        SQLSelect, SQLProc, SQLGridSelect, SQLUpdate, SQLDelete, IsVirtualTable,
        InDebug, ShowSaveButton, ShowDeleteButton, ShowNewButton, PopupReturn,
        GridHeight, GridWidth, EditAreaWidth, EditAreaHeight, GridHeaderHeight,
        ShowGrid, ShowTree, RefreshGridAfterBtnClick, ShowVerticalTree, ExpandTree, GTAutoSize, TableName, TablePrefix,
        SQLTreeSelect, AllowExcelExport, ButtonTextNew, ButtonTextDelete, ButtonTextSave,
        FieldTreeDescription, FieldTreeID, FieldTreeParentID, FormDescription, NoOverrideDefaulByLink,
        PreLoadDefault, AdminWhere, UserWhere, PageSize, AllowSorting,
        AllowPagging, ShowFilter, AddWhere, RegisterVariable, UpdateObject,
        UserID, LangID, ShowDataSpy, AltSavePrompt, AltRequirePrompt,
        AltRecCountPrompt, AltPageOfCounter, DisableSGWhere, DisableSOWhere, ObjType, ShowTLine,
        TLGroupWidth, RowHeight, RemHTMLTag, MultiSelect, AddNewIfEmpty,
        StartupCmd, NoSOAW, NoSSAW, AllowQuickFilter, ClearQuickFilter, TreeWidth,
        TreeHeight, CustOrder, TreeNullValue, LGT, pHeight,
        pWidth, Child, DBTab, ShowHelp, ShowHelpPdf, QSVariable,
        HideErr, SectionName, GroupID, AutoPageOff, p1,
        p2, b1, b2, ToTrans, HideTitle,
        DefFField, DynamicTitle, AllowEditGrid, EditDataspy, Customize,
	    CondFormatGrid, TryCatchSQL, EnableSystemTran, MultiOrg,
	    ShowCal,CalHeight,CalWidth,CalShowEventStartTime,CalShowEventEndTime,CalShowWeekend,
	    CalStartDateField,CalEndDateField,CalEventNameField,CalEventDescField,CalEventIDField,
	    SQLSelectCal,CalTypeField,CalBGColorField,CalCheck,CalMove,CalPrint,CalSQLFD,CalMType,CalMoveSQL,MultiSelectRefresh,
	    RdlSchemaId,CalGanttWMD,CalGanttWWD,CalGanttWDH,CalGanttWHQ,
		CalGanttDZ,CalGanttDG,CalGanttZ,CalMonthNM,CalMonthNH,CalMonthH,CalGanttIDRes,CalGanttRes,CalGanttStart,CalGanttEnd,CalGanttWMW,CalGanttResTT,
		CalGanttDefX,CalDAD,CalGanttGroPar,CalEvMovePB,CalEvResizePB,CalAResources,CalAId, ShowGridColsConf, ShowMultifilterButtons, 
		'' AS AddWhereSystemFilter, ShowGridSummary, ExpandTreeToLevel, ExpandTreeLevel, TurnQuickFilterOn, WithoutPostbackOnQSC, CheckIfDataWhereChanged,
		AllowGridColumnReorder, ShowErrorsInDialogBox, GridEditMode, UseContextMenu, TruncGridContent, ShowMultifilterClearButtons
    FROM VS_Forms
	ORDER BY FormID
GO