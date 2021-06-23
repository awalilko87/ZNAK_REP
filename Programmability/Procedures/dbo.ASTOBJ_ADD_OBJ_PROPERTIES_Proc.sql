SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ASTOBJ_ADD_OBJ_PROPERTIES_Proc]    
(    
 @p_FormID nvarchar(50)  
 ,@p_ASPID int  
 ,@p_DVALUE datetime  
 ,@p_ENT nvarchar(10)  
 ,@p_FIELDID nvarchar(41)  
 ,@p_NVALUE numeric(24,6)  
 ,@p_OBJ nvarchar(30)  
 ,@p_OBJDESC nvarchar(80)  
 ,@p_OBJID int  
 ,@p_PROID int  
 ,@p_PROPERTY nvarchar(30)  
 ,@p_PROTEXT nvarchar(25)  
 ,@p_PROTYPE nvarchar(4)  
 ,@p_PSP nvarchar(30)  
 ,@p_PSPID int  
 ,@p_ROWID int  
 ,@p_STSID int  
 ,@p_UOM nvarchar(30)  
 ,@p_UOMID int  
 ,@p_VALUE nvarchar(40)  
 ,@p_VALUE_LIST nvarchar(30)  
 ,@p_UserID nvarchar(30) -- uzytkownik    
 ,@p_apperrortext nvarchar(4000) = null output    
)    
as    
begin    
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_date datetime    
 declare @v_Rstatus int    
 declare @v_Pref nvarchar(10)    
 declare @v_MultiOrg BIT    
 declare @v_PRO_TYPE nvarchar(30)    
  , @v_DVALUE datetime    
  , @v_NVALUE numeric(24,6)    
  , @v_VALUE nvarchar(255)    
  , @v_ERROR nvarchar(255) = ''    
      
 --select @p_VALUE_LIST ='a + ' + isnull(cast (@p_PROPERTY as nvarchar(30)),'@p_OBJID: NULL') + ' + a'    
 --raiserror (@p_VALUE_LIST, 16, 1)     
 --return 0    
     
 -- czy klucze niepuste    
 if @p_ASPID is null -- ## dopisac klucze    
 begin    
  select @v_errorcode = 'PRV_001'    
  goto errorlabel    
 end    
     
  -- czy klucze niepuste    
 if @p_PROID is null -- ## dopisac klucze    
 begin    
  select @v_errorcode = 'PRL_002'    
  goto errorlabel    
 end    
    
 set @v_date = getdate()    
       
 select @v_PRO_TYPE = PRO_TYPE from PROPERTIES (nolock) where PRO_ROWID = @p_PROID    
 select  PRO_TYPE from PROPERTIES where PRO_CODE = 'MID'    
    
if @v_PRO_TYPE = 'TXT'   
 begin    
  select @v_VALUE = cast (@p_VALUE as nvarchar(255))    
  end  
    else if @v_PRO_TYPE = 'DDL'  
   begin   
   if not exists (select 1 from dbo.PROPERTIES_LIST where PRL_PROID = @p_PROID and PRL_TEXT = @p_VALUE)  
    begin  
     RaisError (N'Wprowadzona wartość jest niedozwolona. Wybierz wartość ze słownika znajdującego się poniżej',16,1)  
     return;  
    end    
   end     
 --else if @v_PRO_TYPE = 'DDL'     
 --begin    
 -- if @p_VALUE in (select PRL_TEXT from PROPERTIES_LIST (nolock) where PRL_PROID = @p_PROID) select @v_VALUE = cast (@p_VALUE as nvarchar(255))    
 -- else select @v_ERROR = N'Wprowadzono niewłaściwe pole słownikowane: ' + cast (@p_VALUE_LIST as nvarchar(255))    
 --end    
    
 else if @v_PRO_TYPE = 'DTX'     
 begin    
   if isdate(@p_VALUE) = 1   
   begin   
  select @v_DVALUE = cast (@p_VALUE as datetime)   
   end   
 else   
   begin  
    set @v_ERROR = N'Wprowadzono niewłaściwe pole daty: ' + cast (@p_VALUE as nvarchar(255))  
  RaisError (@v_ERROR, 16,1)  
   return;     
    end  
 end    
    
 else if @v_PRO_TYPE = 'NTX'     
  begin    
    if isnumeric(@p_VALUE) = 1   
      
    begin   
    select @v_NVALUE = cast (@p_VALUE as numeric(24,6))  
    end     
  else   
    begin   
    select @v_ERROR = N'Wprowadzono niewłaściwe pole numeryczne: ' + cast (@p_VALUE as nvarchar(255))    
    RaisError (@v_ERROR, 16,1)   
    return;  
    end      
  end   
      
 --insert    
 if not exists (select * from dbo.PROPERTYVALUES (nolock) where PRV_PKID = @p_OBJID and PRV_PROID = @p_PROID)    
 begin     
  BEGIN TRY    
   insert into dbo.PROPERTYVALUES    
   (    
    PRV_PROID,    
    PRV_PKID,    
    PRV_ENT,    
    PRV_VALUE,    
    PRV_DVALUE,    
    PRV_NVALUE,    
    PRV_CREATED,    
    PRV_NOTUSED,    
    PRV_ERROR    
   )    
   select      
    @p_PROID,    
    @p_OBJID,    
    'OBJ',    
    @p_VALUE,    
    @v_DVALUE,    
    @v_NVALUE,    
    getdate(),    
    0,    
    @v_ERROR   
	
	
	/*Przypisywanie parametrów dodatkowych w składnikach typu zestaw ze składnika głównego */

if exists (select 1 from obj where obj_parentid = @p_OBJID and OBJ_ROWID<> @p_OBJID)

begin 

	if exists (select 1 from PROPERTYVALUES where PRV_PROID = @p_PROID and PRV_PKID in (select OBJ_ROWID from OBJ where OBJ_PARENTID = @p_OBJID
	and OBJ_ROWID<> @p_OBJID) and (PRV_VALUE IS NULL or PRV_DVALUE is not null or PRV_NVALUE is not null))

		begin	
	
		declare @pro_type nvarchar(30) 
		select @pro_type = PRO_TYPE from PROPERTIES where PRO_ROWID = @p_PROID

		declare @PRV_VALUE nvarchar(40)
		declare @PRV_DVALUE datetime
		declare @PRV_NVALUE numeric(24,6)

		select @PRV_VALUE = PRV_VALUE 
		,@PRV_DVALUE = PRV_DVALUE
		,@PRV_NVALUE = PRV_NVALUE
		from PROPERTYVALUES where PRV_PROID = @p_PROID and PRV_PKID = @p_OBJID

			update PROPERTYVALUES
			set PRV_VALUE = case when @pro_type in ('DTX', 'NTX') then null else @PRV_VALUE end 
			, PRV_DVALUE = case when @pro_type = 'DTX' then @PRV_DVALUE else NULL end
			, PRV_NVALUE = case when @pro_type = 'NTX' then @PRV_NVALUE else NULL end
			where  PRV_PKID in (select OBJ_ROWID from OBJ where OBJ_PARENTID = @p_OBJID
								and OBJ_ROWID<> @p_OBJID and (PRV_VALUE is not null or PRV_NVALUE is not null or PRV_DVALUE is not null))

		end


end
		
	
	 
    
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'SYS_001' -- blad wstawienia    
   goto errorlabel    
  END CATCH;    
 end    
 else     
 begin    
          
  BEGIN TRY    
       
  UPDATE dbo.PROPERTYVALUES SET     
   PRV_VALUE = @p_VALUE,    
   PRV_NVALUE = @v_NVALUE,    
   PRV_DVALUE = @v_DVALUE,    
   PRV_UPDATECOUNT = PRV_UPDATECOUNT   + 1,    
   PRV_UPDATED = getdate(),    
   PRV_NOTUSED = 0,    
   PRV_ERROR = @v_ERROR    
  where     
   PRV_PROID = @p_PROID and PRV_PKID = @p_OBJID     
    
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OBJ_002' -- blad aktualizacji zgloszenia    
   goto errorlabel    
  END CATCH;    
 end    
      
 return 0    
      
 errorlabel:    
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
  raiserror (@v_errortext, 16, 1)     
  select @p_apperrortext = @v_errortext    
  return 1    
end    
GO