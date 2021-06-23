SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangControls_Remove](
    @ControlID nvarchar(50),
    @FormID nvarchar(50),
    @LangID nvarchar(10),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_LangControls
            WHERE ControlID = @ControlID AND FormID = @FormID AND LangID = @LangID
GO