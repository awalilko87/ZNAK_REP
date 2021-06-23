SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[DS_GetPart]
(
	@v_Part nvarchar(max)
)
RETURNS 
@ending table 
(
	endtext nvarchar(max)
)
AS
BEGIN
 
	insert into @ending (endtext)
	select right(MenuToolTip, len(MenuToolTip) - CHARINDEX(@v_Part, MenuToolTip) - 3) from SYMenus (nolock) where MenuToolTip like '%'+ @v_Part + '%'

	update @ending set endtext = ', ''' + case when CHARINDEX('&', endtext) > 0 then LEFT(endtext,CHARINDEX('&', endtext)-1) else endtext end + ''''
	 
	return
end

--select * from DS_GetPart ('FID')
GO