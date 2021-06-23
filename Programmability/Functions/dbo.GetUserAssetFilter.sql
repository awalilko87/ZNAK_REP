SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetUserAssetFilter] (
	@p_UserID nvarchar(30)
)
returns  table 
--(
--	OBJID int
--)
as
return
	select    
		OBJID = o.OBJ_ROWID 
	--from ASTOBJv (nolock) 
	from dbo.OBJ o
	inner join ASTOBJ_FILTER filter (nolock) on filter.OBJ_USERID = @p_UserID
	inner join dbo.OBJGROUP on OBG_ROWID = OBJ_GROUPID
	left join dbo.OBJASSET on OBA_OBJID = OBJ_ROWID
	left join dbo.ASSET on AST_ROWID = OBA_ASTID
	left join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID
	left join dbo.STATION on STN_ROWID = OSA_STNID
	left join dbo.PSP on PSP_ROWID = OBJ_PSPID
	where isnull(o.OBJ_NOTUSED,0) = 0
		
		and (o.OBJ_CODE like '%' + filter.OBJ_CODE + '%' or filter.OBJ_CODE is null) 
		and (o.OBJ_DESC like '%' + filter.OBJ_DESC + '%' or filter.OBJ_DESC is null) 
		and (OBG_CODE = filter.OBJ_GROUP or filter.OBJ_GROUP is null) 
		and (STN_CODE = filter.OBJ_STATION or filter.OBJ_STATION is null) 
		and (o.OBJ_TYPE = filter.OBJ_TYPE or filter.OBJ_TYPE is null)  
		and (PSP_CODE like '%' + filter.OBJ_PSP + '%' or filter.OBJ_PSP is null)  
		and (AST_CODE like '%' + filter.OBJ_ASSET + '%' or filter.OBJ_ASSET is null)  
		
		and filter.OBJ_NOTUSED = 0
	
	
	
GO