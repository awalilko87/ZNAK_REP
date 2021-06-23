SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--select dbo.VS_EncodeBase64_Null (null)

CREATE function [dbo].[VS_EncodeBase64_Null]
(
  @plain_text varchar(6000)
)
RETURNS 
          varchar(8000)
AS BEGIN
--local variables
DECLARE
  @output            varchar(8000)

	if @plain_text is not null
		select @output = dbo.VS_EncodeBase64 (@plain_text)

--return the result
RETURN @output
END


GO