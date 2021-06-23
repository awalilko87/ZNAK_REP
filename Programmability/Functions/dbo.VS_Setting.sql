SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_Setting](
	@Key nvarchar(50),
	@Default nvarchar(max)=null
) returns nvarchar(max)
AS
BEGIN
	return (SELECT ISNULL(SettingValue,@Default) FROM dbo.SYSettings WHERE KeyCode = @Key AND ModuleCode = 'VISION')
END
GO