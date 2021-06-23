SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[GenStsObj]
(    
 @p_STSID int,    
 @p_PSPID int,    
 @p_ANOID int,    
 @p_PARENTID int,    
 @p_STNID int,    
     
 @p_UserID nvarchar(30), -- uzytkownik    
 @p_OBJID int output,   
 @p_ADD_PARAMS xml = null, 
 @p_apperrortext nvarchar(4000) = null output    
     
)    
as    
begin    
    
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
    
 declare @v_NEWOBJCODE nvarchar(30)    
  ,@v_prefix nvarchar(30)    
  , @v_KL5ID int    
  , @v_STN nvarchar(30)    
  , @v_PRO_VALUE nvarchar(80)    
  , @v_PRO_NVALUE numeric(24,6)    
  , @v_PRO_DVALUE datetime    

  , @v_DEVICE_PM_NUMBER nvarchar(30)
      
 BEGIN TRY    
        
  --tymczasowy (przed przypisaniem stacji paliw (resztę robi trigger na OBJSTATION, czyli dopóki nie ma określonej stacji obiekt ma kod techniczny)        
  select @v_NEWOBJCODE = 'ZMT_BRAK_STACJI_' + left(convert(nvarchar (50),newid()),6)    

  --parametr do sprawdzenia czy jest podany numer urzadzenia PM
  select @v_DEVICE_PM_NUMBER = (select 
			t.x.value('ADP_DEVICE_PM_NUMBER[1]','nvarchar(30)') as ADP_DEVICE_PM_NUMBER
			from @p_ADD_PARAMS.nodes('/Params') t(x))
     
  insert into [dbo].[OBJ] (    
    OBJ_CODE, OBJ_ORG, OBJ_DESC, OBJ_DATE, OBJ_STATUS, OBJ_TYPE, OBJ_TYPE2, OBJ_TYPE3, OBJ_RSTATUS, OBJ_CREUSER, OBJ_CREDATE, OBJ_NOTUSED, OBJ_ID, OBJ_ATTACH, OBJ_CAPACITY    
   , OBJ_TXT01, OBJ_TXT02, OBJ_TXT03, OBJ_TXT04, OBJ_TXT05, OBJ_TXT06, OBJ_TXT07, OBJ_TXT08, OBJ_TXT09, OBJ_TXT10, OBJ_TXT11, OBJ_TXT12    
   , OBJ_NTX01, OBJ_NTX02, OBJ_NTX03, OBJ_NTX04, OBJ_NTX05, OBJ_COM01, OBJ_COM02, OBJ_DTX01, OBJ_DTX02, OBJ_DTX03, OBJ_DTX04, OBJ_DTX05    
   , OBJ_GROUPID, OBJ_LOCID, OBJ_LOCATION, OBJ_MANUFACID, OBJ_PARTSLISTID, OBJ_PERSON, OBJ_VENDORID, OBJ_YEAR, OBJ_MRCID    
   , OBJ_PREFERED, OBJ_COMPLEX, OBJ_NOTE, OBJ_PSPID, OBJ_ANOID, OBJ_SIGNED, OBJ_SIGNLOC, OBJ_STSID, OBJ_PARENTID, OBJ_PM_TOSEND, OBJ_SERIAL, OBJ_VALUE, OBJ_INOID, OBJ_PM)    
  select     
    @v_NEWOBJCODE, STS_ORG, STS_DESC, STS_DATE, 'OBJ_002', STS_TYPE, STS_TYPE2, STS_TYPE3, STS_RSTATUS, @p_UserID, getdate(), 0, newid(), STS_ATTACH, STS_CAPACITY    
   , STS_TXT01, STS_TXT02, STS_TXT03, STS_TXT04, STS_TXT05, STS_TXT06, STS_TXT07, STS_TXT08, STS_TXT09, STS_TXT10, STS_TXT11, STS_TXT12    
   , STS_NTX01, STS_NTX02, STS_NTX03, STS_NTX04, STS_NTX05, STS_COM01, STS_COM02, STS_DTX01, STS_DTX02, STS_DTX03, STS_DTX04, STS_DTX05    
   , STS_GROUPID, STS_LOCID, STS_LOCATION, STS_MANUFACID, STS_PARTSLISTID, STS_PERSON, STS_VENDORID, STS_YEAR, STS_MRCID    
   , STS_PREFERED, STS_COMPLEX, STS_NOTE, @p_PSPID, @p_ANOID, STS_SIGNED, STS_SIGNLOC, STS_ROWID, @p_PARENTID, STS_PM_TOSEND, ADP_SERIAL, ADP_VALUE, ADP_INOID, nullif(ADP_DEVICE_PM_NUMBER, '')
  from STENCIL (nolock)     
  left join (select 
			t.x.value('ADP_SERIAL[1]','nvarchar(30)') as ADP_SERIAL,
			t.x.value('ADP_VALUE[1]','numeric(16,2)') as ADP_VALUE,
			t.x.value('ADP_INOID[1]','int') as ADP_INOID,
			t.x.value('ADP_DEVICE_PM_NUMBER[1]','nvarchar(30)') as ADP_DEVICE_PM_NUMBER
			from @p_ADD_PARAMS.nodes('/Params') t(x))f on 1=1
  where STS_ROWID = @p_STSID    
       
  select @p_OBJID = scope_identity()  
    
  --ustalenie stacji paliw (podawana w procedurze na wejściu)    
  if @p_STNID is not null    
  begin    
      
   select @v_KL5ID = STN_KL5ID, @v_STN = STN_CODE from dbo.STATION (nolock) where STN_ROWID = @p_STNID    
    
   if @v_KL5ID is null    
   begin    
    select @v_errorcode = 'STS_005'    
    goto errorlabel    
   end     
   insert into [dbo].[OBJSTATION] (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE)    
   select @p_OBJID, @p_STNID, @v_KL5ID, getdate()    
       
  end    

    
  declare @c_ASP_PROID int    
  declare @c_ASP_PM nvarchar(30)    
  declare @c_ASP_VALUE nvarchar(500)    
  declare @c_TYPE nvarchar(30)    
    
  declare cur cursor for    
  -- wybór parametrów danego szablonu    
  select ASP_PROID, PRO_PM_KLASA+'-'+PRO_PM_CECHA, ASP_VALUE, PRO_TYPE from ADDSTSPROPERTIES join dbo.PROPERTIES on PRO_ROWID = ASP_PROID where ASP_STSID = @p_STSID    
  OPEN cur;    
  FETCH NEXT FROM cur INTO @c_ASP_PROID, @c_ASP_PM, @c_ASP_VALUE, @c_TYPE;    
  WHILE @@FETCH_STATUS=0    
   BEGIN    
    select @v_PRO_VALUE = null, @v_PRO_NVALUE = null, @v_PRO_DVALUE = null    
    if @c_TYPE = 'NTX'    
     set @v_PRO_NVALUE = replace(@c_ASP_VALUE ,',','.')   
    else if @c_TYPE = 'DTX'    
     set @v_PRO_DVALUE = @c_ASP_VALUE    
    else    
     set @v_PRO_VALUE = case when @c_ASP_PM = 'ITOB-TPLNR' then replace(@c_ASP_VALUE, '++++', right('0000'+isnull(@v_STN,''),4)) else @c_ASP_VALUE end    
    
    -- sprawdzanie czy insert czy update    
    if exists (select 1 from PROPERTYVALUES where PRV_PKID = @p_OBJID and PRV_PROID = @c_ASP_PROID)    
    begin    
     update PROPERTYVALUES    
     set PRV_VALUE = @v_PRO_VALUE, PRV_NVALUE = @v_PRO_NVALUE, PRV_DVALUE = @v_PRO_DVALUE    
      , PRV_UPDATECOUNT = PRV_UPDATECOUNT+1    
      , PRV_UPDATED = getdate()    
     where PRV_PKID = @p_OBJID and PRV_PROID = @c_ASP_PROID    
    end    
    else    
    begin    
     -- dodwanie właściwości obiektu na podstawie wybranego szablonu    
     insert into PROPERTYVALUES (PRV_PROID, PRV_PKID, PRV_ENT, PRV_VALUE, PRV_NVALUE, PRV_DVALUE, PRV_UPDATECOUNT, PRV_CREATED)    
     values (@c_ASP_PROID, @p_OBJID, 'OBJ', @v_PRO_VALUE, @v_PRO_NVALUE, @v_PRO_DVALUE, 1, getdate())    
    end     
    
    
   FETCH NEXT FROM cur INTO @c_ASP_PROID, @c_ASP_PM, @c_ASP_VALUE, @c_TYPE;    
   END    
  CLOSE cur       
  DEALLOCATE cur    
    
	IF @v_DEVICE_PM_NUMBER IS NULL
		BEGIN 
			exec dbo.SAPO_PM_Insert @p_OBJID, 'I', null, @p_UserID
		END
		ELSE 
		BEGIN 
			exec dbo.SAPO_PM_Insert @p_OBJID, 'U', null, @p_UserID
		END
      
 END TRY    
 BEGIN CATCH    
  select @v_syserrorcode = error_message()    
  select @v_errorcode = 'STS_000' -- blad kasowania    
  goto errorlabel    
 END CATCH;    
    
 return     
       
 errorlabel:    
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
  raiserror (@v_errortext, 16, 1)     
  select @p_apperrortext = @v_errortext    
  return 1    
    
end




GO