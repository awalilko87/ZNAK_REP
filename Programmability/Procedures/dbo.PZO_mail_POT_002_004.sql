SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZO_mail_POT_002_004] (

--declare
		@p_ID nvarchar(50)
		, @p_STATUS_old nvarchar(30) = null
)
as
begin
--select @p_ID='DB2F517F-669E-4567-9FB2-7AA39415757C'

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
			, 'Protokół: ' + POT_CODE
			,'<pre>W systemie ZMT ' + case @p_STATUS_old when 'PZO_001' then 'został wystawiony nowy ' else '' end + '<b>Protokół Zdawczo-Odbiorczy</b>
nr: <b>' + POT_CODE + '</b>' + case @p_STATUS_old when 'PZO_001' then '' else ' zmienił status na "' + STA_DESC + '"' end +'. 

'--<a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'Tabs3.aspx/?MID=ZMT_MOVE_PZO&TGR=PZO&TAB=PZO_RC&FID=PZO_RC&POTID=' + (select top 1 cast(POT_ROWID as nvarchar)))) + '">LINK</a>
+ '<a href = "' + (select top 1 SettingValue from SYSettings where KeyCode = 'LIC_WWW') + '/' + dbo.VS_EncryptLink(N'Link.aspx?B=' + dbo.VS_EncodeBase64(N'Tabs3.aspx/?MID=ZMT_MOVE_PZO&TGR=PZO&TAB=PZO_LS&FID=PZO_LS' + '&QSC=R09UT1RBQiAyOw==&DW=' + 'POT_ROWID=' + convert(varchar,POT_ROWID))) + '">LINK</a>

_______________________________________________
Wiadomość została wygenerowana automatycznie.
Prosimy na nią nie odpowiadać.
</pre>'
			, STA_ENTITY
			, POT_TYPE
			, POT_STATUS
			, 0
			, null
			, getdate()
			, 0
			, POT_CODE
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
join SYUsers on (UserID = case POT_STATUS when 'PZO_004' then POT_REALIZATOR else POT_MANAGER end or UserName = case POT_STATUS when 'PZO_004' then POT_REALIZATOR else POT_MANAGER end)
--join MAILSETTINGS on MAIS_STATUS = POT_STATUS and POT_TYPE = MAIS_TYPE
join STA on STA_CODE = POT_STATUS and POT_TYPE = case STA_TYPE when '*' then POT_TYPE else STA_TYPE end
where POT_STATUS = 'PZO_004'	--in ('PZO_002', 'PZO_004')	--rem mmilczar 20171219, ORLZNAK-138
and POT_TYPE = 'ZDAWCZY'
and POT_ID=@p_ID
and Email is not null

/*
     VALUES
           (<MAIB_RECEIVER, nvarchar(4000),>
           ,<MAIB_USER, nvarchar(4000),>
           ,<MAIB_ORG, nvarchar(50),>
           ,<MAIB_SUBJECT, nvarchar(500),>
           ,<MAIB_BODY, nvarchar(4000),>
           ,<MAIB_ENT, nvarchar(4),>
           ,<MAIB_TYPE, nvarchar(30),>
           ,<MAIB_STATUS, nvarchar(30),>
           ,<MAIB_ISSEND, int,>
           ,<MAIB_SENDTIME, datetime,>
           ,<MAIB_CREATED, datetime,>
           ,<MAIB_NROFRETRY, int,>
           ,<MAIB_NRDOC, nvarchar(80),>
           ,<MAIB_MAISID, int,>
           ,<MAIB_QUERY, nvarchar(max),>
           ,<MAIB_MGTYPE, nvarchar(50),>
           ,<MAIB_DW, nvarchar(500),>
           ,<MAIB_REPORTNAME, nvarchar(200),>
           ,<MAIB_REPORTPARAMS, nvarchar(200),>
           ,<MAIB_ATTACHNAME, nvarchar(200),>
           ,<MAIB_ATTACH, image,>
           ,<MAIB_STATUS_IM, nvarchar(20),>)

		   */
end
GO