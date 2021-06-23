SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetSTNTYPE](@p_STNID int)
returns nvarchar(30)
as
begin
	declare @v_STNTYPE nvarchar(30)

	select @v_STNTYPE = STN_TYPE from dbo.STATION where STN_ROWID = @p_STNID

	return @v_STNTYPE
end
GO