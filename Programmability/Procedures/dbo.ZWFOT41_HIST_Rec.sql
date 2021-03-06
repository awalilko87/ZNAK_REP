SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[ZWFOT41_HIST_Rec] 
(
    @p_OT41ID int,
    @p_TYPE nvarchar(30),
	@p_FIDP nvarchar(50),  
    @p_FID nvarchar(50),  
    @p_UserID nvarchar(30)
)
as
begin
--declare @v_pref nvarchar(3)
--select @v_pref = TablePrefix from dbo.VS_Forms (nolock) where FormID = @p_FID
	declare @v_LangID nvarchar(10)
	select @v_LangID = LangID from dbo.SYUsers(nolock) where UserID = @p_UserID

	SELECT TOP 1 
  *
--buttons rights
, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_REFRESH'))
, [TLB_ADDNEW_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_ADDNEW'))
, [TLB_DELETE_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_DELETE'))
, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_SAVE'))
, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_PRINT'))
, [TLB_COPYREC_RIGHT] = (select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_COPYREC'))
, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_PREV'))
, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] (OT_ORG, @p_FID, @p_UserID, N'TLB_NEXT'))

	FROM [dbo].[ZWFOT41_HISTv] (NOLOCK) 
	WHERE 1 = 1  and [OT41_ROWID] = @p_OT41ID and [OT_TYPE] = @p_TYPE

end











GO