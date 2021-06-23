SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[e2_im_getdatefromdatetime] (@p_date datetime )
returns varchar(10)
as
begin
declare @v_returns varchar(10)
select @v_returns = convert(varchar,year(@p_date))+'-'+replicate('0',2-len(convert(varchar,month(@p_date))))+convert(varchar,month(@p_date))+'-'+replicate('0',2-len(convert(varchar,day(@p_date))))+convert(varchar,day(@p_date))
return @v_returns
end

GO