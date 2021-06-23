SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DataSpyID, FormID, UserID, ParentID, SpyName,
        OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
        FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup,IsSite, IsDepartment, IsSite, IsDepartment, CustOrder,
        IsTemp, Created, FilterTypeName, FilterValueTwo ,BrackedLeftCount ,BrackedRightCount /*, _USERID_ */ 
    FROM VS_DataSpy
GO