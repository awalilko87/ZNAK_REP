SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create function [dbo].[EmpDesc](@p_EMP nvarchar(30), @p_ORG nvarchar(30))
returns nvarchar(80)
as
begin
	declare @v_ret nvarchar(80)

	select @v_ret = EMP_DESC from dbo.EMP(nolock) where EMP_CODE = @p_EMP and EMP_ORG in (@p_ORG,'*')

	return @v_ret
end
GO