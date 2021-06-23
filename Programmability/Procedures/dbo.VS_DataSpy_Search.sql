SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_Search](
    @DataSpyID nvarchar(50) = null,
    @FormID nvarchar(50) = null,
    @UserID nvarchar(30) = null,
    @ParentID nvarchar(50) = null,
    @SpyName nvarchar(100) = null,
    @OutputWhere nvarchar(max) = null,
	@CustomWhereOperator nvarchar(3) = null,	
	@CustomWhere nvarchar(max) = null,
    @BrackedLeft bit = null,
    @BrackedRight bit = null,
    @FilterField nvarchar(250) = null,
    @FilterType int = null,
    @FilterValue nvarchar(500) = null,
    @FilterOperator nvarchar(3) = null,
    @SpyOrder int = null,
    @IsPublic bit = null,
    @IsPrivate bit = null,
    @IsSite bit = null, 
    @IsDepartment bit = null, 
    @IsGroup bit = null,
    @CustOrder nvarchar(150) = null,
    @_USERID_ nvarchar(30) = null,
    @IsTemp bit = null,
    @Created datetime = null,
	@FilterTypeName nvarchar(30) = null,
	@FilterValueTwo nvarchar(500) = null,
	@BrackedLeftCount int = null,
	@BrackedRightCount int = null
)
WITH ENCRYPTION
AS
    SELECT
        DataSpyID, FormID, UserID, ParentID, SpyName,
        OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
        FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
        IsTemp, Created, FilterTypeName, FilterValueTwo, BrackedLeftCount, BrackedRightCount
    FROM VS_DataSpy
    WHERE (@IsTemp is not null and IsTemp = @IsTemp)
    AND (@Created is not null and Created = @Created)
GO