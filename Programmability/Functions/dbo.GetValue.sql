SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*Wyliczamy wartość inwentaryzacji*/

CREATE function [dbo].[GetValue] (@objcode nvarchar(30), @siaid int) -- pobieramy kod obiektu i numer inwentaryzacji
returns numeric (16,2)
as
begin 

declare @wartosc numeric(16,2)
declare @objid int



if exists (select 1 from AST_INWLNv  where SIA_ASTCODE = @objcode and SIA_SINID = @siaid and (SIA_ASTSUBCODE <> '0000' and (AST_DESC is null or AST_DESC = '')))

	begin

		select @wartosc = 
		(select top 1 IsNull(cast(AST_SAP_URWRT as numeric(16,2)),0) from AST_INWLNv INW 
		where SIA_ASTCODE = @objcode and SIA_SINID = @siaid and SIA_ASTSUBCODE = 0 ) 
		+ (
		select top 1  IsNull(SUM(IsNull(cast(AST_SAP_URWRT as numeric(16,2)),0)), 0) from AST_INWLNv INW 
		where SIA_ASTCODE = @objcode and SIA_SINID = @siaid and (SIA_ASTSUBCODE <> '0000' and (AST_DESC is null or AST_DESC = ''))  --AND SIA_BARCODE =  'ZMTSP4392_00239'
		 GROUP by INW.SIA_BARCODE
		 )

	 end
 
 else
 
	 begin 
		 
		 select @wartosc = (select top 1 IsNull(cast(AST_SAP_URWRT as numeric(16,2)),0) from AST_INWLNv INW 
		 where SIA_ASTCODE = @objcode and SIA_SINID = @siaid and SIA_ASTSUBCODE = 0 ) 
	 
	 end 

return @wartosc

end
GO