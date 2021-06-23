SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[GetPSP_CODE]   
(  
  @p_Code nvarchar(20) 
)  
returns   
nvarchar(10)  
  
as  
begin  
  declare @code nvarchar(20)
  declare @code2 nvarchar(20)

	select @code = SUBSTRING(SUBSTRING(@p_Code, CHARINDEX('/', @p_Code, 1)+1, len(@p_Code)), CHARINDEX('/', SUBSTRING(@p_Code, CHARINDEX('/', @p_Code, 1)+1, len(@p_Code))), len(@p_Code))

	set @code2 = SUBSTRING(@code, 2, len(@code)-1)

  return @code2
end
GO