SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetUserSP](@p_UserID nvarchar(30))
returns int
as
begin
	declare @v_SPID int
	
	select @v_SPID = User_STNID from dbo.SYUsers where UserID = @p_UserID
	
	return @v_SPID
end
GO