SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[P1](	@sTxtin	nvarchar(50) )
returns nvarchar(50)
WITH ENCRYPTION
AS 

begin
	--D7i
	declare @sCryp		nvarchar(50)
	declare @sRetcode	nvarchar(50)
	declare @nCount		int

	set @sRetcode = null
 	select @nCount = count(*)
		FROM SYSettings
		WHERE ModuleCode='VISION' AND KeyCode=N'INSTCODE'
 
 	if @nCount > 0 
 		select @sCryp = isnull( SettingValue, N'SqLSyStEmSbV' )
		FROM SYSettings
		WHERE ModuleCode='VISION' AND KeyCode=N'INSTCODE'
 	else
		set @sCryp = N'SqLSyStEmSbV'

	while isnull( len( @sCryp ), 0 ) < 50
		--set @sCryp = substring( @sCryp + @sCryp, 1, 50 )
		set @sCryp = substring( replicate(@sCryp, ceiling(50./len(@sCryp))), 1, 50 )

	set @nCount = 1
	while @nCount < 51 and @nCount < len(@sTxtin) + 1
		begin
			if @nCount = 1
				set @sRetcode = Char(((ascii(substring(@sTxtin, @nCount, 1)) - 33 + ascii(substring(@sCryp, @nCount, 1)) - 33) % 90) + 33)
			else
				set @sRetcode = @sRetcode + Char(((ascii(substring(@sTxtin, @nCount, 1)) - 33 + ascii(substring(@sCryp, @nCount, 1)) - 33) % 90) + 33)
			set @nCount = @nCount + 1
		end
	
	return (@sRetcode)
end
GO