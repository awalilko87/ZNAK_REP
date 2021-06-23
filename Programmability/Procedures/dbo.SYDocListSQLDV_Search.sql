SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLDV_Search](
    @DocID nvarchar(50),
    @FieldName nvarchar(50),
    @FieldValue nvarchar(50),
    @Display nvarchar(50),
    @Remarks nvarchar(100),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DocID, FieldName, FieldValue, Display, Remarks /*, _USERID_ */ 
    FROM SYDocListSQLDV
            /* WHERE Display = @Display AND Remarks = @Remarks /*  AND _USERID_ = @_USERID_ */ */
GO