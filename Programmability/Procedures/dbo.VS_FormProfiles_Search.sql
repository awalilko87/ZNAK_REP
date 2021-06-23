SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_FormProfiles_Search](
    @FormID nvarchar(50),
    @UserID nvarchar(30),
    @DefaultDataSpy nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FormID, UserID, DefaultDataSpy 
    FROM VS_FormProfiles
            /* WHERE DefaultDataSpy = @DefaultDataSpy /*  AND _USERID_ = @_USERID_ */ */
GO