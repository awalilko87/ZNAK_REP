SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[OT_LN_WARRANTY] 
(@OTID int
,@OT11_RECEIVE_DATE datetime
,@OT11_INSTALL_DATE datetime
,@OT11_INVOICE_DATE datetime
,@OT11_UDF03 nvarchar(100))
as
begin

	declare @OBJ_ROWID int

	declare otline cursor for select OTO_OBJID from ZWFOTOBJ where OTO_OTID = @OTID
	open otline 
	fetch next from otline into @OBJ_ROWID
	while @@FETCH_STATUS = 0
	begin 
		declare @STSID int 
		declare @WARRANTY nvarchar(5) -- STS_TXT02
		declare @MSC_QTY nvarchar(3) -- STS_TXT03
		declare @DATA datetime
		declare @WARRANTY_PARAM nvarchar(30)
		declare @WARRANTY_END datetime

		select @STSID = OBJ_STSID from OBJ where OBJ_ROWID = @OBJ_ROWID
		select @WARRANTY = STS_TXT02, @MSC_QTY = STS_TXT03 from STENCIL where STS_ROWID = @STSID
		select @DATA = case when @OT11_UDF03 = 1 then @OT11_RECEIVE_DATE
							when @OT11_UDF03 = 2 then @OT11_INSTALL_DATE
							when @OT11_UDF03 = 3 then @OT11_INVOICE_DATE
						end
		select @WARRANTY_PARAM = PRO_ROWID from PROPERTIES where PRO_CODE = 'WARRANTY' -- koniec gwarac


		if @WARRANTY = 'TAK' and @MSC_QTY is not null
		begin
			if exists (select 1 from ADDSTSPROPERTIES where ASP_STSID = @STSID and ASP_PROID = @WARRANTY_PARAM)
			begin 
				/*wyznaczamy datę końca gwarancji*/
				select @WARRANTY_END = dateadd (M,cast(@MSC_QTY as int),@DATA)

				/*Aktualizacja pola konec gwarancji*/

				update PROPERTYVALUES
				set PRV_DVALUE = @WARRANTY_END
				where PRV_PKID = @OBJ_ROWID
				and PRV_ENT = 'OBJ'
				and PRV_PROID = @WARRANTY_PARAM 
			end 
		end 
		fetch next from otline into @OBJ_ROWID
	end

end
GO