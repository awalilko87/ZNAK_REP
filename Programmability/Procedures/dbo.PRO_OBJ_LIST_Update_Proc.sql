SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_OBJ_LIST_Update_Proc]   
(  
  @p_FormID nvarchar(50)
 ,@p_PROID int = NULL
 ,@p_ROWID int = NULL
 ,@p_TEXT nvarchar(255)
 ,@p_UserID nvarchar(30) -- uzytkownik  
 ,@p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_Rstatus int  
 declare @v_Pref nvarchar(10)
 declare @v_ControlType nvarchar(4)  
 
 select @v_ControlType = PRO_TYPE from dbo.PROPERTIES where pro_rowid = @p_PROID 
    
 -- czy klucze niepuste  
 if @p_ROWID is null -- ## dopisac klucze  
 begin  
  select @v_errorcode = 'PRL_001'  
  goto errorlabel  
 end  
   
  -- czy klucze niepuste  
 if @p_PROID is null -- ## dopisac klucze  
 begin  
  select @v_errorcode = 'PRL_002'  
  goto errorlabel  
 end  
 
 
 -- Dla paramterów z listą rozwijalną, dodać kontrolę, która sprawdzi czy wprowadzona wartość istnieje na liście.
 if @v_ControlType = 'DDL'
	begin
		if not exists (select 1 from dbo.PROPERTIES_LIST where prl_proid = 305 and prl_text = @p_TEXT)
			begin
				Raiserror (N'Wprowadzona wartość jest niedozwolona. Wybierz wartość ze słownika znajdującego się poniżej',16,1)
			end 
	end
	
	  
 --insert  
 if not exists (select * from PROPERTYVALUES where PRV_PROID = @p_PROID and PRV_ENT= 'OBJ' and PRV_PKID = @p_ROWID)  
 begin   
  BEGIN TRY  
   insert into dbo.PROPERTYVALUES  
   (  
    PRV_PROID,  
    PRV_PKID,  
    PRV_ENT,  
    PRV_VALUE,  
    PRV_UPDATECOUNT,  
    PRV_NOTUSED  
      
   )  
   select    
    @p_PROID,  
    @p_ROWID,  
    'OBJ',  
    @p_TEXT,  
    1,  
    '-'  
  
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
     
   PRV_VALUE = @p_TEXT,  
   PRV_UPDATECOUNT = isnull(PRV_UPDATECOUNT,0) + 1,   
   PRV_UPDATED = getdate()  
  where   
   PRV_PROID = @p_PROID and PRV_ENT= 'OBJ' and PRV_PKID = @p_ROWID  
  
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