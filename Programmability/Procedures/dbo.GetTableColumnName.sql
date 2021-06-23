SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetTableColumnName] (@p_ROWID int, @p_PARAMETERNAME nvarchar(255), @p_TABLENAME nvarchar(255), @p_COLUMNNAME nvarchar(255) OUTPUT)
as	
begin
 
	declare @SQL nvarchar(max)
	 
	select @SQL = 'select top 1 
		@p_COLUMNNAME = Col.value(''local-name(.)'', ''varchar(max)'')  
	from (select *
			from '+ @p_TABLENAME + '
			where rowid = '+ cast(@p_ROWID as nvarchar(10)) + '
			for xml path(''''), type) as T(XMLCol)
		cross apply 
		T.XMLCol.nodes(''*'') as n(Col) 
	where Col.value(''.'', ''varchar(255)'') = N''' + @p_PARAMETERNAME + ''''
	
	exec sp_executesql 
		@query = @SQL,
		@params = N'@p_COLUMNNAME nvarchar(max) OUTPUT',
		@p_COLUMNNAME = @p_COLUMNNAME OUTPUT 
		  
	return 0

end
 
--declare @p_COLUM nvarchar(max)
--exec dbo.[GetTableColumnName] 66, N'Kod szablonu', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @p_COLUM OUTPUT
--select @p_COLUM

			 
GO