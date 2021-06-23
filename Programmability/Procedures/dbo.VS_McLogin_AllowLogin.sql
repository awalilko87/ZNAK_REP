SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[VS_McLogin_AllowLogin](
@p_idPersonGr int,
@p_StationNumber int
)
as
begin
	if @p_idPersonGr in (1, 2)
		select 1
	else
		select 0
end
GO