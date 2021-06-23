SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TLines_GetByID](
    @TLineID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        TLineID, FormID, Caption, FieldGroup, FieldStart,
        FieldEnd, FieldValue, FieldValueType, UnitTL1, UnitTL2,
        UnitTL3, AllowResizeH, ShowGroupField, CustomColor, BGColor,
        BGColorStart, BGColorEnd /*, _USERID_ */ 
    FROM VS_TLines
         WHERE TLineID LIKE @TLineID
GO