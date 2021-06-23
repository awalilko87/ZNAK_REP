SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetASTValue](@p_AST nvarchar(30), @p_SUBCODE nvarchar(10))
returns money
as
begin
	declare @v_ret numeric(16,2)
	
	select
		@v_ret = sum(convert(numeric(16,2),AST_SAP_URWRT)) 
	from (
		select
			AST_SAP_URWRT
		from dbo.ASSET
		where AST_CODE = @p_AST and AST_SUBCODE = @p_SUBCODE
		union all
		select
			AST_SAP_URWRT
		from dbo.ASSET
		where AST_CODE = @p_AST and AST_SUBCODE <> @p_SUBCODE and AST_DONIESIENIE = 1 and @p_SUBCODE = '0000')ast
	
	return @v_ret
end
GO