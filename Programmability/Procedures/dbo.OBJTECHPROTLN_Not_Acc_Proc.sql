SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
  
CREATE procedure [dbo].[OBJTECHPROTLN_Not_Acc_Proc] (  
 @POT_ROWID int  
)  
as  
begin  
     
INSERT INTO [dbo].[MAILBOX]  
           ([MAIB_RECEIVER]  
           ,[MAIB_USER]  
           ,[MAIB_ORG]  
           ,[MAIB_SUBJECT]  
           ,[MAIB_BODY]  
           ,[MAIB_ENT]  
           ,[MAIB_TYPE]  
           ,[MAIB_STATUS]  
           ,[MAIB_ISSEND]  
           ,[MAIB_SENDTIME]  
           ,[MAIB_CREATED]  
           ,[MAIB_NROFRETRY]  
           ,[MAIB_NRDOC]  
           ,[MAIB_MAISID]  
           ,[MAIB_QUERY]  
           ,[MAIB_MGTYPE]  
           ,[MAIB_DW]  
           ,[MAIB_REPORTNAME]  
           ,[MAIB_REPORTPARAMS]  
           ,[MAIB_ATTACHNAME]  
           ,[MAIB_ATTACH]  
           ,[MAIB_STATUS_IM]  
)   
SELECT DISTINCT  
   Email  
   , POT_MANAGER  
   , ''  
   , POT_CODE + ': składniki nieprzyjęte przez PS'  
   ,'<pre><table><tr><td>W PZO nr: <b>' + POT_CODE + '</b> nie wszystkie składniki zostały przyjęte przez PS.</td></tr>  
   <tr><td>Zadanie inwestycyjne:' + POT_PSP_POSKI + ': ' + ITS_DESC + '</td></tr></table>  
   </br><table border="1">  
 <caption>Składniki nieprzyjęte</caption>  
 <tr bgcolor="#D3D3D3">  
  <th>Kod składnika</th>  
  <th>Nazwa składnika</th>  
 </tr>'  
 + cast(  
  (select cast((select OBJ_CODE as 'td' for xml path('')) as xml)  
   , cast((select OBJ_DESC as 'td' for xml path('')) as xml)  
  from OBJTECHPROT  
  join OBJTECHPROTLN on POT_ROWID = POL_POTID  
  join OBJ on POL_OBJID = OBJ_ROWID  
  where POT_ROWID = @POT_ROWID  
  --and POT_STATUS = 'PZO_002'  
  and POL_STATUS = 'PZL_002'  
  ORDER BY OBJ_CODE  
  FOR XML PATH('tr') )  
  as nvarchar(max)  
 )  
 + '  
 </table>  
  
 <a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'/Tabs3.aspx/?MID=VISION_VISIONADMIN&TGR=PZO_ODB&TAB=PZOLN_LSRC_ODB&FID=PZOLN_LSRC_ODB' + '&QSC=R09UT1R
BQiAyOw==&DW=' + 'POT_ROWID=' + cast(@POT_ROWID as nvarchar(20)))) + '">LINK</a>  
  
 _______________________________________________  
 Wiadomość została wygenerowana automatycznie.  
 Prosimy na nią nie odpowiadać.  
 </pre>'  
   , ''  
   , ''  
   , ''  
   , 0  
   , null  
   , getdate()  
   , 0  
   , ''  
   , (select top 1 MAILSETTINGS.ROWID  
    from MAILSETTINGS  
    join MAILPROFILES on MAIS_MAIPID = MAILPROFILES.ROWID  
   )  
   , null  
   , 'NIE'  
   , null  
   , null  
   , null  
   , null  
   , null  
   , null  
from OBJTECHPROT  
join INVTSK on ITS_CODE = POT_PSP_POSKI  
join SYUsers on POT_MANAGER = UserID  
where POT_ROWID = @POT_ROWID  
--and POT_STATUS ='PZO_002'  
and isnull(Email,'') <> ''  
and exists (select 1  
 from OBJTECHPROT  
 join OBJTECHPROTLN on POT_ROWID = POL_POTID  
 join OBJ on POL_OBJID = OBJ_ROWID  
 where POT_ROWID = @POT_ROWID  
 --and POT_STATUS in ('PZO_003','PZO_004')  
 and POL_STATUS = 'PZL_002'  
)  
  
end  
GO