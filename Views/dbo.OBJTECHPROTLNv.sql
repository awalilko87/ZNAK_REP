SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OBJTECHPROTLNv]                                         
as                                        
SELECT                                         
  POL_ROWID                                        
 ,POL_LP = 0--(row_number() over(partition by POL_POTID order by O.OBJ_CODE,PARENT.OBJ_CODE))                                        
 ,POL_POTID                       
 ,POL_CLOSEDATE = POT_POTCLOSE_DATE -- potencjalna data zamknięcia oceny                                 
 ,POL_TO_STNID                                        
 ,POL_TO_STN = STN_TO.STN_CODE                                         
 ,POL_TO_STN_DESC = case                                        
       when STN_TO.STN_TYPE = 'STACJA' then isnull ( cast (STN_TO.[STN_CODE]  as nvarchar) ,'') + ' - ' + STN_TO.STN_DESC                                        
       when STN_TO.STN_TYPE = 'SERWIS' then 'Serwis: ' + STN_TO.STN_DESC      
    when STN_TO.STN_TYPE = 'BAR' then 'Bar: ' + STN_TO.STN_DESC                                     
      end                                        
 ,POL_FROM_STNID = STN_FROM.STN_ROWID                                        
 ,POL_FROM_STN = STN_FROM.STN_CODE                                        
 ,POL_FROM_STN_DESC = STN_FROM.STN_DESC                       
 ,POL_FROM_STN_CCDID =  STN_FROM.STN_CCDID                      
 ,POL_FROM_STN_CCD = (select CCD_CODE from dbo.COSTCODE (nolock) where CCD_ROWID = STN_FROM.STN_CCDID)                                   
 ,POL_OBJ_PARENTID = PARENT.OBJ_ROWID                                       
 ,POL_OBJ_PARENT = case when O.OBJ_ROWID = PARENT.OBJ_ROWID then '' else PARENT.OBJ_CODE end                                        
 ,POL_OBJ_PARENT_DESC = case when O.OBJ_ROWID = PARENT.OBJ_ROWID then '' else PARENT.OBJ_DESC end                       
 ,POL_OBJ_TYPE = o.OBJ_TYPE                                     
 ,POL_CODE                                        
 ,POL_ORG                                        
 ,POL_DESC                                        
 ,POL_NOTE                                        
 ,POL_DATE                                        
 ,POL_STATUS                                      
 ,POL_STATUS_DESC = (select STA_DESC from STA sta where sta.STA_CODE = POL_STATUS )                               
 ,POL_ICONSTATUS = null --dbo.GetStatusImage ('POL', POL_STATUS)                                        
 ,POL_TYPE                                         
 ,POL_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = POL_TYPE and TYP_ENTITY = 'POL')                                        
 ,POL_TYPE2                                        
 ,POL_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = POL_TYPE and TYP_ENTITY = 'POL')                                        
 ,POL_TYPE3                                        
 ,POL_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = POL_TYPE and TYP_ENTITY = 'POL')                            
 --,case                                         
 -- when POT_STATUS != 'POT_002' then 1                                        
 -- else 0                                         
 --end AS POL_RSTATUS                                        
 ,POT_RSTATUS AS POL_RSTATUS                                        
 ,POL_CREUSER                                        
 ,POL_CREUSER_DESC = dbo.UserName(POL_CREUSER)                                        
 ,POL_CREDATE                                        
 ,POL_UPDUSER                                        
 ,POL_UPDUSER_DESC = dbo.UserName(POL_UPDUSER)                                        
 ,POL_UPDDATE                                        
 ,POL_NOTUSED                                        
 ,POL_ID                
 ,POL_BIZ_DEC              
 ,POL_ADHOC              
 ,POL_ACTIVE_DATE = (select AST_SAP_AKTIV from dbo.ASSET where AST_ROWID = oba.OBA_ASTID)   -- data aktywacji składnika              
 ,POL_TXT01,POL_TXT02,POL_TXT03,POL_TXT04,POL_TXT05                           
 ,POL_TXT06,POL_TXT07,POL_TXT08,POL_TXT09             
 ,POL_NTX01/*wartość netto*/,POL_NTX02,POL_NTX03,POL_NTX04,POL_NTX05                             
 ,POL_COM01,POL_COM02                                        
 ,POL_DTX01,POL_DTX02,POL_DTX03,POL_DTX04,POL_DTX05                                        
 ,POL_OLDQTY                                        
 ,POL_NEWQTY                   
 ,POL_DIFF = POL_NEWQTY - isnull(POL_OLDQTY, 0)                                        
 ,POL_PRICE = (select cast(AST_SAP_URWRT as numeric(30,6)) from dbo.ASSET where AST_ROWID = oba.OBA_ASTID)     --wartość początkowa                                         
 ,POL_PARTIAL                                        
 ,POL_OBJID = O.OBJ_ROWID                                        
 ,POL_OBJ = case when POL_NTX01 <> 0  then '<span style="color:red; font-weight:bold; ">'+ O.OBJ_CODE +'</span>' else  O.OBJ_CODE end                                         
 ,case                                        
  when (O.OBJ_SERIAL is null or O.OBJ_SERIAL = '') then O.OBJ_DESC                                        
  else O.OBJ_DESC +' ( ' + O.OBJ_SERIAL + ' ) '                                        
 end as POL_OBJDESC                                        
 ,POL_OBGID = O.OBJ_GROUPID                                        
 ,POL_OBG = OBG_CODE  + ' - ' + OBG_DESC                                        
 ,POL_VALUE = O.OBJ_VALUE                                        
 ,POL_ASSET =                                         
  (select  Stuff((select '; ' + AST_CODE + ' - '+ AST_SUBCODE +':'+AST_DESC   from dbo.ASSET (nolock)                                         
    join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID                                         
    where OBA_OBJID = O.OBJ_ROWID                                         
    order by AST_SUBCODE                                        
    for xml path ('')),1,2,N''))                                        
 ,[OT31_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT31_RC&FID=OT31_LN&FLD=OT31_LN_FORM&A=OT31_LN_FORM&OT31ID=' + cast(OT31.OT31_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"                
  title="Wyświetl linie dla dokumentu MT1"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                                        

 ,[OT32_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT32_RC&FID=OT32_LN&FLD=OT32_LN_FORM&A=OT32_LN_FORM&OT32ID=' + cast(OT32.OT32_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"                
  title="Wyświetl linie dla dokumentu MT2"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                                        
 --,[OT33_LINES_LINK] = '<a href="javascript:Simple_Popup(''' + '/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_LN_POT&FLD=OT33_LN_FORM&A=OT33_LN_FORM&OT33ID=' + cast(POL_OT33ID as nvarchar(50)) + ''',''mywindowtitle'')"                                    
 -- title="Wyświetl linie dla dokumentu MT3"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                                        
 ,[OT33_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_LN&FLD=OT33_LN_FORM&A=OT33_LN_FORM&OT33ID=' + cast(OT33.OT33_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"                
  title="Wyświetl linie dla dokumentu MT3"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                                        

 ,[OT41_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT41_RC&FID=OT41_LN&FLD=OT41_LN_FORM&A=OT41_LN_FORM&OT41ID=' + cast(OT41.OT41_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"                
  title="Wyświetl linie dla dokumentu LTW"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                                        

 ,[OT42_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT42_RC&FID=OT42_LN&FLD=OT42_LN_FORM&A=OT42_LN_FORM&OT42ID=' + cast(OT42.OT42_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"                
  title="Wyświetl linie dla dokumentu PL '+cast(POL_OT42ID as nvarchar(50))+'"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'                
 --,[OT42_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)                                        
 
 ,POL_COMMENT_ADD = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=POL_RC&FID=COMMENTS&FLD=COMMENTS&ENTITY=POL&CODE=' + cast(POL_ID as nvarchar(50))) + ''',''mywindowtitle'')"                                     
  title="Wyświetl linie dla dokumentu PL '+cast(POL_ROWID as nvarchar(50))+'"><img src="/Images/16x16/COMMENTS.png" border="none" type="image" width="16" height="16"/></a>'                                        
 ,OT31ID = (select OT_CODE from ZWFOT where OT_ROWID = POL_OT31ID and OT_TYPE = 'SAPO_ZWFOT31')                                
 ,OT32ID = (select OT_CODE from ZWFOT where OT_ROWID = POL_OT32ID and OT_TYPE = 'SAPO_ZWFOT32')                               
 ,OT33ID = (select OT_CODE from ZWFOT where OT_ROWID = POL_OT33ID and OT_TYPE = 'SAPO_ZWFOT33')                                
 ,OT41ID = (select OT_CODE from ZWFOT where OT_ROWID = POL_OT41ID and OT_TYPE = 'SAPO_ZWFOT41')                                 
 ,OT42ID = (select OT_CODE from ZWFOT where OT_ROWID = POL_OT42ID and OT_TYPE = 'SAPO_ZWFOT42')                                     
 ,STS_DEFAULT_KST                                
 ,STS_SETTYPE             
 ,STS_SETTYPEDESC = (select STT_DESC from  SETTYPE (nolock) where STT_CODE = STS_SETTYPE)                         
 ,o.OBJ_STSID            
 ,POL_OBJSTATUS = '<span style="color:'+case when o.OBJ_STATUS = 'OBJ_010' then 'red' else 'black' end+';">'+STA_DESC+'</span><br>'                             
 ,STS_CODE = STS_CODE+' - '+STS_DESC          
 ,POT_POTCLOSE_DATE  -- potencjalna data zamknięcia oceny  
 ,POL_LIKW_TYPE  -- typ likwidacji (techniczna/biznesowa)  
 ,POL_LIKW_ADHOC -- likwidacja Adhoc  
 ,POL_TECHDEC_TYPE -- typ decyzji technicznej   
 ,POL_WIEK -- kryterium wieku  
 ,POL_PRZEBIEG -- kryterium przebiegu  
 ,POL_TECHDEC_DESC -- opis decyzji technicznej  
 ,POL_ATTACH  -- załączniki  
 ,POL_UMO_WART -- wartość umorzenia
 ,POL_MIN_ODSP = (select cast(AST_SAP_URWRT as numeric(30,6))* 0.25 from dbo.ASSET where AST_ROWID = oba.OBA_ASTID)   -- minimalna wartośc odsprzedaży
 ,POL_WART_ODSP -- faktyczna wartość odsprzedaży
 ,POL_ZARZ_BIZ -- zarządzenie biznesowe (TAK/NIE)        
from [dbo].[OBJTECHPROTLN](nolock)                                        
 inner join [dbo].[OBJTECHPROT](nolock) on POT_ROWID = POL_POTID                                        
 inner join [dbo].[OBJ](nolock) O on O.OBJ_ROWID = POL_OBJID               
 left join [dbo].[OBJASSET](nolock) OBA on OBA.OBA_OBJID = O.OBJ_ROWID                        
 left join [SAPO_ZWFOT31] OT31 (nolock) on OT31.OT31_ZMT_ROWID = POL_OT31ID                          
 left join [SAPO_ZWFOT32] OT32 (nolock) on OT32.OT32_ZMT_ROWID = POL_OT32ID                           
 left join [SAPO_ZWFOT33] OT33 (nolock) on OT33.OT33_ZMT_ROWID = POL_OT33ID                          
 left join [SAPO_ZWFOT41] OT41 (nolock) on OT41.OT41_ZMT_ROWID = POL_OT41ID                          
 left join [SAPO_ZWFOT42] OT42 (nolock) on OT42.OT42_ZMT_ROWID = POL_OT42ID                          
 left join STENCIL on o.OBJ_STSID = STS_ROWID                                       
 left join [dbo].[OBJGROUP] (nolock) on  OBG_ROWID = O.OBJ_GROUPID                                        
 inner join [dbo].[OBJ](nolock) PARENT on PARENT.OBJ_ROWID = O.OBJ_PARENTID                                        
 left join [dbo].[OBJSTATION] (nolock) on OSA_OBJID = O.OBJ_ROWID                                        
 left join [dbo].[STATION] (nolock) STN_FROM on STN_FROM.STN_ROWID = OSA_STNID                             
 left join [dbo].[STATION] (nolock) STN_TO on STN_TO.STN_ROWID = POL_TO_STNID      
 left join [dbo].[STA] on STA_CODE = o.OBJ_STATUS   
GO