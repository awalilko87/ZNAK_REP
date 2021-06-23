SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_CreateLink]
(
	@URL nvarchar(4000),
	@Where nvarchar(4000),
	@LoadMaster bit = 0
)
RETURNS nvarchar(4000)
AS
BEGIN
DECLARE @ret nvarchar(max)
	SET	@ret='Link.aspx?B=' + dbo.VS_EncodeBase64(@URL + case when @LoadMaster=1 then '&LP=1' else '' end + case when len(@Where)>0 then '&W=' else '' end + @Where)
	return (@ret)
END
GO