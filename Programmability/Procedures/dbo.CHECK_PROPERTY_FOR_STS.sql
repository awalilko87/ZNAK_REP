SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CHECK_PROPERTY_FOR_STS] (@v_STSId int, @v_SAP_PM nvarchar(30), @UserId nvarchar(30), @vSTNid int)        
as         
        
begin        
--- Deklarujemy kolumny dodatkowe, dla których będziemy sprawdzać, czy dany parametr istnieje w propertyvalues        
declare        
 @c12 nvarchar(30),        
 @c13 nvarchar(30),        
 @c14 nvarchar(30),        
 @c15 nvarchar(30),        
 @c16 nvarchar(30),        
 @c17 nvarchar(30),        
 @c18 nvarchar(30),        
 @c19 nvarchar(30),        
 @c20 nvarchar(30),        
 @c21 nvarchar(30),        
 @c22 nvarchar(30),        
 @c23 nvarchar(30),        
 @c24 nvarchar(30),        
 @c25 nvarchar(30),        
 @c26 nvarchar(30),        
 @c27 nvarchar(30),        
 @c28 nvarchar(30),        
 @c29 nvarchar(30),        
 @c30 nvarchar(30)        
        
declare @t_kolumny table(kolumny nvarchar(30), stsid int, sap_pm nvarchar(30)) -- tabela przechowująca         
        
declare @Mes nvarchar(max)        
        
/*zmienne sterujące kursorami*/        
declare @kolumna nvarchar(30)         
declare @c_stsid int        
        
        
--declare kolumny cursor for         
select top 1 @c12 = c12, @c13 = c13,@c14 = c14,@c15 = c15        
,@c16 = c16,@c17 = c17,@c18 = c18,@c19 = c19,@c20 = c20        
,@c21 = c21,@c22 = c22,@c23 = c23,@c24 = c24,@c25 = c25        
,@c26 = c26,@c27 = 27,@c28 = 28,@c29 = 29, @c30 = c30        
from STN_ADD_OBJ_EXCEL order by rowid        
        
set @Mes = ''        
        
--open kolumny         
        
---- lecimy po polei po kolumnach i sprawdzamy, czy dla danej kolumny        
----, dla danego składnika isnieje odniesnienie w tabeli property values        
--fetch next from kolumny        
--into  @c12, @c13, @c14, @c15, @c16, @c17, @c18, @c19, @c20        
--, @c21, @c22, @c23, @c24, @c25, @c26, @c27,@c28,@c29,@c30        
        
--while @@FETCH_STATUS = 0         
        
--begin        
        
delete from @t_kolumny        
        
 insert into @t_kolumny(kolumny, stsid,sap_pm)        
 values (@c12,@v_STSId,@v_SAP_PM),(@c13,@v_STSId,@v_SAP_PM),(@c14,@v_STSId,@v_SAP_PM),(@c15,@v_STSId,@v_SAP_PM)        
 ,(@c16,@v_STSId,@v_SAP_PM),(@c17,@v_STSId,@v_SAP_PM),(@c18,@v_STSId,@v_SAP_PM),(@c19,@v_STSId,@v_SAP_PM),(@c20,@v_STSId,@v_SAP_PM)        
 ,(@c21,@v_STSId,@v_SAP_PM),(@c22,@v_STSId,@v_SAP_PM),(@c23,@v_STSId,@v_SAP_PM),(@c24,@v_STSId,@v_SAP_PM),(@c25,@v_STSId,@v_SAP_PM)        
 ,(@c26,@v_STSId,@v_SAP_PM),(@c27,@v_STSId,@v_SAP_PM),(@c28,@v_STSId,@v_SAP_PM),(@c29,@v_STSId,@v_SAP_PM),(@c30,@v_STSId,@v_SAP_PM)        
        
        
  declare property  cursor for select kolumny, stsid from @t_kolumny  where kolumny is not null and kolumny <> '' --and kolumny not in (27,28,29)      
        
  open property         
        
  fetch next from property        
   into @kolumna, @c_stsid         
           
   while @@FETCH_STATUS = 0         
           
    begin         
          
  if (@kolumna is not null or @kolumna not like '2%'or @kolumna = '')      
           
  begin       
        
   declare @STS_CODE nvarchar(30)         
   select @STS_CODE = STS_CODE from stencil where STS_ROWID = @c_stsid        
                 
   if not exists (select 1 from PROPERTIES        
     join ADDSTSPROPERTIES on PRO_ROWID = ASP_PROID        
     where ASP_STSID = @c_stsid  and PRO_TEXT = @kolumna)        
                
   set @Mes =  'Dla szablonu: '+ isNull(cast(@STS_CODE as nvarchar(30)),'') + ' nie istnieje parametr: '+ IsNull(cast(@kolumna as nvarchar(30)),'NULL') + N' Składnik:' + @v_SAP_PM      
          
    insert into import_sp_log(lsp_stncode, lsp_stscode, lsp_importuser, lsp_param, lsp_reason, lsp_date, lsp_stacja)       
        values (@STS_CODE, @v_SAP_PM, @UserId,@v_SAP_PM,@Mes, GETDATE(),@vSTNid)    
   end       
            
   fetch next from property         
           
   into @kolumna, @c_stsid        
 end        
        
        
          
close property         
          
deallocate property         
        
--PRINT @Mes        
          
 end 
GO