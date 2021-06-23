SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormFields_GetACSql](
    @FieldID nvarchar(50),
    @FormID nvarchar(50),
	@ACSql nvarchar(4000) OUT
)
WITH ENCRYPTION
AS

    SELECT
		@ACSql = ACSql
    FROM VS_FormFields
        WHERE FormID = @FormID AND FieldID = @FieldID
GO