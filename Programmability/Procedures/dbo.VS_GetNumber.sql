SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[VS_GetNumber]( 
	@Type nvarchar(50),
	@Pref nvarchar(50) = '',
	@Suff nvarchar(50) = '',
	@Number nvarchar(50) out,
	@No int = 0 OUT)
WITH ENCRYPTION
AS
BEGIN
DECLARE @n int, @maxn int, @len int
	if not exists (select ID from dbo.VS_Number where ID = @Type AND [Pref] = @Pref AND [Suf] = @Suff)
		insert into dbo.VS_Number([ID], [Pref], [No], [Suf], [LastNo])
		values (@Type, @Pref, '0', @Suff, '')

	select @n = [No] + 1, @maxn=isnull(MaxNo,[No]+2), @len=isnull(LenNo,5)
	from dbo.VS_Number
	where ID = @Type AND [Pref] = @Pref AND [Suf] = @Suff
	
	IF @n<@maxn
	BEGIN
		if @n < 100000 
			select  @Number = replicate ('0', @len - len(@n)) + convert(nvarchar(10),@n)
		else
			select  @Number = convert(nvarchar(50),@n)
			
		SELECT @Number = @Pref + @Number + @Suff, @No=@n

		update VS_Number
		set [No] = @n, [LastNo] = @Number
		where ID = @Type AND [Pref] = @Pref AND [Suf] = @Suff
	END
	ELSE
	BEGIN
		SET @Number = null
		SET @n = -1
	END 

	
END


GO