SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INOOT11_CHECK_KEYS](
@p_KEY nvarchar(max),
@INOID int output
)
as
begin
	declare @msg nvarchar(1000)

	if isnull(@p_KEY, '') = ''
	begin
		raiserror('Nie wybrano żadnego rekordu', 16, 1)
		return 1
	end

	if exists (select 1 from dbo.ZWFOTOBJ where OTO_OBJID in (select String from dbo.VS_Split3(@p_KEY, ';') where String <> '' and ind%4 = 1))
	begin
		raiserror('Nie można wybrać składnika dla którego jest już utworzony dokument', 16, 1)
		return 1
	end

	select top 1
		@INOID = INO_ROWID
	from dbo.INVTSK_NEW_OBJ
	cross apply dbo.VS_Split3(@p_KEY,';')
	where INO_ID = String and ind%4 = 2
end
GO