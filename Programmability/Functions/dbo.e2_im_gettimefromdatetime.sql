SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE function [dbo].[e2_im_gettimefromdatetime] (@p_date datetime )
returns varchar(10)
as
begin
declare @v_returns varchar(10)
select @v_returns = replicate('0',2-len(convert(varchar,datepart(hour,@p_date))))+convert(varchar,datepart(hour,@p_date))+':'+replicate('0',2-len(convert(varchar,datepart(minute,@p_date))))+convert(varchar,datepart(minute,@p_date))--+':'+replicate('0',2-len(convert(varchar,datepart(second,@p_date))))+convert(varchar,datepart(second,@p_date)) 
return @v_returns
end
GO