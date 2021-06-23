SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[CPO_REPORT_LINESv]  
as
   SELECT
POL_POTID
,POL_LP
,POL_OBJ
,POL_OBJDESC
,POL_ASSET
,POL_STATUS_DESC
,POL_STAT
,POL_BIZ_DEC_DESC=STN_CODE
,POL_PARTIAL
,POL_NTX01
,POL_DTX01
,POL_NOTE 
,IsNull(a.POL_VALUE,0) as POL_VALUE 
,POL_GROUP 
,POL_OBJ_OCEN = (select UserName from SyUsers where UserID = POL_OBJ_OCENIAJACY)
,STN_CODE 
,POL_PARTIAL_NETTO
FROM(
SELECT    
POL_POTID   
,POL_LP = (row_number() over(partition by POL_POTID,POL_STATUS,GroupID order by O.OBJ_CODE,PARENT.OBJ_CODE))         
,POL_OBJ = o.OBJ_CODE  
,POL_OBJDESC = o.OBJ_DESC 
,POL_ASSET = (select Stuff((select '; ' + AST_CODE + ' - '+ AST_SUBCODE +':'+AST_DESC     
 from dbo.ASSET (nolock)    
 join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID    
 where OBA_OBJID = O.OBJ_ROWID    
 and AST_NOTUSED = 0    
 order by AST_SUBCODE    
 for xml path ('')    
 ),1,2,N''))    
,  POL_STATUS_DESC = case POL_STATUS when 'CPOLN_002' then 'Składniki przeznaczone do likwidacji poprzez utylizację'
									 when 'CPOLN_003' then 'Składniki przeznaczone do zagospodarowania'
									 when 'CPOLN_004' then 'Składniki przeznaczone do pozostawienia na stacji'
									 when 'CPOLN_005' then 'Składniki przeznaczone do przeniesienia na inną stację'
									 when 'CPOLN_006' then 'Składniki przeznaczone do tymczasowego demontażu'
									 when 'CPOLN_007' then 'Składniki zablokowane'
									 when 'CPOLN_008' then 'Składniki przeznaczone do likwidacji poprzez odprzedaż'
					end
,POL_STAT = (select STA_DESC from STA sta where sta.STA_CODE = POL_STATUS) 
,POL_BIZ_DEC_DESC = case when POL_BIZ_DEC = 0 then 'Nie' else 'Tak' end  
,POL_PARTIAL = case when POL_PARTIAL=0 then 100 else  IsNull(POL_PARTIAL,100)   end
,POL_NTX01=(select AST_NETVALUE from dbo.ASSET(nolock) where AST_ROWID = oba.OBA_ASTID)/*wartość netto*/  
,POL_DTX01  
,POL_NOTE  
,POL_GROUP = GroupID  ,POL_VALUE = (select cast( (case when AST_CODE like '3%' then AST_SAP_URWRT else  AST_INITIALVALUE end ) as numeric(30,6)) from dbo.ASSET (nolock) where AST_ROWID = oba.OBA_ASTID) --o.OBJ_VALUE  /*Wartość początkowa SAP*/
,POL_OBJ_OCENIAJACY =  (case when GroupID = 'DZR' then CHK_GU_DZR_USER  
							when GroupID = 'IT' then CHK_GU_IT_USER  
							when GroupID = 'RKB' then CHK_GU_RKB_USER  
							when GroupID = 'UR' then CHK_GU_UR_USER  
						end  
						)
,STN_CODE 
,POL_PARTIAL_NETTO=(case when POL_PARTIAL=0 then 100 else  IsNull(POL_PARTIAL,100)   end) * (select AST_NETVALUE from dbo.ASSET(nolock) where AST_ROWID = oba.OBA_ASTID)/100
from [dbo].[OBJTECHPROTLN](nolock)    
inner join [dbo].[OBJTECHPROT](nolock) on POT_ROWID = POL_POTID    
inner join [dbo].[OBJ](nolock) O on O.OBJ_ROWID = POL_OBJID    
left join [dbo].[OBJASSET](nolock) OBA on OBA.OBA_OBJID = O.OBJ_ROWID    
left join dbo.OBJGROUP_RESPONv on OBG_ROWID = OBJ_GROUPID                
inner join [dbo].[OBJ](nolock) PARENT on PARENT.OBJ_ROWID = O.OBJ_PARENTID    
left join [dbo].[STA] on STA_CODE = o.OBJ_STATUS 
 left join [dbo].[OBJSTATION] (nolock) on OSA_OBJID = O.OBJ_ROWID                                              
 left join [dbo].[STATION] (nolock) STN_FROM on STN_FROM.STN_ROWID = OSA_STNID  
where pol_status ='CPOLN_002'   
)A

GO