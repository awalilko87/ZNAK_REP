SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetUserAssetFilterCount] (
	@p_UserID nvarchar(30)
)
returns int
 
as
begin 
 
	declare @count int
	
	/*select    
		@count = COUNT(*)
	from ASTOBJv (nolock) 
		join ASTOBJ_FILTER filter (nolock) on filter.OBJ_USERID = @p_UserID--'SA'
	where
		
		(ASTOBJv.OBJ_CODE like '%' + filter.OBJ_CODE + '%' or filter.OBJ_CODE is null) 
		and (ASTOBJv.OBJ_DESC like '%' + filter.OBJ_DESC + '%' or filter.OBJ_DESC is null) 
		and (ASTOBJv.OBJ_GROUP = filter.OBJ_GROUP or filter.OBJ_GROUP is null) 
		and (ASTOBJv.OBJ_STATION = filter.OBJ_STATION or filter.OBJ_STATION is null) 
		and (ASTOBJv.OBJ_TYPE = filter.OBJ_TYPE or filter.OBJ_TYPE is null)  
		and (ASTOBJv.OBJ_PSP like '%' + filter.OBJ_PSP + '%' or filter.OBJ_PSP is null) 
		and (ASTOBJv.OBJ_ASSET like '%' + filter.OBJ_ASSET + '%' or filter.OBJ_ASSET is null)  
		*/

	select @count = count(distinct OBJID) from [dbo].[GetUserAssetFilter](@p_UserID)
		 	
	return @count
	
end 
GO