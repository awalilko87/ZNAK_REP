SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabFilters_GetBy](
    @TabGroupID nvarchar(50),
	@TabID nvarchar(50),
    @FormID nvarchar(50), 
    @GroupID nvarchar(20)
)
WITH ENCRYPTION
AS
    SELECT FilterID, FilterName, TabGroupID, TabID, FormID, GroupID, UserID, IsActive, SqlWhere, FilterField, FilterType, FilterValue
    FROM VS_TabFilters(NOLOCK)
    WHERE TabGroupID = @TabGroupID AND TabID = @TabID AND FormID = @FormID AND GroupID = @GroupID
GO