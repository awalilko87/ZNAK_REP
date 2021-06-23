SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_GetByUserIDAndFormID](
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30),   
	@LangID nvarchar(30), 
    @_SessionTimeout int = null
)
WITH ENCRYPTION
AS
	DECLARE @group nvarchar(50)
	DECLARE @department nvarchar(50)
	DECLARE @site nvarchar(20)
	
	IF EXISTS (select UserID from SYUsers where UserID =  @UserID)
	BEGIN
		SELECT 
		@group = UserGroupID,
		@department = DepartmentID,
		@site = SiteID 
		FROM SYUsers 
		WHERE UserID = @UserID
	END
	ELSE 
	BEGIN
	   SELECT @group = USR_GROUP,@department = '',@site = '' FROM R5USERS WHERE USR_CODE = @UserID
	END
	
	IF(@_SessionTimeout is not null) BEGIN
		DELETE FROM VS_DataSpy 
		WHERE FormID = @FormID 
		AND UserID = @UserID 
		AND IsTemp = 1 
		AND Created <= DATEADD(MINUTE,-2 * @_SessionTimeout, getdate()) 
	END
	IF EXISTS (select UserID from SYUsers where UserID =  @UserID)
	BEGIN
		SELECT
			DataSpyID, FormID, UserID, ParentID, SpyName,
			OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
			FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
			IsTemp, Created, FilterTypeName, FilterValueTwo, BrackedLeftCount, BrackedRightCount
		FROM VS_DataSpy ds
		WHERE FormID = @FormID 
			  AND (UserID = @UserID 
				   OR IsPublic = 1 
				   OR (IsGroup = 1 AND @group = (SELECT UserGroupID FROM SYUsers u WHERE u.UserID = ds.UserID ))
				   OR (IsSite = 1 AND @site = (SELECT SiteID FROM SYUsers u WHERE u.UserID = ds.UserID ))
				   OR (IsDepartment = 1 AND @department = (SELECT DepartmentID FROM SYUsers u WHERE u.UserID = ds.UserID ))
				   OR (EXISTS (SELECT * FROM dbo.VS_DataSpyUsers dsu WHERE dsu.DataSpyID = ds.DataSpyID AND UserOrGroupID = @UserID AND [Type] = 'U'))
				   OR (EXISTS (SELECT * FROM dbo.VS_DataSpyUsers dsu WHERE dsu.DataSpyID = ds.DataSpyID AND UserOrGroupID = @group AND [Type] = 'G')))
		ORDER BY SpyName
	END
	ELSE 
	BEGIN
		SELECT
			DataSpyID, FormID, UserID, ParentID, SpyName,
			OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
			FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
			IsTemp, Created, FilterTypeName, FilterValueTwo, BrackedLeftCount, BrackedRightCount
		FROM VS_DataSpy ds
		WHERE FormID = @FormID 
			  AND (UserID = @UserID 
				   OR IsPublic = 1 
				   OR (IsGroup = 1 AND @group = (SELECT USR_GROUP FROM R5USERS u WHERE u.USR_CODE COLLATE DATABASE_DEFAULT = ds.UserID COLLATE DATABASE_DEFAULT))
				   OR (IsSite = 1 AND @site = '')
				   OR (IsDepartment = 1 AND @department = '')
				   OR (EXISTS (SELECT * FROM dbo.VS_DataSpyUsers dsu WHERE dsu.DataSpyID = ds.DataSpyID AND UserOrGroupID = @UserID AND [Type] = 'U'))
				   OR (EXISTS (SELECT * FROM dbo.VS_DataSpyUsers dsu WHERE dsu.DataSpyID = ds.DataSpyID AND UserOrGroupID = @group AND [Type] = 'G')))
		ORDER BY SpyName
	END
			
GO