SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_NEW_OBJ_Delete_Proc] 
(
  @p_Key nvarchar(max) = NULL,

  @p_UserID nvarchar(30)
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)

  declare @v_obj_ino_id int;
  declare @ot_code nvarchar(512);
  declare @cr_ROWID nvarchar(30);
  declare @v_ROWID INT;

--print @p_Key
--select string from dbo.VS_Split3('367415;E651F8BA-8A52-40FC-8099-4EF873A4645F;7949;165EAADF-D4E8-4DD7-8939-9A48FA05695D;367418;56715A19-A85B-4101-AB54-6219160BC523;7950;C13ED533-7FB4-4ED5-AA91-71D1E6857486;367424;1C2A7F04-ECDA-4443-9865-094CA67B1BD2;7952;14BA99E1-0F9B-44D0-88F6-375C4714815D;367425;269CD1A2-068E-486A-AF8E-CEC45C9BE52D;7953;D972F2C5-BBFA-44EB-826A-06A812AB270C;',';')
--where string != '' and ISNULL(string,'0') != '0'
--		and ind%4 = 1  
  
  declare c_instr cursor for 
	select string from dbo.VS_Split3(@p_KEY,';')
		where string != '' and ISNULL(string,'0') != '0'
		and ind%4 = 1
	--DECLARE @X NVARCHAR(MAX) = (SELECT [STRING] + ' ' FROM dbo.VS_Split3(@p_KEY,';') 		where string != '' and ISNULL(string,'0') != '0'
	--	and ind%4 = 1 FOR XML PATH('')) + '<br>'
	--PRINT @X
    open c_instr
	fetch next from c_instr into @cr_ROWID
	--PRINT ' ' +CAST(@@fetch_status AS NVARCHAR) + ' '
	while @@fetch_status = 0
	BEGIN
	  SET @v_ROWID = cast(@cr_ROWID as int)
	  select @v_obj_ino_id = OBJ_INOID from OBJ where OBJ_ROWID = @v_ROWID

	  -- gdy jest już podpięty dokument nie usuwaj
	  select @ot_code = OT_CODE from [INVTSK_NEW_OBJv] where INO_ROWID  = @v_obj_ino_id

		declare @count int
		select @count = count(*) from OBJ
		where OBJ_PARENTID = @v_ROWID
		--PRINT 'INOID: ' + CAST(ISNULL(@v_obj_ino_id,0) AS NVARCHAR(30))+', OTCODE: ' + ISNULL(@ot_code,'D00-PA') + '<br>'
 
	  if @v_obj_ino_id is not null and @ot_code is null
	  BEGIN TRY

	  -- usunięcie także lini na ZWFOT z uwagi na klucze. Powiązane z anulowanie OT z zadania (PKNTA-1031)
		if @count > 1
			delete from ZWFOTOBJ where OTO_OBJID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @v_ROWID)
		else
			delete from ZWFOTOBJ where OTO_OBJID = @v_ROWID
		
		if @count > 1
			delete from PROPERTYVALUES
			where PRV_ENT = 'OBJ'
			and PRV_PKID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @v_ROWID)
		else
			delete from PROPERTYVALUES
			where PRV_ENT = 'OBJ'
			and PRV_PKID = @v_ROWID

		if @count > 1
			delete from OBJSTATION
			where OSA_OBJID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @v_ROWID)
		else
			delete from dbo.OBJSTATION
			where OSA_OBJID = @v_ROWID
			
		if @count > 1
			delete from OBJ
			where OBJ_ROWID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @v_ROWID)
		ELSE
			delete from OBJ
			where OBJ_ROWID = @v_ROWID



			--DECLARE @EXISTS NVARCHAR(6) = ''
			--SET @EXISTS = CASE WHEN EXISTS (SELECT 1 from [INVTSK_NEW_OBJ]
			--where INO_ROWID = @v_obj_ino_id
			--and INO_ROWID not in (select OBJ_INOID from OBJ	where OBJ_INOID = @v_obj_ino_id)) THEN ' TAK ' ELSE ' NIE ' END
			--PRINT 'ISTNIEJA:' + @EXISTS 
			delete from [INVTSK_NEW_OBJ]
			where INO_ROWID = @v_obj_ino_id
			and INO_ROWID not in (select OBJ_INOID from OBJ	where OBJ_INOID = @v_obj_ino_id)
		

	  END TRY

	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'INO_001' -- blad kasowania
		close c_instr
		deallocate c_instr
		goto errorlabel
	  END CATCH;

	 fetch next from c_instr into @cr_ROWID

	END
	close c_instr
	deallocate c_instr

	RETURN 0

  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @v_errortext
    return 1
end

GO