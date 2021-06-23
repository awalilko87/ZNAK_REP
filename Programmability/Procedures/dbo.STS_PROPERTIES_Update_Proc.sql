SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_PROPERTIES_Update_Proc]  
(  
 @p_FormID nvarchar(50),  
 @p_ENT nvarchar(10),  
 @p_LIST nchar(1),   
 @p_PRO nvarchar(30),    
 @p_PROID int,   
 @p_PROTYPE nvarchar(4),   
 @p_REQUIRED nvarchar(3),   
 @p_ROWID int,   
 @p_STSID int,   
 @p_UOM nvarchar(30),    
 @p_UOMID int,   
 @p_ASP_VALUE nvarchar(512),  
 @p_UserID nvarchar(30) = NULL, -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
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
  declare @v_PROTYPE nvarchar(30)  
    
  set @v_date = getdate()  
  
  if @p_PROID is null   
  begin  
    select @v_errorcode = 'PRO_001'  
 goto errorlabel  
  end  
    
  if @p_STSID is null   
  begin  
    select @v_errorcode = 'STS_001'  
 goto errorlabel  
  end  
  
  set @p_ASP_VALUE = nullif(@p_ASP_VALUE, '')  
  
  select @v_PROTYPE = PRO_TYPE from dbo.PROPERTIES where PRO_ROWID = @p_PROID  
  
  if @v_PROTYPE = 'NTX' and isnumeric(replace(@p_ASP_VALUE, ',', '.')) = 0 and @p_ASP_VALUE is not null  
  begin  
 raiserror('Błędny format liczby', 16, 1)  
 return 1  
  end  
  
  if @v_PROTYPE = 'DTX' and isdate(@p_ASP_VALUE) = 0 and @p_ASP_VALUE is not null  
  begin  
 raiserror('Błędny format daty', 16, 1)  
 return 1  
  end  
  
-- Dla paramterów z listą rozwijalną, dodać kontrolę, która sprawdzi czy wprowadzona wartość istnieje na liście.

 if @v_PROTYPE = 'DDL'
	begin
		if not exists (select 1 from dbo.PROPERTIES_LIST where prl_proid = @p_PROID and prl_text = @p_ASP_VALUE)
			begin
				Raiserror (N'Wprowadzona wartość jest niedozwolona. Wybierz wartość ze słownika znajdującego się poniżej',16,1)
			end 
	end
  
  
 --insert  
 if not exists (select * from dbo.ADDSTSPROPERTIES (nolock) where ASP_PROID = @p_PROID and ASP_STSID = @p_STSID)  
 begin  
    
      BEGIN TRY  
  insert into dbo.ADDSTSPROPERTIES  
  (  
   ASP_PROID,  
   ASP_ENT,  
   ASP_STSID,  
   ASP_UOMID,  
   ASP_LIST,  
   ASP_VALUE,  
   ASP_UPDATECOUNT,  
   ASP_CREATED,  
   ASP_REQUIRED  
  )  
  select  
   @p_PROID,  
   @p_ENT,  
   @p_STSID,  
   @p_UOMID,  
   @p_LIST,  
   @p_ASP_VALUE,  
   0,  
   getdate(),  
   @p_REQUIRED  
   END TRY  
   BEGIN CATCH  
  select @v_syserrorcode = error_message()  
  select @v_errorcode = 'STS_001' -- blad wstawienia  
  goto errorlabel  
   END CATCH;  
 end  
    else  
    begin  
   
  BEGIN TRY  
    UPDATE dbo.ADDSTSPROPERTIES SET  
   ASP_PROID = @p_PROID,  
   ASP_ENT = @p_ENT,  
   ASP_STSID = @p_STSID,  
   ASP_UOMID = @p_UOMID,  
   ASP_LIST = @p_LIST,  
   ASP_VALUE = @p_ASP_VALUE,  
   ASP_UPDATECOUNT = ASP_UPDATECOUNT + 1,  
   ASP_UPDATED = getdate(),  
   ASP_REQUIRED = @p_REQUIRED  
    where ASP_PROID = @p_PROID and ASP_STSID = @p_STSID  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'STS_002' -- blad aktualizacji zgloszenia  
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