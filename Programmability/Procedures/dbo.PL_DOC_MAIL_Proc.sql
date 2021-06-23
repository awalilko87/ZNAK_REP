SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[PL_DOC_MAIL_Proc]  
(  
@plID int  
)as  
begin   
  
 if exists (select 1 from ZWFOT where OT_STATUS = 'OT42_50' and OT_TYPE = 'SAPO_ZWFOT42' and OT_ROWID = @plID)  
  
  begin   
    
   declare @recipient nvarchar(30)  
   declare @OT42_rowid int  
   declare @mail nvarchar(30)   
  
    select @OT42_rowid = OT42_ROWID , @recipient = OT42_IMIE_NAZWISKO  
    from SAPO_ZWFOT42 where OT42_ZMT_ROWID = @PLid  
    select @mail = Email from SYUsers where UserID = @recipient   
  
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
   , OT42_IMIE_NAZWISKO  
   , OT_ORG  
   , N'Zaksięgowany dokument PL: ' + OT_CODE  
   ,  
   '<pre>W systemie ZMT został zaksięgowany dokument PL nr: <b>' + OT_CODE + '</b> <br/> 
    <a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'~/Tabs3.aspx/?MID=ZMT_WORKFLOW_OT42&TGR=OT42&TAB=OT42_LS&FID=OT42_LS' + '&QSC=R09UT1RBQiAyOw==&DW='
 + 'OT_ROWID=' + convert(varchar,OT_ROWID))) + '">KLIKNIJ W LINK, ABY PRZEJŚĆ DO DOKUMENTU PL</a>  
    _______________________________________________  
    Wiadomość została wygenerowana automatycznie.  
    Prosimy na nią nie odpowiadać.  
    </pre>'  
   , ''  
   , OT_TYPE  
   , OT_STATUS  
   , 0  
   , null  
   , getdate()  
   , 0  
   , OT_CODE  
   , (select top 1 ROWID  
    from MAILSETTINGS  
    where case MAIS_STATUS  
      when '*' then OT_STATUS  
      else MAIS_STATUS end = OT_STATUS  
    and OT_TYPE = case MAIS_TYPE  
      when '*' then OT_TYPE  
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
  
   from ZWFOT  
     join SAPO_ZWFOT42 on OT_ROWID = OT42_ZMT_ROWID  
   left join SYUsers on UserID = OT42_IMIE_NAZWISKO  
   where OT_ROWID = @plID  
   and Email is not null    
  end  
  
end



select * from ZWFOT  
     join SAPO_ZWFOT42 on OT_ROWID = OT42_ZMT_ROWID  
	    left join SYUsers on UserID = OT42_IMIE_NAZWISKO  
GO