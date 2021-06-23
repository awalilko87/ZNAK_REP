SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   function [dbo].[GetJSText_INVTSK_ADD_OBJ_LINES](@p_PSP nvarchar(30), @p_INOID int, @p_STS nvarchar(30))
returns nvarchar(max)
as
begin

	declare @v_js nvarchar(max)

	set @v_js = '<script type="text/javascript">
Sys.Application.add_load(function(){'

	select @v_js = @v_js + '
$(''#Simple1_myGrid2_Row_'+lp+'_OBJ_COUNT_edit'').attr(''value'', '+val+');'
	from (
	select
		lp = convert(varchar,row_number() over (order by STS_PARENTDESC asc))
		,val = convert(varchar,isnull(STL_DEFAULT_NUMBER,0))
	from dbo.GetStsPspObj (@p_PSP, @p_INOID)
	where STS_PARENT = @p_STS)s


	set @v_js = @v_js + '
});
</script>
'

	return @v_js
end
GO