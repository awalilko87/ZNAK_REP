SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetImportColumnName] (@p_ROWID int, @p_PARAMETERNAME nvarchar(255))
returns nvarchar(255)
as	
begin
	declare @output nvarchar(255)
		
	select 
		@output = Col.value('local-name(.)', 'varchar(max)')  
	from (select *
			from STN_ADD_OBJ_EXCEL
			where rowid = @p_ROWID
			for xml path(''), type) as T(XMLCol)
		cross apply 
		T.XMLCol.nodes('*') as n(Col) 
	where Col.value('.', 'varchar(255)') = @p_PARAMETERNAME
	
	return @output

end
GO