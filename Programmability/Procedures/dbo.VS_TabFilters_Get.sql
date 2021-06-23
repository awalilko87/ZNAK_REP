SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabFilters_Get]
WITH ENCRYPTION
AS
    SELECT FilterID, FilterName, TabGroupID, TabID, FormID, GroupID, UserID, IsActive, SqlWhere, FilterField, FilterType, FilterValue
    FROM VS_TabFilters(NOLOCK)
GO