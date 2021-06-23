SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormProfiles_GetByID](
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, UserID, DefaultDataSpy /*, _USERID_ */ 
    FROM VS_FormProfiles
         WHERE FormID LIKE @FormID AND UserID LIKE @UserID
GO