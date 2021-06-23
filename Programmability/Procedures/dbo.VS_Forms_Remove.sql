SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Forms_Remove](
    @FormID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_Forms
            WHERE FormID = @FormID
    DELETE
        FROM VS_FormFields
            WHERE FormID = @FormID
GO