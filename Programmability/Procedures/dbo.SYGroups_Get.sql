﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYGroups_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        GroupID, GroupName, Typ, Typ2 /*, _USERID_ */ 
    FROM SYGroups
	ORDER BY GroupName
GO