SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT42_Update_Tran]  
(  
 @p_FormID nvarchar(50),   
 @p_ROWID int,  
 @p_CODE nvarchar(30),   
 @p_ID nvarchar(50),  
 @p_ORG nvarchar(30),  
 @p_RSTATUS int,  
 @p_STATUS nvarchar(30),  
 @p_STATUS_old nvarchar(30),  
 @p_TYPE nvarchar(30),  
 @p_KROK nvarchar(10),  
 @p_BUKRS nvarchar(30),  
 @p_UZASADNIENIE nvarchar(70),  
 @p_KOSZT nvarchar(15),  
 @p_SZAC_WART_ODZYSKU nvarchar(15),  
 @p_SPOSOBLIKW  nvarchar(35),   
 @p_PSP_POSKI nvarchar(30),  
 @p_ROK int,  
 @p_MIESIAC int,  
 @p_CZY_UCHWALA nvarchar(1),  
 @p_CZY_DECYZJA nvarchar(1),  
 @p_CZY_ZAKRES nvarchar(1),  
 @p_CZY_OCENA nvarchar(1),  
 @p_CZY_EKSPERTYZY nvarchar(1),  
 @p_UCHWALA_OPIS nvarchar(70),  
 @p_DECYZJA_OPIS nvarchar(70),  
 @p_ZAKRES_OPIS nvarchar(70),  
 @p_OCENA_OPIS nvarchar(70),  
 @p_EKSPERTYZY_OPIS nvarchar(70),  
 @p_IF_EQUNR nvarchar(30),  
 @p_IF_SENTDATE datetime,  
 @p_IF_STATUS int,  
 @p_SAPUSER nvarchar(12),  
 @p_IMIE_NAZWISKO nvarchar(80),  
 @p_ZMT_ROWID int,  
 @p_OBSZAR nvarchar(30) = null,  
 @p_COSTCODEID int,    
 @p_NR_SZKODY nvarchar(30), 
 @p_POTID int, 
 @p_UserID nvarchar(30) = NULL, -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
 declare @v_errorid int  
 declare @v_errortext nvarchar(4000)   
 select @v_errorid = 0  
 select @v_errortext = null  
  
 begin transaction  
   
 exec @v_errorid = [dbo].[ZWFOT42_Update_Proc]   
   @p_FormID,  
   @p_ROWID,  
   @p_CODE,   
   @p_ID,  
   @p_ORG,  
   @p_RSTATUS,  
   @p_STATUS,  
   @p_STATUS_old,  
   @p_TYPE,  
   @p_KROK,  
   @p_BUKRS,  
   @p_UZASADNIENIE,  
   @p_KOSZT,  
   @p_SZAC_WART_ODZYSKU,  
   @p_SPOSOBLIKW,   
   @p_PSP_POSKI,  
   @p_ROK,  
   @p_MIESIAC,  
   @p_CZY_UCHWALA,  
   @p_CZY_DECYZJA,  
   @p_CZY_ZAKRES,  
   @p_CZY_OCENA,  
   @p_CZY_EKSPERTYZY,  
   @p_UCHWALA_OPIS,  
   @p_DECYZJA_OPIS,  
   @p_ZAKRES_OPIS,  
   @p_OCENA_OPIS,  
   @p_EKSPERTYZY_OPIS,  
   @p_IF_EQUNR,  
   @p_IF_SENTDATE,  
   @p_IF_STATUS,  
   @p_SAPUSER,  
   @p_IMIE_NAZWISKO,  
   @p_ZMT_ROWID,  
   @p_OBSZAR,
   @p_COSTCODEID,  
   @p_NR_SZKODY,
   @p_POTID,
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