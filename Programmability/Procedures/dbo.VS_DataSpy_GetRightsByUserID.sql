SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[VS_DataSpy_GetRightsByUserID](
@_USERID nvarchar(30) = null
)
WITH ENCRYPTION
AS
IF EXISTS (select UserID from SYUsers where UserID =  @_USERID)
BEGIN
    SELECT     
		cast(Coalesce(ur.DS_PRIV,gr.DS_PRIV,1) as bit) as DS_PRIV,	  
		cast(Coalesce(ur.DS_PUB,gr.DS_PUB,0) as bit) as DS_PUB,           		
		cast(Coalesce(ur.DS_GR,gr.DS_GR,0) as bit)as DS_GR,       
		cast(Coalesce(ur.DS_SITE,gr.DS_SITE,0) as bit) as DS_SITE,       
		cast(Coalesce(ur.DS_DEP,gr.DS_DEP,0) as bit) as DS_DEP 
    FROM SYUsers u    
      LEFT JOIN VS_DataSpyUserRights ur on u.UserID = ur.UserID
      LEFT JOIN VS_DataSpyGroupRights gr on u.UserGroupID = gr.UserGroupID
    WHERE 
      u.UserID = @_USERID         
END
ELSE BEGIN
 SELECT     
		cast(Coalesce(ur.DS_PRIV,gr.DS_PRIV,1) as bit) as DS_PRIV,	  
		cast(Coalesce(ur.DS_PUB,gr.DS_PUB,0) as bit) as DS_PUB,           		
		cast(Coalesce(ur.DS_GR,gr.DS_GR,0) as bit)as DS_GR,       
		cast(Coalesce(ur.DS_SITE,gr.DS_SITE,0) as bit) as DS_SITE,       
		cast(Coalesce(ur.DS_DEP,gr.DS_DEP,0) as bit) as DS_DEP 
    FROM R5USERS u    
      LEFT JOIN VS_DataSpyUserRights ur on u.USR_CODE COLLATE DATABASE_DEFAULT = ur.UserID COLLATE DATABASE_DEFAULT
      LEFT JOIN VS_DataSpyGroupRights gr on u.USR_GROUP COLLATE DATABASE_DEFAULT = gr.UserGroupID COLLATE DATABASE_DEFAULT
    WHERE 
      u.USR_CODE = @_USERID    
END      
GO