﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormGroups_GetSorted]
WITH ENCRYPTION
AS

    SELECT
        GroupID, ParentID, GroupDesc
    FROM VS_FormGroups
	ORDER BY ISNULL(GroupDesc, GroupID)
GO