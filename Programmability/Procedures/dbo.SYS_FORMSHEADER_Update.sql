SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--exec SYS_FORMSHEADER_Update 'EVT_RC','@EVT_CODE','@EVT_STATUS_DESC','@EVT_DESC',null,'Nr ZP', 'Status', 'Opis', null, 'MATEO'
CREATE procedure [dbo].[SYS_FORMSHEADER_Update] 
(
 @p_FormID nvarchar(100)
,@p_FieldID_A nvarchar(100)
,@p_FieldID_B nvarchar(100)
,@p_FieldID_C nvarchar(100)
,@p_FieldID_D nvarchar(100)
,@p_Caption_A nvarchar(100)
,@p_Caption_B nvarchar(100)
,@p_Caption_C nvarchar(100)
,@p_Caption_D nvarchar(100)
,@p_UserID nvarchar(30)
)
as
begin
begin transaction 
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_LangID nvarchar(10)
	declare @v_ControlSource nvarchar(max)
	declare @v_ObjType nvarchar(10)
  
	select @v_LangID = dbo.fn_GetLangID(@p_UserID)


	begin try
		--VS_FormHeader
		if not exists (select * from dbo.VS_FormHeader (nolock) where FormID = @p_FormID and Panel = 'A')
			insert into dbo.VS_FormHeader (FormID, Panel, FieldID, Caption) values (@p_FormID, 'A', @p_FieldID_A, @p_Caption_A)
		else
			update dbo.VS_FormHeader set FieldID = @p_FieldID_A, Caption = @p_Caption_A where FormID = @p_FormID and Panel = 'A'

		if not exists (select * from dbo.VS_FormHeader (nolock) where FormID = @p_FormID and Panel = 'B')
			insert into dbo.VS_FormHeader (FormID, Panel, FieldID, Caption) values (@p_FormID, 'B', @p_FieldID_B, @p_Caption_B)
		else
			update dbo.VS_FormHeader set FieldID = @p_FieldID_B, Caption = @p_Caption_B where FormID = @p_FormID and Panel = 'B'

		if not exists (select * from dbo.VS_FormHeader (nolock) where FormID = @p_FormID and Panel = 'C')
			insert into dbo.VS_FormHeader (FormID, Panel, FieldID, Caption) values (@p_FormID, 'C', @p_FieldID_C, @p_Caption_C)
		else
			update dbo.VS_FormHeader set FieldID = @p_FieldID_C, Caption = @p_Caption_C where FormID = @p_FormID and Panel = 'C'

		if not exists (select * from dbo.VS_FormHeader (nolock) where FormID = @p_FormID and Panel = 'D')
			insert into dbo.VS_FormHeader (FormID, Panel, FieldID, Caption) values (@p_FormID, 'D', @p_FieldID_D, @p_Caption_D)
		else
			update dbo.VS_FormHeader set FieldID = @p_FieldID_D, Caption = @p_Caption_D where FormID = @p_FormID and Panel = 'D'

		--VS_LangMSGS

		insert into dbo.VS_LangMSGS (LangID, ObjectID, ObjectType, ControlID, Caption) 
		select 'PL', @p_FormID,'HEAD','Panel_A',@p_Caption_A 
		where not exists (select 1 from dbo.VS_LangMsgs(nolock) where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_A')
		union all
		select LangID, @p_FormID, 'HEAD', 'Panel_A', null
		from dbo.VS_Langs(nolock)
		where LangID <> 'PL'
		and not exists (select 1 from dbo.VS_LangMsgs(nolock) where VS_LangMsgs.LangID = VS_Langs.LangID and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_A')
		
		update dbo.VS_LangMsgs set
			Caption = @p_Caption_A
		where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_A'


		insert into dbo.VS_LangMSGS (LangID, ObjectID, ObjectType, ControlID, Caption) 
		select 'PL', @p_FormID,'HEAD','Panel_B',@p_Caption_B 
		where not exists (select 1 from dbo.VS_LangMsgs(nolock) where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_B')
		union all
		select LangID, @p_FormID, 'HEAD', 'Panel_B', null
		from dbo.VS_Langs(nolock)
		where LangID <> 'PL'
		and not exists (select 1 from dbo.VS_LangMsgs(nolock) where VS_LangMsgs.LangID = VS_Langs.LangID and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_B')
		
		update dbo.VS_LangMsgs set
			Caption = @p_Caption_B
		where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_B'

		insert into dbo.VS_LangMSGS (LangID, ObjectID, ObjectType, ControlID, Caption) 
		select 'PL', @p_FormID,'HEAD','Panel_C',@p_Caption_C 
		where not exists (select 1 from dbo.VS_LangMsgs(nolock) where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_C')
		union all
		select LangID, @p_FormID, 'HEAD', 'Panel_C', null
		from dbo.VS_Langs(nolock)
		where LangID <> 'PL'
		and not exists (select 1 from dbo.VS_LangMsgs(nolock) where VS_LangMsgs.LangID = VS_Langs.LangID and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_C')
		
		update dbo.VS_LangMsgs set
			Caption = @p_Caption_C
		where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_C'

		insert into dbo.VS_LangMSGS (LangID, ObjectID, ObjectType, ControlID, Caption) 
		select 'PL', @p_FormID,'HEAD','Panel_D',@p_Caption_D 
		where not exists (select 1 from dbo.VS_LangMsgs(nolock) where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_D')
		union all
		select LangID, @p_FormID, 'HEAD', 'Panel_D', null
		from dbo.VS_Langs(nolock)
		where LangID <> 'PL'
		and not exists (select 1 from dbo.VS_LangMsgs(nolock) where VS_LangMsgs.LangID = VS_Langs.LangID and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_D')
		
		update dbo.VS_LangMsgs set
			Caption = @p_Caption_D
		where [LangID] = 'PL' and ObjectID = @p_FormID and ObjectType = 'HEAD' and ControlID = 'Panel_D'


		--header formatki
		if coalesce(@p_FieldID_A,@p_FieldID_B,@p_FieldID_C,@p_FieldID_D) is not null
		begin
			select @v_ControlSource = 'select dbo.GetFormHeader (@QS_FID,'+isnull(@p_FieldID_A,'null')+','
									+isnull(@p_FieldID_B,'null')+','+isnull(@p_FieldID_C,'null')+','+isnull(@p_FieldID_D,'null')+',@_UserID)'
		end
		else
		begin
			select @v_ControlSource = ''
		end

		--LBL_HEADER
		if not exists (select * from dbo.VS_FormFields where FieldID = 'LBL_HEADER' and FormID = @p_FormID) and @v_ControlSource <> ''
			insert into VS_FormFields (FieldID, FormID, ControlSource, TableName, ControlType, CaptionWidth, ControlWidth, NoColumn, NoRow, 
									NoColspan, RequireQuery, VisibleQuery, ReadOnlyQuery, DefaultValue, DataType, DataTypeSQL, Length, 
									ValidateQuery, TextRows, TextColumns, Tooltip, GridColIndex, GridColWidth, DisplayFieldFormat, DisplayGridFormat, 
									CallbackMessage, CallbackQuery, GridAllign, CaptionAlign, PanelGroup, FieldDesc, IsPK, Require, Visible, ReadOnly, 
									GridPk, NotUse, AllowSort, AllowFilter, AllowReportParam, TextTransform, ControlHeight, InputMask, Autopostback, UserID, 
									LangID, ValidateErrMessage, RegisterInJS, JSVariable, TLType, ExFromWhere, TreePK, IfFilter, IsFilter, ACEnable, 
									ServicePath, ServiceMethod, MinimumPrefixLength, CompletionSetCount, ACSql, Caption, OnChange, Is2Dir, FieldName, 
									phtml, shtml, p1, p2, b1, b2, EditOnGrid, ShowTooltip, NoCustomize, IsComputed, NoUseRSTATUS, NoRowspan, GridColCaption)
			values ('LBL_HEADER', @p_FormID, @v_ControlSource, '', 'LBC', 0, 400, 12, 1, 
					0, '', '', '', '', '', '', 0, 
					'', 0, 0, '', 0, 0, '', '', 
					'', '', '', '', '0', '', 0, 0, 1, 0, 
					0, 0, 0, 0, 0, 0, 0, '', 0, NULL, 
					NULL, '', 0, '', 0, 0, 0, NULL, 0, 
					0, '', '', 0, 0, '', '', '', 0, '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 2, '')
		else
			update dbo.VS_FormFields set
				ControlSource = @v_ControlSource
			where FieldID = 'LBL_HEADER' and FormID = @p_FormID
	end try
	begin catch
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'SYS_001'
		goto errorlabel
	end catch;

commit transaction
return 0

errorlabel:
	rollback transaction
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1)
    return 1
end

GO