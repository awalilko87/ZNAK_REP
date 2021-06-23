SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASTOBJ_OTv]          
as    
SELECT    
LP = ROW_NUMBER () OVER (PARTITION BY OT_ROWID ORDER BY OT_CREDATE ),    
 OT_ROWID,            
 OT_CODE,            
 OT_ORG,            
 OT_STATUS,            
 OT_STATUS_DESC = (select STA_DESC from [dbo].[STA] (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = LEFT ([OT_STATUS],4)) ,           
 OT_TYPE,            
 OT_TYPE_DESC = (select TYP_DESC from [dbo].[TYP] (nolock) where TYP_CODE = [OT_TYPE])  ,            
 OT_RSTATUS,            
 OT11_RSTATUS = 0,            
 OT_ID,            
 OT_CREUSER,            
 OT_CREUSER_DESC = dbo.UserName(OT_CREUSER)  ,            
 OT_CREDATE,            
 OT_UPDUSER,            
 OT_UPDUSER_DESC = dbo.UserName(OT_UPDUSER)  ,            
 OT_UPDDATE,            
 OT_ITSID,            
 OT_ITS = ITS_CODE,            
 OT_PSPID,            
 OT_PSP = PSP_CODE,            
 OT_OBJID = OBJ_ROWID,            
 OT_OBJ = OBJ_CODE,    
    
 OT_LINES_LINK =            
  case when OT_TYPE = 'SAPO_ZWFOT11' then            
   '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +            
    '?WHO=INVTSK_NEW_OBJ_LS'+            
    '&FID=OT11_RC'+            
    '&FLD=Btn_AddOT11'+            
    '&A=Btn_AddOT11'+            
    '&OT11ID=' + isnull((select top 1 cast(OT11_ROWID as nvarchar(10)) from SAPO_ZWFOT11 (nolock) where OT11_ZMT_ROWID = OT_ROWID and [OT11_IF_STATUS] <> 4),'') +            
    '&OBJ=' + OBJ_CODE +             
    '&OBJ_DESC=' + OBJ_DESC +             
    '&INOID=' + cast(OBJ_INOID as nvarchar)+            
    '&ITS=' + ITS_CODE +             
    '&PSP=' + PSP_CODE) +             
    '" target="_blank" title="Pokaż OT 11">'            
  when OT_TYPE = 'SAPO_ZWFOT12' then            
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT12_RC&FID=OT12_LN&FLD=OT12_LN_FORM&A=OT12_LN_FORM&OT12ID=' + cast(OT12LN_OT12ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT21' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT21_RC&FID=OT21_LN&FLD=OT21_LN_FORM&A=OT21_LN_FORM&OT21ID=' + cast(OT21LN_OT21ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT31' then             
      '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT31_RC&FID=OT31_LN&FLD=OT31_LN_FORM&A=OT31_LN_FORM&OT31ID=' + cast(OT31LN_OT31ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT32' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT32_RC&FID=OT32_LN&FLD=OT32_LN_FORM&A=OT32_LN_FORM&OT32ID=' + cast(OT32LN_OT32ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT33' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_LN&FLD=OT33_LN_FORM&A=OT33_LN_FORM&OT33ID=' + cast(OT33LN_OT33ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT40' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT40_RC&FID=OT40_LN&FLD=OT40_LN_FORM&A=OT40_LN_FORM&OT40ID=' + cast(OT40LN_OT40ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
  when OT_TYPE = 'SAPO_ZWFOT41' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT41_RC&FID=OT41_LN&FLD=OT41_LN_FORM&A=OT41_LN_FORM&OT41ID=' + cast(OT41LN_OT41ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'         
  when OT_TYPE = 'SAPO_ZWFOT42' then             
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT42_RC&FID=OT42_LN&FLD=OT42_LN_FORM&A=OT42_LN_FORM&OT42ID=' + cast(OT42LN_OT42ID as nvarchar(50))) + ''',''mywindowtitle'')"             
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
             
  else '' end     ,            
    [OT_DON_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_DON&FLD=OT33_DON_FORM&A=OT33_DON_FORM&OT33ID=' + cast(OT33LN_OT33ID as nvarchar(50))) + ''',''mywindowtitle'')"             
  title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'            
              
 FROM [dbo].[OBJ] JOIN  [dbo].[ZWFOTOBJ]  ON OTO_OBJID = OBJ_ROWID     
LEFT JOIN [dbo].[ZWFOT] (nolock) on OT_ROWID = OTO_OTID     
LEFT JOIN [dbo].[PSP] (nolock) on PSP_ROWID = OT_PSPID      
LEFT JOIN [dbo].[INVTSK] (nolock) on ITS_ROWID = OT_ITSID     
LEFT JOIN [dbo].[ZWFOTLN] (nolock) on OTL_OTID = OT_ROWID     
  LEFT join [dbo].[SAPO_ZWFOT12LN] (nolock) on OTL_ROWID = [OT12LN_ZMT_ROWID] AND OT12LN_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT21LN] (nolock) on OTL_ROWID = [OT21LN_ZMT_ROWID] AND OT21LN_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT31LN] (nolock) on OTL_ROWID = [OT31LN_ZMT_ROWID] --AND OTLN31_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT32LN] (nolock) on OTL_ROWID = [OT32LN_ZMT_ROWID] --AND OTLN32_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT33LN] (nolock) on OTL_ROWID = [OT33LN_ZMT_ROWID] --AND OTLN33_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT40LN] (nolock) on OTL_ROWID = [OT40LN_ZMT_ROWID] --AND OTLN40_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT41LN] (nolock) on OTL_ROWID = [OT41LN_ZMT_ROWID] --AND OTLN41_ZMT_OBJ_CODE = OBJ_CODE         
  LEFT join [dbo].[SAPO_ZWFOT42LN] (nolock) on OTL_ROWID = [OT42LN_ZMT_ROWID] --AND OTLN42_ZMT_OBJ_CODE = OBJ_CODE 
GO