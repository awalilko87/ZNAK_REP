SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[INSTRUKCJA_GetPDF](@p_INS nvarchar(30))
returns nvarchar(max)
as
begin
	declare @v_HTML nvarchar(max)

	select 
		@v_HTML = '<embed src="/Handlers/File/Id/GA/'+dbo.VS_EncodeBase64(INS_FILEID2)+ '" width="100%" height="540">'
	from dbo.INSTRUKCJE
	where INS_CODE = @p_INS

	return @v_HTML
end
GO