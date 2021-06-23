SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
--select * from dbo.GetMonths('SA')
CREATE function [dbo].[GetMonths](@p_UserID nvarchar(30))
returns @months table (MonthCode int, MonthDesc nvarchar(50))
as
begin
	declare @v_LangID nvarchar(10)
	select @v_LangID = [LangID] from dbo.SYUsers (nolock) where UserID = @p_UserID 
	
	if isnull(@v_LangID,'PL') = 'PL'
	begin
		insert into @months
			select 1, 'Styczeń' 
			union 
			select 2,'Luty' 
			union 
			select 3,'Marzec' 
			union 
			select 4,'Kwiecień' 
			union 
			select 5,'Maj' 
			union 
			select 6,'Czerwiec' 
			union 
			select 7,'Lipiec' 
			union 
			select 8,'Sierpień' 
			union 
			select 9,'Wrzesień' 
			union 
			select 10,'Październik' 
			union 
			select 11,'Listopad' 
			union 
			select 12,'Grudzień'
	end
	else
	begin
		insert into @months
			select 1, 'January' 
			union 
			select 2, 'February' 
			union 
			select 3, 'March' 
			union 
			select 4, 'April' 
			union 
			select 5, 'May' 
			union 
			select 6, 'June' 
			union 
			select 7, 'July' 
			union 
			select 8, 'August' 
			union 
			select 9, 'September' 
			union 
			select 10, 'October' 
			union 
			select 11, 'November' 
			union 
			select 12, 'December' 
		
	end

	return
end

GO