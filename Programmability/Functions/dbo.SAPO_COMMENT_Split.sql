SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[SAPO_COMMENT_Split](@p_TEXT nvarchar(max), @p_LENGTH int)
returns table
as return
with d as (
	select 1 ind, left(@p_TEXT, @p_LENGTH) TXT
	union all
	select ind + @p_LENGTH, substring(@p_TEXT, ind + @p_LENGTH, @p_LENGTH) from d where ind + @p_LENGTH < len(@p_TEXT)
	)
select TXT = replace(TXT,char(150),char(45)) from d
GO