SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_FORMSTOOLBAR_Update] 
(
  @p_Prefix nvarchar(10)
, @p_FormID nvarchar(100)
, @_UserID nvarchar(50)
)
as
begin transaction 
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)

begin
  declare @v_ControlSource nvarchar(max)
  declare @v_ObjType nvarchar(10)
  declare @v_COPYREC_val nvarchar(100)

  select @p_Prefix = isnull(@p_Prefix,'')
  select top 1 @v_ObjType = isnull(ObjType,'') from dbo.VS_Forms (nolock) where FormID = @p_FormID

  if @v_ObjType = 'LST'
	set @v_COPYREC_val = ''
  else
	set @v_COPYREC_val = 'isnull(@QS_COPYREC,0)+'

  BEGIN TRY
	
	--TLB_SAVE
	declare @v_ControlSourceSave nvarchar(500)
	
	if @v_ObjType = 'LST' --and @p_FormID like '%[_]LS'
	  set @v_ControlSourceSave = 'REFRESH;
'
	else
	  set @v_ControlSourceSave = 'SAVE;
'

	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_SAVE' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_SAVE', @p_FormID, @v_ControlSourceSave, '/Images/32x32/Save 2.png', 's',		'IMC',		'Zapisz', 0,			28,			28,				1,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''SAVE''',		 0,		1,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_SAVE', FormID = @p_FormID, ControlSource = @v_ControlSourceSave, PanelGroup = '0', TableName = 's', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 1,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'Zapisz',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''SAVE''',  IsPK = 0,  Require = 1,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Save 2.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_SAVE' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_SAVE_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_SAVE_RIGHT', @p_FormID, '',				'',		'',			'HTX',		'',				0,			0,			0,				1,		1,		0,			'',			'',				'',				'',			'System.Int16',	'int',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			1,		'TLB_SAVE_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_SAVE_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 1,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = 'System.Int16',  DataTypeSQL = 'int',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 1,  FieldName = 'TLB_SAVE_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_SAVE_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_SAVE' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_SAVE', '', '', '@TLB_SAVE_RIGHT', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = '@TLB_SAVE_RIGHT'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_SAVE' and Cond = ''

	--TLB_ADDNEW
	declare @v_ControlSourceAddNew nvarchar(500)
	if @v_ObjType = 'LST' and @p_FormID like '%[_]LS'
	  select top 1 @v_ControlSourceAddNew = 'URL Tabs3.aspx?TGR='+MenuID+'&TAB='+TabName+'&FID='+replace(FormID,'&A=1','&A=0')+'&QSC=ADDNEW;SQL select @TLB_SAVE_RIGHT = [dbo].[GetBtnRight] (@'+@p_Prefix+'_ORG, @QS_FID, @_UserID, N''TLB_SAVE'');;
' from dbo.VS_Tabs (nolock) where FormID not like '%&A=1' and replace(replace(FormID,'&A=0',''),'&A=1','') = (select top 1 FormID from dbo.VS_Forms (nolock) where UpdateObject = @p_FormID and FormID like '%[_]RC')
	else
	  select @v_ControlSourceAddNew = 'ADDNEW;SQL select @TLB_SAVE_RIGHT = [dbo].[GetBtnRight] (@'+@p_Prefix+'_ORG, @QS_FID, @_UserID, N''TLB_SAVE'');;'
	
--select * from dbo.VS_Tabs (nolock) where FormID like 'RST_LS%'
	
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_ADDNEW' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_ADDNEW', @p_FormID, @v_ControlSourceAddNew, '/Images/32x32/Symbol Add.png', 'n',		'IMC',		'Dodaj', 0,			28,			28,				2,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''ADDNEW''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '',				0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_ADDNEW', FormID = @p_FormID, ControlSource = @v_ControlSourceAddNew, PanelGroup = '0', TableName = 'n', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 2,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'Dodaj',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''ADDNEW''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Symbol Add.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_ADDNEW' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_ADDNEW_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (		'TLB_ADDNEW_RIGHT',		@p_FormID, '',			'',		'',		'HTX',		'',				0,			0,			0,				2,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_ADDNEW_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_ADDNEW_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 2,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_ADDNEW_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_ADDNEW_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_ADDNEW' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_ADDNEW', '', '', @v_COPYREC_val+'@TLB_ADDNEW_RIGHT', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'@TLB_ADDNEW_RIGHT'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_ADDNEW' and Cond = ''

	--TLB_DELETE
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_DELETE' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_DELETE', @p_FormID, 'DELETE;', '/Images/32x32/Symbol Restricted.png', 'd',		'IMC',		'UsuĹ„', 0,			28,			28,				3,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''DELETE''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'Czy na pewno chcesz usunÄ…Ä‡?',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_DELETE', FormID = @p_FormID, ControlSource = 'DELETE;', PanelGroup = '0', TableName = 'd', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 3,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'UsuĹ„',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''DELETE''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = 'Czy na pewno chcesz usunÄ…Ä‡?',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Symbol Restricted.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_DELETE' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_DELETE_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (		'TLB_DELETE_RIGHT', @p_FormID, '',				'',		'',		'HTX',		'',				0,			0,			0,				1,		3,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_DELETE_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_DELETE_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 3,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = 'Czy na pewno chcesz usunÄ…Ä‡?',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_DELETE_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_DELETE_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_DELETE' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_DELETE', '', '', @v_COPYREC_val+'isnull(@TLB_DELETE_RIGHT,1)', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'isnull(@TLB_DELETE_RIGHT,1)'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_DELETE' and Cond = ''
	
	
	--TLB_PRINT
	declare @v_ControlSourcePRINT nvarchar(1000)
	declare @v_ReportE64 nvarchar(500)

	--select @v_ReportE64 = [dbo].[VS_EncodeBase64] ('R;'+@p_FormID)
	select @v_ControlSourcePRINT = 'R;'+@p_FormID+';;;0;0;0;;;;;'

	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_PRINT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (				'TLB_PRINT', @p_FormID, @v_ControlSourcePRINT, '/Images/32x32/Printer.png', 'p',		'IMR',		'Drukuj', 0,			28,			28,				4,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny wywolujacy raport',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '',		0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_PRINT', FormID = @p_FormID, ControlSource = @v_ControlSourcePRINT, PanelGroup = '0', TableName = 'p', ControlType = 'IMR', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 4,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'Drukuj',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny wywolujacy raport',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Printer.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_PRINT' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_PRINT_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (		'TLB_PRINT_RIGHT', @p_FormID, '',				'',		'',		'HTX',		'',				0,			0,			0,				4,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_PRINT_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_PRINT_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 4,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_PRINT_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_PRINT_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_PRINT' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_PRINT', '', '', @v_COPYREC_val+'isnull(@TLB_PRINT_RIGHT,1)', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'isnull(@TLB_PRINT_RIGHT,1)'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_PRINT' and Cond = ''
	
	--TLB_COPYREC
	declare @v_ControlSourceCOPYREC nvarchar(500)
	if @v_ObjType = 'LST' and @p_FormID like '%[_]LS'
	  select top 1 @v_ControlSourceCOPYREC = 'URL Tabs3.aspx?TGR='+MenuID+'&TAB='+TabName+'&FID='+replace(FormID,'&A=1','&A=0')+'&COPYREC=1&QSC=ADDNEW;;' 
	  from VS_Tabs where FormID not like '%&A=1' and replace(replace(FormID,'&A=0',''),'&A=1','') = (select FormID from dbo.VS_Forms (nolock) where UpdateObject = @p_FormID and FormID like '%[_]RC')
	else
    begin
	if exists (select * from dbo.SYMenus (nolock) where HTTPLink like '%'+replace(@p_FormID,'_','[_]')+'%')
	  select top 1 @v_ControlSourceCOPYREC = 'URL '+HTTPLink+'&COPYREC=1&QSC=ADDNEW;;' 
	  from dbo.SYMenus (nolock) where HTTPLink like '%'+@p_FormID+'%'
	else
	  select top 1 @v_ControlSourceCOPYREC = 'URL Tabs3.aspx?TGR='+MenuID+'&TAB='+TabName+'&FID='+FormID+'&COPYREC=1&QSC=ADDNEW;;' 
	  from dbo.VS_Tabs where FormID = @p_FormID+'&A=0'

	end

	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_COPYREC' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_COPYREC', @p_FormID, @v_ControlSourceCOPYREC, '/Images/32x32/Copy.png', 'n',		'IMC',		'Dodaj', 0,			28,			28,				5,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''Kopiuj rekord''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_COPYREC', FormID = @p_FormID, ControlSource = @v_ControlSourceCOPYREC, PanelGroup = '0', TableName = 'n', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 5,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'Kopiuj rekord',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''Kopiuj rekord''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Copy.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_COPYREC' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_COPYREC_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (		'TLB_COPYREC_RIGHT',		@p_FormID, '',			'',		'',		'HTX',		'',				0,			0,			0,				5,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_COPYREC_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_COPYREC_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 5,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_COPYREC_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_COPYREC_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_COPYREC' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_COPYREC', '', '', @v_COPYREC_val+'isnull(@TLB_COPYREC_RIGHT,1)', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'isnull(@TLB_COPYREC_RIGHT,1)'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_COPYREC' and Cond = ''

	--TLB_PREV

	declare @v_ControlSourcePREV nvarchar(1000)

	if @v_ObjType = 'LST' and @p_FormID like '%[_]LS'
--	  select top 1 @v_ControlSourcePREV = 'MOVEPREVPARENT;
--URL Tabs3.aspx?TGR='+MenuID+'&TAB='+TabName+'&FID='+FormID+';
--' from dbo.VS_Tabs (nolock) where FormID not like '%&A=1' and replace(replace(FormID,'&A=0',''),'&A=1','') = (select top 1 FormID from dbo.VS_Forms (nolock) where UpdateObject = @p_FormID and FormID like '%[_]LS')
	  select @v_ControlSourcePREV = 'MOVEPREV;'
	else
	  select @v_ControlSourcePREV = 'MOVEPREVPARENT;'

	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_PREV' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values ('TLB_PREV', @p_FormID, @v_ControlSourcePREV, '/Images/32x32/Navigation 1 Up Green.png', 'r',		'IMC',		'NastÄ™pny rekord', 0,			28,			28,				6,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVEPREV''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'TLB_PREV', FormID = @p_FormID, ControlSource = @v_ControlSourcePREV, PanelGroup = '0', TableName = 'r', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 6,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'NastÄ™pny rekord',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVEPREV''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Navigation 1 Up Green.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_PREV' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_PREV_RIGHT' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values (		'TLB_PREV_RIGHT', @p_FormID, '',				'',		'',		'HTX',		'',				0,			0,			0,				6,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_PREV_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'TLB_PREV_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 6,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_PREV_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_PREV_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_PREV' and Cond = '')
	  insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_PREV', '', '', @v_COPYREC_val+'@TLB_PREV_RIGHT', '', '')
	else
	  update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'@TLB_PREV_RIGHT'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_PREV' and Cond = ''
	
	--TLB_NEXT

	declare @v_ControlSourceNEXT nvarchar(1000)

	if @v_ObjType = 'LST' and @p_FormID like '%[_]LS'
--	select top 1 @v_ControlSourceNEXT = 'MOVENEXTPARENT;
--URL Tabs3.aspx?TGR='+MenuID+'&TAB='+TabName+'&FID='+FormID+';
--' from dbo.VS_Tabs (nolock) where FormID not like '%&A=1' and replace(replace(FormID,'&A=0',''),'&A=1','') = (select top 1 FormID from dbo.VS_Forms (nolock) where UpdateObject = @p_FormID and FormID like '%[_]LS')
	select @v_ControlSourceNEXT = 'MOVENEXT;'
	else
	  select @v_ControlSourceNEXT = 'MOVENEXTPARENT;'

	
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_NEXT' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values ('TLB_NEXT', @p_FormID, @v_ControlSourceNEXT, '/Images/32x32/Navigation 1 Down Green.png', 'r',		'IMC',		'NastÄ™pny rekord', 0,			28,			28,				7,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVENEXT''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'TLB_NEXT', FormID = @p_FormID, ControlSource = @v_ControlSourceNEXT, PanelGroup = '0', TableName = 'r', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 7,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'NastÄ™pny rekord',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''MOVENEXT''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Navigation 1 Down Green.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_NEXT' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_NEXT_RIGHT' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values (		'TLB_NEXT_RIGHT', @p_FormID, '',				'',		'',		'HTX',		'',				0,			0,			0,				7,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_NEXT_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'TLB_NEXT_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 7,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_NEXT_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_NEXT_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_NEXT' and Cond = '')
	  insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_NEXT', '', '', @v_COPYREC_val+'@TLB_NEXT_RIGHT', '', '')
	else
	  update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'@TLB_NEXT_RIGHT'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_NEXT' and Cond = ''


	--TLB_REFRESH
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_REFRESH' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption,					TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,																	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values ('TLB_REFRESH', @p_FormID, 'REFRESH;', '/Images/32x32/Symbol Refresh.png', 'r',		'IMC',		'OdĹ›wieĹĽ dane', 0,			28,			28,				8,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'Przycisk graficzny funkcyjny wykonujacy operacje ''REFRESH''',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'',			'',		'', '', '', 0, 0,	0,			0,				0,			0,			1,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_REFRESH', FormID = @p_FormID, ControlSource = 'REFRESH;', PanelGroup = '0', TableName = 'r', ControlType = 'IMC', CaptionWidth = 0,  ControlWidth = 28,  NoColumn = 8,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = 'OdĹ›wieĹĽ dane',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = 'Przycisk graficzny funkcyjny wykonujacy operacje ''REFRESH''',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 28,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '/Images/32x32/Symbol Refresh.png',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 1,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_REFRESH' and FormID = @p_FormID

	--right
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_REFRESH_RIGHT' and FormID = @p_FormID)
      insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName			, phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
      values (		'TLB_REFRESH_RIGHT', @p_FormID, '',				'',		'',		'HTX',		'',				0,			0,			0,				8,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		0,			0,		NULL,	0,			0,		'',				'',				0,					0,				'',		'',			0,		'TLB_REFRESH_RIGHT',	'',		'', '', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
      update dbo.VS_FormFields 
	  set FieldID = 'TLB_REFRESH_RIGHT', FormID = @p_FormID, ControlSource = '', PanelGroup = 'C', TableName = '', ControlType = 'HTX', CaptionWidth = 0,  ControlWidth = 0,  NoColumn = 8,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 0,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = 'TLB_REFRESH_RIGHT',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_REFRESH_RIGHT' and FormID = @p_FormID

	if not exists (select * from dbo.VS_Rights where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_REFRESH' and Cond = '')
      insert into dbo.VS_Rights (UserID, FormID, FieldID, Cond, Rights, rReadOnly, rVisible, rRequire)
						values ('*', @p_FormID, 'TLB_REFRESH', '', '', @v_COPYREC_val+'@TLB_REFRESH_RIGHT', '', '')
	else
      update dbo.VS_Rights 
	  set rReadOnly = @v_COPYREC_val+'@TLB_REFRESH_RIGHT'
	  where UserID = '*' and FormID = @p_FormID and FieldID = 'TLB_REFRESH' and Cond = ''
	
	
	--LBL_SAVESTATEMENT
	if not exists (select * from dbo.VS_FormFields where FieldID = 'LBL_SAVESTATEMENT' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName,														phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values (			'LBL_SAVESTATEMENT', @p_FormID, '',			'',		 '',		'LBL',		'',		0,				400,			0,				11,		1,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		1,			0,		NULL,		0,			0,		'',				'',				0,					0,				'',		'',			0,	'<span style="color:#00CC00; font-weight:bold; ">{0}</span>',	'',		'',	'', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'LBL_SAVESTATEMENT', FormID = @p_FormID, ControlSource = '', PanelGroup = '0', TableName = '', ControlType = 'LBL', CaptionWidth = 0,  ControlWidth = 400,  NoColumn = 11,  NoRow = 1,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 1,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = '<span style="color:#00CC00; font-weight:bold; ">{0}</span>',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'LBL_SAVESTATEMENT' and FormID = @p_FormID

	--LBL_ERRORSTATEMENT
	if not exists (select * from dbo.VS_FormFields where FieldID = 'LBL_ERRORSTATEMENT' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName,														phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values (			'LBL_ERRORSTATEMENT', @p_FormID, '',			'',		 '',		'LBL',		'',		0,				400,			0,				11,		2,		0,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'0',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		1,			0,		NULL,		0,			0,		'',				'',				0,					0,				'',		'',			0,	'<span style="color:#FF0000; font-weight:bold; ">{1}</span>',	'',		'',	'', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'LBL_ERRORSTATEMENT', FormID = @p_FormID, ControlSource = '', PanelGroup = '0', TableName = '', ControlType = 'LBL', CaptionWidth = 0,  ControlWidth = 400,  NoColumn = 11,  NoRow = 2,  NoColspan = 0,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 1,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = '<span style="color:#FF0000; font-weight:bold; ">{1}</span>',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'LBL_ERRORSTATEMENT' and FormID = @p_FormID

	--TLB_HR
	if not exists (select * from dbo.VS_FormFields where FieldID = 'TLB_HR' and FormID = @p_FormID)
	  insert into dbo.VS_FormFields (FieldID, FormID, ControlSource, Caption, TableName, ControlType, Tooltip, CaptionWidth, ControlWidth, ControlHeight, NoColumn, NoRow, NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, ValidateQuery, TextRows, TextColumns, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc,	IsPK, Require, Visible, ReadOnly, GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform,  InputMask, Autopostback, UserID, LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql,  OnChange, Is2Dir, FieldName,														phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
	  values (			'TLB_HR', @p_FormID, '',			'',		 '',		'LBL',		'',		0,				170,			0,				1,		2,		10,			'',			'',				'',				'',			'',			'',			0,		'',				0,		0,				0,			0,			'',						'',				'',				'',			'',			 '',				'C',		'',		 0,		0,		1,			0,		0,		0,		0,			0,			0,				0,				'',			0,			NULL,	NULL,	'',					0,				'',			0,		1,			0,		NULL,		0,			0,		'',				'',				0,					0,				'',		'',			0,	'',	'',		'',	'', '', 0, 0,	0,			0,				0,			0,			0,			0,			'')
	else
	  update dbo.VS_FormFields 
	  set FieldID = 'TLB_HR', FormID = @p_FormID, ControlSource = '', PanelGroup = '0', TableName = '', ControlType = 'LBL', CaptionWidth = 170,  ControlWidth = 0,  NoColumn = 1,  NoRow = 2,  NoColspan = 10,  RequireQuery = '',  VisibleQuery = '',  ReadOnlyQuery = '',  DefaultValue = '',  DataType = '',  DataTypeSQL = '',  Length = 0,  ValidateQuery = '',  TextRows = 0,  TextColumns = 0,  Tooltip = '',  GridColIndex = 0,  GridColWidth = 0,  DisplayFieldFormat = '',  DisplayGridFormat = '',  CallbackMessage = '',  CallbackQuery = '',  GridAllign = '',  CaptionAlign = '',  FieldDesc = '',  IsPK = 0,  Require = 0,  Visible = 1,  ReadOnly = 0,  GridPk = 0,  NotUse = 0,  AllowSort = 0,  AllowFilter = 0,  AllowReportParam = 0,  TextTransform = 0,  ControlHeight = 0,  InputMask = '',  Autopostback = 0,  UserID = NULL,  LangID = NULL,  ValidateErrMessage = '',  RegisterInJS = 0,  JSVariable = '',  TLType = 0,  ExFromWhere = 1,  TreePK = 0,  IfFilter = NULL,  IsFilter = 0,  ACEnable = 0,  ServicePath = '',  ServiceMethod = '',  MinimumPrefixLength = 0,  CompletionSetCount = 0,  ACSql = '',  Caption = '',  OnChange = '',  Is2Dir = 0,  FieldName = '',  phtml = '',  shtml = '',  p1 = '',  p2 = '',  b1 = 0,  b2 = 0,  EditOnGrid = 0,  ShowTooltip = 0,  NoCustomize = 0,  IsComputed = 0,  NoUseRSTATUS = 0,  NoRowspan = 0, GridColCaption = ''
	  where FieldID = 'TLB_HR' and FormID = @p_FormID

  END TRY
  BEGIN CATCH
    select @v_syserrorcode = error_message()
	select @v_errorcode = 'SYS_001'
	goto errorlabel
  END CATCH;

end 

commit transaction
return 0
errorlabel:
	rollback transaction
    exec err_proc @v_errorcode, @v_syserrorcode, @_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    return 1
end
GO