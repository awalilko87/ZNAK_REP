SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_TLines_Update](
    @TLineID nvarchar(50) OUT,
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

IF @TLineID is null
    SET @TLineID = NewID()
IF @TLineID =''
    SET @TLineID = NewID()

IF NOT EXISTS (SELECT * FROM VS_TLines WHERE TLineID = @TLineID)
BEGIN
    INSERT INTO VS_TLines(
        TLineID, FormID, Caption, FieldGroup, FieldStart,
        FieldEnd, FieldValue, FieldValueType, UnitTL1, UnitTL2,
        UnitTL3, AllowResizeH, ShowGroupField, CustomColor, BGColor,
        BGColorStart, BGColorEnd /*, _USERID_ */ )
    VALUES (
        @TLineID, @FormID, @Caption, @FieldGroup, @FieldStart,
        @FieldEnd, @FieldValue, @FieldValueType, @UnitTL1, @UnitTL2,
        @UnitTL3, @AllowResizeH, @ShowGroupField, @CustomColor, @BGColor,
        @BGColorStart, @BGColorEnd /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_TLines SET
        FormID = @FormID, Caption = @Caption, FieldGroup = @FieldGroup, FieldStart = @FieldStart, FieldEnd = @FieldEnd,
        FieldValue = @FieldValue, FieldValueType = @FieldValueType, UnitTL1 = @UnitTL1, UnitTL2 = @UnitTL2, UnitTL3 = @UnitTL3,
        AllowResizeH = @AllowResizeH, ShowGroupField = @ShowGroupField, CustomColor = @CustomColor, BGColor = @BGColor, BGColorStart = @BGColorStart,
        BGColorEnd = @BGColorEnd /* , _USERID_ = @_USERID_ */ 
        WHERE TLineID = @TLineID
END
GO