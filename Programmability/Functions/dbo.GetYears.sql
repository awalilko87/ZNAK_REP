SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetYears] (@p_backward int, @p_forward int)
returns @t table (t_year int)
as
begin
	declare @v_currentyear int
		, @v_year int
	
	select @v_currentyear = year(GETDATE())
	
	while @p_backward  > - @p_forward
	begin 
	
		insert into @t (t_year)
		select  @v_currentyear - @p_backward
	
		select @p_backward = @p_backward - 1
		
	end
	 
	return 
end


--select t_year from dbo.GetYears (10,10)
GO