SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_Get_int_ByID](
    @KeyCode nvarchar(50) = '%',
    @ModuleCode nvarchar(20) = '%',
	@Val int OUT,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
DECLARE @tmp nvarchar(4000)
    SELECT
        @tmp = ISNULL(SettingValue, '-1')
    FROM SYSettings
         WHERE KeyCode = @KeyCode AND ModuleCode = @ModuleCode
	SET @Val = CONVERT(int, @tmp)
GO