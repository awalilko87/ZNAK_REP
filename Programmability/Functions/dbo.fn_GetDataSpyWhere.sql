SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Cesbart>
-- Create date: <2014-04-11>
-- Description:	<Function return DataSpy where>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetDataSpyWhere]
(	
	@p_DataSpyID nvarchar(100)
)
returns nvarchar(max)
AS
BEGIN
declare @ret_where nvarchar(max)
	SELECT 
	@ret_where = (
	CASE 
	 WHEN isnull(OutputWhere,'') <> '' AND isnull(CustomWhere,'') <> '' AND isnull(CustomWhereOperator,'') <> '' THEN  '('+OutputWhere +') '+ CustomWhereOperator+' ('+CustomWhere+')' 
	 WHEN isnull(OutputWhere,'') <> '' AND isnull(CustomWhere,'') = '' THEN  OutputWhere 
	 WHEN isnull(OutputWhere,'') = '' AND isnull(CustomWhere,'') <> '' THEN  CustomWhere
	 ELSE ''
	END)
	 FROM dbo.VS_DataSpy WHERE DataSpyID = @p_DataSpyID 
	
	return @ret_where 
END

GO