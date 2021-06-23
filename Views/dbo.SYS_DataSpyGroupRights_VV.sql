SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[SYS_DataSpyGroupRights_VV]
WITH ENCRYPTION
AS 
	SELECT    
      isNull(gr.DS_PRIV,1) as DS_PRIV,
      isNull(gr.DS_PUB,0) as DS_PUB ,
      isNull(gr.DS_GR,0) as DS_GR, 
      isNull(gr.DS_SITE,0) as DS_SITE,
      isNull(gr.DS_DEP,0) as DS_DEP,
      g.GroupID as USER_GROUP_ID
    FROM SYGroups g
    left join VS_DataSpyGroupRights gr  on gr.UserGroupID = g.GroupID

GO