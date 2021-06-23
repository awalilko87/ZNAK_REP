SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[POT_CHANGE_PERSON_MAIL](

@p_POT_ID int
,@p_UserID nvarchar(30)
,@p_GroupPerm nvarchar(10)
,@p_Comment nvarchar(max)
)
as
begin

/*Wysyłka poiwadomiania mailowego, do realizatora POT o odrzuceniau możliwości akceptacji składników*/
	declare @UserDesc nvarchar(80)
	declare @realizator nvarchar(30)
	declare @realizator_mail nvarchar(50)
	select @realizator = POT_CREUSER from OBJTECHPROT where POT_ROWID = @p_POT_ID
	select @realizator_mail = Email from SyUsers where UserID = @realizator
	select @UserDesc = UserName from SyUsers where UserID = @p_UserID
	  
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
           ,[MAIB_STATUS_IM])   

SELECT DISTINCT  
   Email  
   , UserID  
   , POT_ORG  
   , 'Protokół: ' + POT_CODE  + ' - odrzucenie wskazania do akceptacji'
   , '<pre>W protokole Oceny Technicznej nr: <b>' + POT_CODE +' </b> 
    <br>Użytkownik <b>'+ @UserDesc +'</b> z uprawnieniami grupy <b>'+ @p_GroupPerm + '</b> odrzucił wskazanie do akceptacji składników. <br>Powód odrzucenia: '+@p_Comment+
	'.Proszę wskazać innego użytkownika.<br>Link do protokołu: '
	  
+ '<a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'Tabs3.aspx/?MID=ZMT_INVEST&TGR=POT&TAB=POT_LS&FID=POT_LS' + '&QSC=R09UT1RBQiAyOw==&DW=' + 'POT_ROWID=' + convert(varchar,POT_ROWID))) + '">LINK</a>  
 <br>_________________________________________  
<br>Wiadomość została wygenerowana automatycznie.<br>Prosimy na nią nie odpowiadać.  
</pre>' 
   , 'POT'  
   , POT_TYPE  
   , POT_STATUS  
   , 0  
   , null  
   , getdate()  
   , 0  
   , POT_CODE  
   , (select top 1 ROWID  
    from MAILSETTINGS  
    where case MAIS_STATUS  
      when '*' then POT_STATUS  
      else MAIS_STATUS end = POT_STATUS  
    and POT_TYPE = case MAIS_TYPE  
      when '*' then POT_TYPE  
      else MAIS_TYPE end  
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
join SYUsers on UserID = POT_CREUSER
where POT_ROWID =  @p_POT_ID   
and Email is not null  
end 
GO