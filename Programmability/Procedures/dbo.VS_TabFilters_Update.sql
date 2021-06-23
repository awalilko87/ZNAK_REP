SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TabFilters_Update](
		@FilterID nvarchar(50) = null,
		@FilterName nvarchar(50),
		@TabGroupID nvarchar(50),
		@TabID nvarchar(50),
        @FormID nvarchar(50), 
        @GroupID nvarchar(20), 
        @UserID nvarchar(30), 
        @IsActive bit, 
        @SqlWhere nvarchar(max),
        @FilterField nvarchar(250), 
        @FilterType int, 
        @FilterValue nvarchar(500)
      )
WITH ENCRYPTION
AS
	IF (@FilterID IS NULL)
	BEGIN
			IF @IsActive = 1
			BEGIN
				UPDATE VS_TabFilters SET IsActive = 0
				WHERE TabGroupID = @TabGroupID AND TabID = @TabID AND FormID = @FormID AND GroupID = @GroupID
			END
			INSERT INTO VS_TabFilters(FilterName, TabGroupID, TabID, FormID, GroupID, UserID, IsActive, SqlWhere, FilterField, FilterType, FilterValue)
			VALUES(@FilterName, @TabGroupID, @TabID, @FormID, @GroupID, @UserID, @IsActive, @SqlWhere, @FilterField, @FilterType, @FilterValue)
	END
	ELSE
	BEGIN
		IF @IsActive = 1
		BEGIN
			UPDATE VS_TabFilters SET IsActive = 0
			WHERE TabGroupID = @TabGroupID AND TabID = @TabID AND FormID = @FormID AND GroupID = @GroupID
		END
		UPDATE VS_TabFilters SET FilterName = @FilterName, TabGroupID = @TabGroupID, TabID = @TabID, FormID = @FormID, 
			GroupID = @GroupID, UserID = @UserID, IsActive = @IsActive, SqlWhere = @SqlWhere, FilterField = @FilterField, 
			FilterType = @FilterType, FilterValue = @FilterValue
		WHERE FilterID = @FilterID
	END
GO