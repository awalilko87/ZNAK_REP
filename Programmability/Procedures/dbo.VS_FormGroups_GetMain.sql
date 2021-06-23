SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_GetMain]
WITH ENCRYPTION
AS

    SELECT
        GroupID, ParentID, GroupDesc 
    FROM VS_FormGroups
         WHERE ParentID is null
	ORDER BY GroupID
GO