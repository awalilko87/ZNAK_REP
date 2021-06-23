SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[COM_Rec] 
(
    @p_ID nvarchar(50),
	@p_FIDP nvarchar(50),  
    @p_FID nvarchar(50),  
    @p_UserID nvarchar(30)
)
as
begin
declare @v_pref nvarchar(3), @v_table nvarchar(50), @v_org nvarchar(30), @v_rstatus int
select @v_pref = TablePrefix, @v_table = TableName from dbo.VS_Forms (nolock) where FormID = (select top 1 UpdateObject from dbo.VS_Forms (nolock) where FormID = @p_FID) 

declare @sql nvarchar(4000), @sp_ParmDefinition nvarchar(1000)
	set @sp_ParmDefinition = N'@o_org nvarchar(30) output, @o_rstatus int output'
	select @sql = 'select @o_rstatus = '+@v_pref+'_RSTATUS, @o_org = '+@v_pref+'_ORG from [dbo].[' + @v_table + '] A (nolock) where '+@v_pref+'_ID = '''+@p_ID+''''
	--raiserror(@sql,16,1)
	execute sp_executesql @sql, @sp_ParmDefinition, @o_org = @v_org output, @o_rstatus = @v_rstatus output

	SELECT 
    NEW_COMMENT = ''
  , RSTATUS = @v_rstatus

--buttons rights
, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_REFRESH'))
, [TLB_ADDNEW_RIGHT] =	1+(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_ADDNEW'))
, [TLB_DELETE_RIGHT] =	1+(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_DELETE'))
, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_SAVE'))
, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_PRINT'))
, [TLB_COPYREC_RIGHT] = 1+(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_COPYREC'))
, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_PREV'))
, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] ('*', @p_FID, @p_UserID, N'TLB_NEXT'))


end


GO