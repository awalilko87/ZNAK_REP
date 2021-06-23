SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_CHECK_KEYS](
@p_KEY nvarchar(max),
@p_OPER nvarchar(1)
)
as
begin
	if isnull(@p_KEY,'') = ''
	begin
		raiserror('Nie wybrano żadnego rekordu', 16, 1)
		return 1
	end
	
	if @p_OPER = '+' and exists (select 1 from dbo.OBJASSET where OBA_ASTID in (select String from dbo.VS_Split3(@p_KEY, ';') where String <> ''))
	begin
		raiserror('Należy wybrać rekordy bez przypisanego składnika ZMT', 16, 1)
		return 
	end
end
GO