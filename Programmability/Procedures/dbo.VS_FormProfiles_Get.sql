SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormProfiles_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, UserID, DefaultDataSpy /*, _USERID_ */ 
    FROM VS_FormProfiles
GO