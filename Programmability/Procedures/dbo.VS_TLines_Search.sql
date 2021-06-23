SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TLines_Search](
    @TLineID nvarchar(50),
    @FormID nvarchar(50),
    @Caption nvarchar(150),
    @FieldGroup nvarchar(50),
    @FieldStart nvarchar(50),
    @FieldEnd nvarchar(50),
    @FieldValue nvarchar(50),
    @FieldValueType nvarchar(3),
    @UnitTL1 nvarchar(10),
    @UnitTL2 nvarchar(10),
    @UnitTL3 nvarchar(10),
    @AllowResizeH bit,
    @ShowGroupField bit,
    @CustomColor bit,
    @BGColor nvarchar(20),
    @BGColorStart nvarchar(20),
    @BGColorEnd nvarchar(20),
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
            /* WHERE FormID = @FormID AND Caption = @Caption AND FieldGroup = @FieldGroup AND FieldStart = @FieldStart AND FieldEnd = @FieldEnd AND
            FieldValue = @FieldValue AND FieldValueType = @FieldValueType AND UnitTL1 = @UnitTL1 AND UnitTL2 = @UnitTL2 AND UnitTL3 = @UnitTL3 AND
            AllowResizeH = @AllowResizeH AND ShowGroupField = @ShowGroupField AND CustomColor = @CustomColor AND BGColor = @BGColor AND BGColorStart = @BGColorStart AND
            BGColorEnd = @BGColorEnd /*  AND _USERID_ = @_USERID_ */ */
GO