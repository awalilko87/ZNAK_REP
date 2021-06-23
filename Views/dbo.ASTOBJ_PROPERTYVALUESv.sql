SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASTOBJ_PROPERTYVALUESv]      
as      
select       
 PRV_ROWID,       
 PRV_OBJID = OBJ_ROWID,      
 PRV_OBJ = OBJ_CODE,      
 PRV_OBJDESC = OBJ_DESC  + ' ' + cast( DENSE_RANK () OVER(PARTITION BY  OBJ_STSID, isnull(OBJ_PSPID,OBJ_ANOID) ORDER BY OBJ_ROWID DESC) as nvarchar(5)),      
 PRV_OBJ_INOID = OBJ_INOID,      
       
 --gdy pochodzi z PSP      
 PRV_PSPID = OBJ_PSPID,       
 PRV_PSP = PSP_CODE,      
 PRV_PSPDESC = PSP_DESC,      
       
 --gdy pochodzi z inwentury      
 PRV_ANOID = OBJ_ANOID,      
 PRV_ANO = ANO_CODE,      
 PRV_ANODESC = ANO_DESC,      
      
 --gdy pochodzi z zadania      
 PRV_INOID = OBJ_INOID,      
 PRV_INO = INO_CODE,      
 PRV_INODESC = INO_DESC,      
       
 PRV_STSID = STS_ROWID,      
 PRV_ASPID = ASP_ROWID,      
 PRV_PROID = PRO_ROWID,      
 PRV_UOMID = ASP_UOMID,       
 PRV_ENT,      
 PRV_PROPERTY = PRO_CODE,      
 PRV_FIELDID = ASP_ENT + '_' + PRO_CODE,      
 PRV_PROTYPE = PRO_TYPE,      
 PRV_PROTEXT = PRO_TEXT,      
 --PRV_VALUE,      
 --PRV_NVALUE,      
 --PRV_DVALUE,      
 PRV_VALUE_LIST =       
  case       
   when PRO_TYPE = 'DDL' then CAST ((PRV_VALUE) as nvarchar)      
   when PRO_TYPE = 'TXT' then CAST ((PRV_VALUE) as nvarchar)      
   when PRO_TYPE = 'NTX' then CAST ((cast(PRV_NVALUE as numeric(10,2))) as nvarchar)      
   when PRO_TYPE = 'DTX' then convert (nvarchar(10),(PRV_DVALUE),121)      
  end,      
 PRV_UOM = UOM_CODE,      
 PRV_PM_KLASA = PRO_PM_KLASA,      
 PRV_PM_CECHA = PRO_PM_CECHA      
from OBJ (nolock)      
 join STENCIL S (nolock) on STS_ROWID = OBJ_STSID        
 join ADDSTSPROPERTIES A (nolock) on ASP_STSID = STS_ROWID      
 join PROPERTIES P (nolock) on A.ASP_PROID = P.PRO_ROWID       
 left join PSP PS (nolock) on PSP_ROWID = OBJ_PSPID      
 left join ASTINW_NEW_OBJ ANO (nolock) on ANO_ROWID = OBJ_ANOID      
 left join INVTSK_NEW_OBJ INO (nolock) on INO_ROWID = OBJ_INOID      
 left join UOM U (nolock) on UOM_ROWID = ASP_UOMID      
 left join PROPERTYVALUES PV (nolock) on PRV_PROID = PRO_ROWID and PRV_PKID = OBJ_ROWID and isnull(PV.PRV_NOTUSED,0) = 0      
where isnull(P.PRO_NOTUSED,0) <> 1 
GO