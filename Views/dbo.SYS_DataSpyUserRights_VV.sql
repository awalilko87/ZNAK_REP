SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[SYS_DataSpyUserRights_VV]
WITH ENCRYPTION
AS 
	SELECT    
      Coalesce(ur.DS_PRIV,gr.DS_PRIV,1) as DS_PRIV,
      Coalesce(ur.DS_PUB,gr.DS_PUB,0) as DS_PUB ,
      Coalesce(ur.DS_GR,gr.DS_GR,0) as DS_GR, 
      Coalesce(ur.DS_SITE,gr.DS_SITE,0) as DS_SITE,
      Coalesce(ur.DS_DEP,gr.DS_DEP,0) as DS_DEP,
      u.UserID as USERID
    FROM dbo.SYUsers u
    left join VS_DataSpyGroupRights gr  on gr.UserGroupID = u.UserGroupID
    left join VS_DataSpyUserRights ur  on ur.UserID = u.UserID

GO