SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_Search](
    @UserID nvarchar(30),
    @FormID nvarchar(50),
    @FieldID nvarchar(50),
    @Rights nvarchar(4000),
    @Cond nvarchar(100),
    @rReadOnly nvarchar(4000),
    @rVisible nvarchar(4000),
    @rRequire nvarchar(4000),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, FormID, FieldID, Rights, Cond,
        rReadOnly, rVisible, rRequire /*, _USERID_ */ 
    FROM VS_Rights
            /* WHERE Rights = @Rights AND rReadOnly = @rReadOnly AND rVisible = @rVisible AND rRequire = @rRequire /*  AND _USERID_ = @_USERID_ */ */
GO