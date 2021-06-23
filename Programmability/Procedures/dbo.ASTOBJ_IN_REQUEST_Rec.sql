SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ASTOBJ_IN_REQUEST_Rec] 
(
    @p_ID nvarchar(50),
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

	SELECT TOP 1 *
	FROM [dbo].[ASTOBJ_IN_REQUESTv] (NOLOCK) 
	WHERE 1 = 1  and SRQ_ROWID = @p_ID

end
GO