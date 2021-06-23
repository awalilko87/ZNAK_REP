SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SP_REQUEST_DOCv]  
as   
select   
 SRQ_ROWID  
 , SRQ_CODE  
 , SRQ_ORG  
 , SRQ_DESC  
 , SRQ_DATE  
 , SRQ_TIME = (dbo.e2_im_gettimefromdatetime(isnull(SRQ_DATE,'1900-01-01')))  
 , SRQ_STATUS  
 , SRQ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = SRQ_STATUS and STA_ENTITY = 'SRQ')  
 , SRQ_ICONSTATUS =  dbo.[GetStatusImage] ('SRQ', SRQ_STATUS)     
 , SRQ_TYPE   
 , SRQ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = SRQ_TYPE and TYP_ENTITY = 'SRQ')  
 , SRQ_TYPE2  
 , SRQ_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = SRQ_TYPE and TYP_ENTITY = 'SRQ')  
 , SRQ_TYPE3  
 , SRQ_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = SRQ_TYPE and TYP_ENTITY = 'SRQ')  
 , SRQ_RSTATUS  
 , SRQ_CREUSER  
 , SRQ_CREUSER_DESC = dbo.UserName(SRQ_CREUSER)  
 , SRQ_CREDATE  
 , SRQ_UPDUSER  
 , SRQ_UPDUSER_DESC = dbo.UserName(SRQ_UPDUSER)  
 , SRQ_UPDDATE  
 , SRQ_NOTUSED  
 , SRQ_ID  
 , SRQ_OBJID  
 , SRQ_OBJ = OBJ_CODE  
 , SRQ_OBJ_DESC = OBJ_DESC  
 , SRQ_STNID_FROM  
 , SRQ_STN_FROM = stn_from.STN_CODE  
 , SRQ_STN_FROM_DESC = stn_from.STN_DESC  
 , SRQ_KL5ID_FROM  
 , SRQ_KL5_FROM = kl5_from.KL5_CODE  
 , SRQ_KL5_FROM_DESC = kl5_from.KL5_DESC  
 , SRQ_STNID_TO  
 , SRQ_STN_TO = stn_to.STN_CODE  
 , SRQ_STN_TO_DESC = stn_to.STN_DESC  
 , SRQ_KL5ID_TO  
 , SRQ_KL5_TO = kl5_to.KL5_CODE  
 , SRQ_KL5_TO_DESC = kl5_to.KL5_DESC  
 , SRQ_REPLACEMENT  
 , SRQ_ACCUSER  
 , SRQ_ACCUSER_DESC = (select username from Syusers (nolock) where UserID = SRQ_ACCUSER)  
 , SRQ_ACCDATE  
 , SP_REQUEST_LINK =   
  --case   
  --when SRQ_STATUS IN ('SRQ_001') then  
   '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=SP_REQUEST_LS&FID=SP_REQUEST_DOK&A=BTC_POSTBACK&FLD=SP_REQUEST_E&SRQ_ROWID=' + cast(SRQ_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"   
   title="Wyświetl szczegóły zgłoszenia"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="32" height="32"/></a>'  
  --when SRQ_STATUS IN ('SRQ_002' , 'SRQ_003') then  
  --'<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=SP_REQUEST_LS&FID=SP_REQUEST_DOK&A=BTC_POSTBACK&FLD=SP_REQUEST_E&SRQ_ROWID=' + cast(SRQ_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"   
  --title="Wyświetl szczegóły zgłoszenia"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="32" height="32"/></a>'  
  --else ''  
  --end   
    
 ,SRQ_ASSET = AST_CODE+' - '+ AST_SUBCODE  
 ,SRQ_ASTDESC = AST_DESC 
 ,SRQ_OT31ID
 ,SRQ_OT32ID
 ,SRQ_OT33ID
 ,SRQ_OT41ID
 ,SRQ_OT42ID 
from dbo.SP_REQUEST (nolock)  
inner join dbo.OBJ (nolock) o on o.OBJ_ROWID = SRQ_OBJID  
left join dbo.STATION (nolock) stn_from on stn_from.STN_ROWID = SRQ_STNID_FROM  
left join dbo.STATION (nolock) stn_to on stn_to.STN_ROWID = SRQ_STNID_TO  
left join dbo.KLASYFIKATOR5 (nolock) kl5_from on kl5_from.KL5_ROWID = SRQ_KL5ID_FROM  
left join dbo.KLASYFIKATOR5 (nolock) kl5_to on kl5_to.KL5_ROWID = SRQ_KL5ID_TO  
left join dbo.ZWFOTv (nolock) on /*OT_PSPID = PSP_ROWID and OT_ITSID = ITS_ROWID and*/ SRQ_ROWID = OT_SRQID  
outer apply (select top 1 AST_CODE, AST_SUBCODE, AST_DESC from dbo.ASSET inner join dbo.OBJASSET on OBA_ASTID = AST_ROWID and OBA_OBJID = OBJ_ROWID order by AST_SUBCODE)asset  
--left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID  
GO