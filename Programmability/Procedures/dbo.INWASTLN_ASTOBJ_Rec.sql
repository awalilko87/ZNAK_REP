SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWASTLN_ASTOBJ_Rec] 
(
    @p_ID nvarchar(50),
	/*@p_ASTCODE nvarchar(50),  
	@p_ASTSUBCODE nvarchar(50),  
	@p_BARCODE nvarchar(50),*/  
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
, [TLB_REFRESH_RIGHT] = (select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_REFRESH'))
, [TLB_ADDNEW_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_ADDNEW'))
, [TLB_DELETE_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_DELETE'))
, [TLB_SAVE_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_SAVE'))
, [TLB_PRINT_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_PRINT'))
, [TLB_COPYREC_RIGHT] = (select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_COPYREC'))
, [TLB_PREV_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_PREV'))
, [TLB_NEXT_RIGHT] =	(select [dbo].[GetBtnRight] (SIA_ORG, @p_FID, @p_UserID, N'TLB_NEXT'))

	FROM [dbo].[AST_INWLN_ASTOBJv] (NOLOCK) 
	WHERE 1 = 1 
		and [SIA_LANGID] = @v_LangID 
		and [SIA_PK] = @p_ID
		/*and [SIA_ASTCODE] = @p_ASTCODE 
		and [SIA_ASTSUBCODE] = @p_ASTSUBCODE 
		and [SIA_BARCODE] = @p_BARCODE*/  
	  
	 

end
GO