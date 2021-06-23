SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_GetByUserIDAndParentID](
    @ParentID nvarchar(50) = '%',
    @UserID nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
	DECLARE @group nvarchar(50)
	SELECT @group = UserGroupID FROM SYUsers WHERE UserID = @UserID
    SELECT
        DataSpyID, FormID, UserID, ParentID, SpyName,
        OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
        FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
        IsTemp, Created, FilterTypeName, FilterValueTwo, BrackedLeftCount, BrackedRightCount
    FROM VS_DataSpy ds
         WHERE ParentID = @ParentID AND (UserID = @UserID OR IsPublic = 1 OR
          (IsGroup = 1 AND @group = (SELECT UserGroupID FROM SYUsers u WHERE u.UserID = ds.UserID )))
	ORDER BY SpyOrder
GO