SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_GetByID](
    @DataSpyID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DataSpyID, FormID, UserID, ParentID, SpyName,
        OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
        FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
        IsTemp, Created, FilterTypeName, FilterValueTwo, BrackedLeftCount ,BrackedRightCount
    FROM VS_DataSpy
         WHERE DataSpyID LIKE @DataSpyID
GO