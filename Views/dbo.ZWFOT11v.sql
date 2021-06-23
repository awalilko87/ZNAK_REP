SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT11v]          
as          
SELECT           
 [OT11_ROWID]          
 ,[OT11_KROK]          
 ,[OT11_BUKRS]          
 ,[OT11_IMIE_NAZWISKO]          
 ,[OT11_TYP_SKLADNIKA]          
 ,[OT11_CZY_BUD]          
 ,[OT11_SERNR]          
 ,[OT11_SERNR_POSKI]          
 ,[OT11_POSNR]          
 ,[OT11_POSNR_POSKI]          
 ,[OT11_ANLN1_INW]          
 ,[OT11_ANLN1_INW_POSKI]          
 ,[OT11_ANLN1]          
 ,[OT11_ANLN1_POSKI]          
 ,[OT11_INVNR_NAZWA]          
 ,[OT11_CZY_FUND]          
 ,[OT11_CZY_SKL_POZW]          
 ,[OT11_CZY_POZWOL]          
 ,[OT11_CZY_PLAN_POZW]          
 ,[OT11_CZY_WYD_POZW]          
 ,[OT11_CZY_NIEMAT]          
 ,[OT11_HERST]          
 ,[OT11_HERST_POSKI]          
 ,[OT11_LAND1]          
 ,[OT11_KOSTL]          
 ,[OT11_KOSTL_POSKI]          
 ,[OT11_GDLGRP]          
 ,[OT11_GDLGRP_POSKI]          
 ,[OT11_MUZYTKID]          
 ,[OT11_MUZYTK]          
 ,[OT11_NAZWA_DOK]          
 ,[OT11_NUMER_DOK]          
 ,[OT11_DATA_DOK]          
 ,[OT11_WART_NAB_PLN]          
 ,[OT11_PRZEW_OKRES]          
 ,[OT11_WOJEWODZTWO]          
 ,[OT11_WOJEWODZTWO_DESC] = (select [DESC] from VOIVODESHIPv where code = [OT11_WOJEWODZTWO])        
 ,[OT11_BRANZA]          
 ,[OT11_ANLKL]          
 ,[OT11_ANLKL_POSKI]          
 ,[OT11_CZY_BUDOWLA]          
 ,[OT11_IF_STATUS]          
 ,[OT11_IF_SENTDATE]           
 ,[OT11_IF_EQUNR] = cast(isnull([OT11_IF_EQUNR],'Brak w SAP') as nvarchar(30))          
 ,[OT11_IF_EQUNR_ALL] =           
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot11.[OT11_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))           
  FROM [SAPO_ZWFOT11] sub_ot11 (nolock) where [ZWFOT].OT_ROWID = sub_ot11.[OT11_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')          
 ,[OT11_ZMT_ROWID]          
 ,[OT11_SAPUSER]          
 ,[OT11_MIES_DOST]          
 ,[OT11_ROK_DOST]          
 ,[OT11_DATA_DOST] = convert(datetime,cast([OT11_ROK_DOST]as nvarchar) + '-' + cast( [OT11_MIES_DOST] as nvarchar) + '-01')          
 ,[ZMT_OBJ_CODE] --tylko dla konkretnego dokuemntu w SAP          
 ,[OT11_PODZ_USL_P]          
 ,[OT11_PODZ_USL_S]          
 ,[OT11_PODZ_USL_B]          
 ,[OT11_PODZ_USL_C]          
 ,[OT11_PODZ_USL_U]          
 ,[OT11_PODZ_USL_H]          
 ,case           
  when ([OT11_CHAR] is null or [OT11_CHAR] = '') then           
   (select top 1 [STS_NOTE] from dbo.STENCIL          
    left join [dbo].[OBJ] (nolock)          
    on OT_ROWID = OBJ_OTID          
   where OT_ROWID = OBJ_OTID)          
  else [OT11_CHAR]          
  end [OT11_CHAR]          
 --dane nagłówka          
 ,[OT_ROWID]          
 ,[OT_PSPID]          
 ,[OT_PSP] = [PSP_CODE]          
 ,[OT_PSP_DESC] = [PSP_DESC]          
 ,[OT_ITSID]          
 ,[OT_ITS] = [ITS_CODE]          
 ,[OT_ITS_DESC] = [ITS_DESC]          
          
 --,[OT_OBJ] = [OBJ_CODE]          
 --,[OT_OBJ_DESC] = [OBJ_DESC]          
 ,[OT_CODE]          
 ,[OT_ORG]          
 ,[OT_STATUS]          
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT11')          
 ,[OT_TYPE]          
 ,[OT_RSTATUS]          
 ,[OT11_RSTATUS] = [OT_RSTATUS]          
 ,[OT_ID]          
 ,[OT_CREUSER]          
 ,[OT_CREUSER_DESC] = dbo.UserName([OT_CREUSER])          
 ,[OT_CREDATE]          
 ,[OT_UPDUSER]          
 ,[OT_UPDUSER_DESC] = dbo.UserName([OT_UPDUSER])          
 ,[OT_UPDDATE]          
 ,[OT11_WART_FUND]          
 ,[OT11_ZZ_PLAN_DAT_DEC]          
 ,[OT11_ZZ_PLAN_DATA_ZGL]          
 ,[OT11_ZZ_DATA_WYD_DEC]          
 ,[OT11_ZZ_DATA_UPRA_DEC]          
 ,[OT11_ZZ_DATA_ZGL]          
 ,[OT11_ZZ_DATA_UPRA_ZGL]          
 ,[OT11_CZY_BEZ_ZM]          
 ,[OT11_CZY_ROZ_OKR]      
 ,[OT11_UDF01] -- Gwarancja      
 ,[OT11_UDF02] -- Ilość miesięcy 
 ,[OT11_UDF03] -- Data do wskazania (PKNTA-17)
 ,[OT11_RECEIVE_DATE] -- Data odbioru zadania inwestycyjnego (PKTA-17)
 ,[OT11_INSTALL_DATE] -- Data montażu (PKTA-17)
 ,[OT11_INVOICE_DATE] -- Data zakupu (PKTA-17)
 ,[OT11_AKT_OKR_AMORT] -- Aktualny pozostały okres amortyzacji
 ,[OT11_ATTACH_ICO]   = case when exists (select 1  from dbo.SYFiles (nolock)          
						inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT          
						where dae_entity = 'OT11' and OT_CODE+'#'+OT_ORG = DAE_CODE) then 1 else 0 end  
 ,[OT11_NETVALUE]
 ,[OT11_ACTVALUEDATE]
 ,OBJ_CANCELLED_OT_DOC
 ,OBJ_CANCELLED_OT_DOC_PERSON
       
FROM  SAPO_ZWFOT11 
LEFT JOIN ZWFOT ON OT_ROWID = OT11_ZMT_ROWID
LEFT JOIN dbo.INVTSK ON ITS_ROWID = OT_INOID
LEFT JOIN obj ON ITS_ROWID = OBJ_INOID    
left join [dbo].[PSP] (nolock) on PSP_ROWID = OT_PSPID       
where           
 [OT11_IF_STATUS] <> 4          
 and [OT_TYPE] = 'SAPO_ZWFOT11' 

GO