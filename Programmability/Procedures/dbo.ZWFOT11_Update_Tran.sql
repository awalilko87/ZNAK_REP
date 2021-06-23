SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT11_Update_Tran]    
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
 @p_ANLKL_POSKI nvarchar(8),    
 @p_ANLN1_POSKI nvarchar(12),    
 @p_ANLN1_INW_POSKI nvarchar(12),    
 @p_BRANZA nvarchar(10),    
 @p_BUKRS nvarchar(30),    
 @p_CZY_BUD nvarchar(1),    
 @p_CZY_BUDOWLA nvarchar(1),    
 @p_CZY_FUND nvarchar(1),    
 @p_CZY_NIEMAT nvarchar(1),    
 @p_CZY_SKL_POZW nvarchar(1),    
 @p_DATA_DOK datetime,    
 @p_DATA_DOST datetime,    
 @p_GDLGRP_POSKI nvarchar(30),    
 @p_HERST_POSKI nvarchar(30),    
 @p_IF_EQUNR nvarchar(30),    
 @p_IF_SENTDATE datetime,    
 @p_IF_STATUS int,    
 @p_IMIE_NAZWISKO nvarchar(80),    
 @p_INVNR_NAZWA nvarchar(50),    
 @p_KOSTL_POSKI nvarchar(30),    
 @p_KROK nvarchar(10),    
 @p_LAND1 nvarchar(3),    
 @p_MIES_DOST int,    
 @p_MUZYTKID int,    
 @p_MUZYTK nvarchar(30),    
 @p_NAZWA_DOK nvarchar(1),    
 @p_NUMER_DOK nvarchar(15),    
 @p_POSNR_POSKI nvarchar(30),    
 @p_PRZEW_OKRES int,    
 @p_ROK_DOST int,    
 @p_SAPUSER nvarchar(12),    
 @p_SERNR_POSKI nvarchar(30),    
 @p_TYP_SKLADNIKA nvarchar(1),    
 @p_WART_NAB_PLN numeric(30,2),    
 @p_WOJEWODZTWO nvarchar(12),    
 @p_PODZ_USL_P int,    
 @p_PODZ_USL_S int,    
 @p_PODZ_USL_B int,    
 @p_PODZ_USL_C int,    
 @p_PODZ_USL_U int,    
 @p_PODZ_USL_H int,    
 @p_CHAR nvarchar(max),    
 @p_ZMT_ROWID int,    
 @p_OT11_CZY_BEZ_ZM nvarchar(1),    
 @p_OT11_CZY_PLAN_POZW nvarchar(1),    
 @p_OT11_CZY_POZWOL nvarchar(1),    
 @p_OT11_CZY_ROZ_OKR nvarchar(1),    
 @p_OT11_CZY_WYD_POZW nvarchar(1),    
 @p_OT11_WART_FUND numeric(30,2),    
 @p_OT11_ZZ_DATA_UPRA_DEC datetime,    
 @p_OT11_ZZ_DATA_UPRA_ZGL datetime,    
 @p_OT11_ZZ_DATA_WYD_DEC datetime,    
 @p_OT11_ZZ_DATA_ZGL datetime,    
 @p_OT11_ZZ_PLAN_DAT_DEC datetime,    
 @p_OT11_ZZ_PLAN_DATA_ZGL datetime,    
     
 @p_ZMT_OBJ_CODE nvarchar(30),    
 @p_INOID int,    
 @p_OBJKEYS nvarchar(max),    
 @p_UDF01 nvarchar(100),  
 @p_UDF02 nvarchar(100),  
 @p_UDF03 nvarchar(100),  
 --@p_OT11_RECEIVE_DATE datetime,  
 --@p_OT11_INSTALL_DATE datetime,  
 --@p_OT11_INVOICE_DATE datetime,
 @p_OT11_AKT_OKR_AMORT int,  
 @p_NETVALUE numeric(16,2),
 @p_ACTVALUEDATE datetime,
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
     
 exec     
  @v_errorid = [dbo].[ZWFOT11_Update_Proc]     
      
   @p_FormID,     
   @p_ROWID,    
   @p_CODE,     
   @p_ID,    
   @p_ORG,    
   @p_RSTATUS,    
   @p_STATUS,    
   @p_STATUS_old,    
   @p_TYPE,    
   @p_ANLKL_POSKI,    
   @p_ANLN1_POSKI,    
   @p_ANLN1_INW_POSKI,    
   @p_BRANZA,    
   @p_BUKRS,    
   @p_CZY_BUD,    
   @p_CZY_BUDOWLA,    
   @p_CZY_FUND,    
   @p_CZY_NIEMAT,    
   @p_CZY_SKL_POZW,    
   @p_DATA_DOK,    
   @p_DATA_DOST,    
   @p_GDLGRP_POSKI,    
   @p_HERST_POSKI,    
   @p_IF_EQUNR,    
   @p_IF_SENTDATE,    
   @p_IF_STATUS,    
   @p_IMIE_NAZWISKO,    
   @p_INVNR_NAZWA,    
   @p_KOSTL_POSKI,    
   @p_KROK,    
   @p_LAND1,    
   @p_MIES_DOST,    
   @p_MUZYTKID,    
   @p_MUZYTK,    
   @p_NAZWA_DOK,    
   @p_NUMER_DOK,    
   @p_POSNR_POSKI,    
   @p_PRZEW_OKRES,    
   @p_ROK_DOST,    
   @p_SAPUSER,    
   @p_SERNR_POSKI,    
   @p_TYP_SKLADNIKA,    
   @p_WART_NAB_PLN,    
   @p_WOJEWODZTWO,    
   @p_PODZ_USL_P,    @p_PODZ_USL_S,    @p_PODZ_USL_B,    @p_PODZ_USL_C,    @p_PODZ_USL_U,    @p_PODZ_USL_H,    @p_OT11_CZY_BEZ_ZM,    
   @p_OT11_CZY_PLAN_POZW,    
   @p_OT11_CZY_POZWOL,    
   @p_OT11_CZY_ROZ_OKR,    
   @p_OT11_CZY_WYD_POZW,    
   @p_OT11_WART_FUND,    
   @p_OT11_ZZ_DATA_UPRA_DEC,    
   @p_OT11_ZZ_DATA_UPRA_ZGL,    
   @p_OT11_ZZ_DATA_WYD_DEC,    
   @p_OT11_ZZ_DATA_ZGL,    
   @p_OT11_ZZ_PLAN_DAT_DEC,    
   @p_OT11_ZZ_PLAN_DATA_ZGL,      
   @p_CHAR,    
   @p_ZMT_ROWID,    
   @p_ZMT_OBJ_CODE,    
   @p_INOID,    
   @p_OBJKEYS,  
   @p_UDF01,  
   @p_UDF02,  
 @p_UDF03,    
   --@p_OT11_RECEIVE_DATE,  
   --@p_OT11_INSTALL_DATE,  
   --@p_OT11_INVOICE_DATE,
   @p_OT11_AKT_OKR_AMORT,  
   @p_NETVALUE,
   @p_ACTVALUEDATE,  
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