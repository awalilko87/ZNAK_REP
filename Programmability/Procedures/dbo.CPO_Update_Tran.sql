SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_Update_Tran]              
(              
 @p_FormID nvarchar(50),              
 @p_ID nvarchar(50),              
 @p_ROWID int,                      
 @p_CODE nvarchar(30),              
 @p_ORG nvarchar(30),              
 @p_DESC nvarchar(80),              
 @p_NOTE ntext,              
 @p_DATE datetime,              
 @p_STATUS nvarchar(30),              
 @p_STATUS_old nvarchar(30),              
 @p_TYPE nvarchar(30),              
 @p_TYPE2 nvarchar(30),              
 @p_TYPE3 nvarchar(30),                          
 @p_TXT01 nvarchar(30),              
 @p_TXT02 nvarchar(30),              
 @p_TXT03 nvarchar(30),              
 @p_TXT04 nvarchar(30),              
 @p_TXT05 nvarchar(30),              
 @p_TXT06 nvarchar(80),              
 @p_TXT07 nvarchar(80),              
 @p_TXT08 nvarchar(255),              
 @p_TXT09 nvarchar(255),              
 @p_NTX01 numeric(24,6),              
 @p_NTX02 numeric(24,6),              
 @p_NTX03 numeric(24,6),              
 @p_NTX04 numeric(24,6),              
 @p_NTX05 numeric(24,6),              
 @p_COM01 ntext,              
 @p_COM02 ntext,              
 @p_DTX01 datetime,              
 @p_DTX02 datetime,              
 @p_DTX03 datetime,              
 @p_DTX04 datetime,              
 @p_DTX05 datetime,              
 --@p_UZASADNIENIE nvarchar(70),              
 @p_UCHWALA_OPIS nvarchar(70),              
 @p_CZY_UCHWALA nvarchar(1),              
 @p_CZY_DECYZJA nvarchar(1),              
 @p_DECYZJA_OPIS nvarchar(70),              
 @p_CZY_ZAKRES nvarchar(1),              
 @p_ZAKRES_OPIS nvarchar(70),              
 @p_OCENA_OPIS nvarchar(70),              
 @p_CZY_OCENA nvarchar(1),              
 @p_CZY_EKSPERTYZY nvarchar(1),              
 @p_EKSPERTYZY_OPIS nvarchar(70),              
 @p_SPOSOBLIKW nvarchar(35),              
 @p_PSP_POSKI nvarchar(30),              
 @p_MIESIAC int,             
 @p_ROK int,      
 @p_MODERN_PROFILE int,           
 @p_UserID nvarchar(30),                           
 @p_apperrortext nvarchar(4000) = null output              
)              
as              
begin              
  declare @v_errorid int              
  declare @v_errortext nvarchar(4000)               
  select @v_errorid = 0              
  select @v_errortext = null              
              
  begin transaction              
    exec @v_errorid = dbo.CPO_Update_Proc               
  @p_FormID,              
  @p_ID,              
  @p_ROWID,                         
  @p_CODE,              
  @p_ORG,              
  @p_DESC,              
  @p_NOTE,              
  @p_DATE,              
  @p_STATUS,              
  @p_STATUS_old,              
  @p_TYPE,              
  @p_TYPE2,              
  @p_TYPE3,                          
  @p_TXT01,              
  @p_TXT02,              
  @p_TXT03,              
  @p_TXT04,              
  @p_TXT05,              
  @p_TXT06,              
  @p_TXT07,              
  @p_TXT08,              
  @p_TXT09,              
  @p_NTX01,              
  @p_NTX02,              
  @p_NTX03,              
  @p_NTX04,              
  @p_NTX05,              
  @p_COM01,              
  @p_COM02,              
  @p_DTX01,              
  @p_DTX02,              
  @p_DTX03,              
  @p_DTX04,              
  @p_DTX05,              
  --@p_UZASADNIENIE,              
  @p_UCHWALA_OPIS,              
  @p_CZY_UCHWALA,              
  @p_CZY_DECYZJA,              
  @p_DECYZJA_OPIS,              
  @p_CZY_ZAKRES,              
  @p_ZAKRES_OPIS,              
  @p_OCENA_OPIS,              
  @p_CZY_OCENA,              
  @p_CZY_EKSPERTYZY,              
  @p_EKSPERTYZY_OPIS,              
  @p_SPOSOBLIKW,              
  @p_PSP_POSKI,              
  @p_MIESIAC,             
  @p_ROK,     
  @p_MODERN_PROFILE,          
  @p_UserID,                   
  @p_apperrortext output              
  if @v_errorid = 0              
  begin              
    commit transaction              
    return 0              
  end              
  else              
  begin              
    rollback transaction              
    return 1              
  end              
end 
GO