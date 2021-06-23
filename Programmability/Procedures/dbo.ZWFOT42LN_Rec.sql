SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT42LN_Rec] 
(
    @p_OT42LNID int,
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
, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_REFRESH'))
, [TLB_ADDNEW_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_ADDNEW'))
, [TLB_DELETE_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_DELETE'))
, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_SAVE'))
, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_PRINT'))
, [TLB_COPYREC_RIGHT] = (select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_COPYREC'))
, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_PREV'))
, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] (OTL_ORG, @p_FID, @p_UserID, N'TLB_NEXT'))

	FROM [dbo].[ZWFOT42LNv] (NOLOCK) 
	WHERE 1 = 1 and [OT42LN_ROWID] = @p_OT42LNID

end 

GO