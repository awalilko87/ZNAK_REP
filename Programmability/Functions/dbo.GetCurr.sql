SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[GetCurr] 
(	
	-- Add the parameters for the function here
	@UserID nvarchar(20)
)
RETURNS 
@t TABLE
([CODE] nvarchar(30))

AS
BEGIN
	--declare @TYPE_MODULE nvarchar(30)
	--select @TYPE_MODULE = SITEID from dbo.SYUsers  where UserID = @UserID
	insert into @t ([CODE])
	select CUR_CODE
	from dbo.CURR
	--where CUR_ORG = @TYPE_MODULE--TYP_ENTITY = @TYP_ENTITY  and TYP_MODULE  = @TYPE_MODULE

	RETURN 
END



GO