SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SAPO_OT42] 
as
begin

    declare @id_42 int
	declare @v_ret tinyint

    Select top 1 @id_42 = OT42_ROWID from SAPO_ZWFOT42 where OT42_IF_STATUS = 1 order  by OT42_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT42', @id_42

	if @v_ret = 1
	begin
		set @id_42 = null
	end

      select 
			[DOC_NUM],
			[DOC_YEAR],
			[AKCJA],
			[GUID],
            [KROK],
            [BUKRS],
            [WYST_SAPUSER],
            [WYST_NAME],
            [UZASADNIENIE],
            [KOSZT],
            [SZAC_WART_ODZYSKU],
            [SPOSOBLIKW],
            [MIESIAC],[ROK],
            [PSP],
			CZY_UCHWALA,
			CZY_DECYZJA,
			CZY_ZAKRES,
			CZY_OCENA,
			CZY_EKSPERTYZY,
			UCHWALA_OPIS,
			DECYZJA_OPIS,
			ZAKRES_OPIS,
			OCENA_OPIS,
			EKSPERTYZY_OPIS            
	from dbo.SAPO_ZWFOT42v where OT42_ROWID = @id_42

	select 
		TDFORMAT, 
		TDLINE
	from dbo.[SAPO_ZWFOT42COMv] where OT42COM_OT42ID = @id_42


    select 
        [BUKRS],
        [ANLN1],
        [ANLN2],
        [KOSTL] ,
        [GDLGRP],
        [ODZYSK],
        [LIKWCZESC],
        [PROC]  
    from dbo.SAPO_ZWFOT42LNv where OT42LN_OT42ID = @id_42

	update dbo.SAPO_ZWFOT42 set
		 OT42_IF_STATUS = 2
		,OT42_IF_SENTDATE = getdate()
	where OT42_ROWID = @id_42

       
    return

end
GO