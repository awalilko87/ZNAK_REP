SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[AllowPOLSave](@p_POTID int, @p_UserID nvarchar(30))
returns tinyint
as
begin
	declare @v_GroupID nvarchar(30)

	select @v_GroupID = UserGroupID from dbo.SYUsers where UserID = @p_UserID

	if exists (select 1 from dbo.OBJTECHPROT where POT_ROWID = @p_POTID and POT_STATUS = 'POT_002'
											and case @v_GroupID
													when 'SA' then 1 
													when 'IT' then CHK_GU_IT
													when 'ITA' then CHK_GU_IT
													when 'DZR' then CHK_GU_DZR
													when 'DZRA' then CHK_GU_DZR
													when 'RKB' then CHK_GU_RKB
													when 'RKBA' then CHK_GU_RKB
													when 'UR' then CHK_GU_UR
													when 'URA' then CHK_GU_UR
													else 0 
												end = 1)
	begin
		return 1
	end
	
	
	return 0
end
GO