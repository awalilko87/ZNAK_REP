SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_Update](
    @DataSpyID nvarchar(50) OUT,
    @FormID nvarchar(50),
    @UserID nvarchar(30),
    @ParentID nvarchar(50),
    @SpyName nvarchar(100),
    @OutputWhere nvarchar(max),
	@CustomWhereOperator nvarchar(3),	
	@CustomWhere nvarchar(max),
    @BrackedLeft bit,
    @BrackedRight bit,
    @FilterField nvarchar(250),
    @FilterType int,
    @FilterValue nvarchar(500),
    @FilterOperator nvarchar(3),
    @SpyOrder int,
    @IsPublic bit,
    @IsPrivate bit,
    @IsGroup bit, 
    @IsSite bit, 
    @IsDepartment bit, 
    @CustOrder nvarchar(150),
    @_USERID_ nvarchar(30) = null,
    @IsTemp bit,
    @Created datetime,
	@FilterTypeName nvarchar(30),
	@FilterValueTwo nvarchar(500),
	@BrackedLeftCount int,
	@BrackedRightCount int
)
WITH ENCRYPTION
AS

IF @DataSpyID is null
    SET @DataSpyID = NewID()
IF @DataSpyID =''
    SET @DataSpyID = NewID()

IF NOT EXISTS (SELECT * FROM VS_DataSpy WHERE DataSpyID = @DataSpyID)
BEGIN
    INSERT INTO VS_DataSpy(
        DataSpyID, FormID, UserID, ParentID, SpyName,
        OutputWhere, CustomWhereOperator, CustomWhere, BrackedLeft, BrackedRight, FilterField, FilterType,
        FilterValue, FilterOperator, SpyOrder, IsPublic, IsPrivate, IsGroup, IsSite, IsDepartment, CustOrder,
        IsTemp, Created, FilterTypeName, FilterValueTwo ,BrackedLeftCount,BrackedRightCount)
    VALUES (
        @DataSpyID, @FormID, @UserID, @ParentID, @SpyName,
        @OutputWhere, @CustomWhereOperator, @CustomWhere, @BrackedLeft, @BrackedRight, @FilterField, @FilterType,
        @FilterValue, @FilterOperator, @SpyOrder, @IsPublic, @IsPrivate, @IsGroup, @IsSite, @IsDepartment, @CustOrder,
        @IsTemp, @Created, @FilterTypeName, @FilterValueTwo,@BrackedLeftCount,@BrackedRightCount)
END
ELSE
BEGIN
    UPDATE VS_DataSpy 
    SET
        FormID = @FormID, UserID = @UserID, ParentID = @ParentID, SpyName = @SpyName, OutputWhere = @OutputWhere, CustomWhereOperator = @CustomWhereOperator, CustomWhere = @CustomWhere,
        BrackedLeft = @BrackedLeft, BrackedRight = @BrackedRight, FilterField = @FilterField, FilterType = @FilterType, FilterValue = @FilterValue,
        FilterOperator = @FilterOperator, SpyOrder = @SpyOrder, IsPublic = @IsPublic, IsPrivate = @IsPrivate, IsGroup = @IsGroup, IsSite = @IsSite, IsDepartment = @IsDepartment, CustOrder = @CustOrder,
        IsTemp = @IsTemp, Created = @Created, FilterTypeName = @FilterTypeName, FilterValueTwo = @FilterValueTwo, @BrackedLeftCount = BrackedLeftCount,@BrackedRightCount = BrackedRightCount
    WHERE DataSpyID = @DataSpyID
END
GO