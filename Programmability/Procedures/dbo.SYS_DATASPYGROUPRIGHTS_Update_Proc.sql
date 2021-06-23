SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SYS_DATASPYGROUPRIGHTS_Update_Proc](   
    @GroupID nvarchar(20),
    @DS_PRIV bit = NULL,   
    @DS_PUB bit = NULL,
    @DS_GR bit = NULL,
    @DS_SITE bit = NULL,  
    @DS_DEP bit = NULL
     
)
WITH ENCRYPTION
AS
IF NOT EXISTS (SELECT * FROM VS_DataSpyGroupRights WHERE [UserGroupID] = @GroupID)
BEGIN
INSERT INTO VS_DataSpyGroupRights(
    [DS_DEP], [DS_GR],[DS_PRIV], [DS_PUB], [DS_SITE], [UserGroupID])
VALUES (
    @DS_DEP, @DS_GR, @DS_PRIV, @DS_PUB, @DS_SITE, @GroupID)
END 
ELSE 
BEGIN 
UPDATE VS_DataSpyGroupRights SET
    [DS_DEP] = @DS_DEP, [DS_GR] = @DS_GR, [DS_PRIV] = @DS_PRIV, [DS_PUB] = @DS_PUB, [DS_SITE] = @DS_SITE
    WHERE [UserGroupID] = @GroupID
END 
GO