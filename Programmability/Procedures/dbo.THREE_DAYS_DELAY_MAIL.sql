SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
Create procedure [dbo].[THREE_DAYS_DELAY_MAIL] (
	@recip nvarchar(200) = null
)
as
begin

declare @t TABLE (
	[POT_ROWID] [int] NOT NULL,
	[POT_LP] [int] NULL,
	[POT_CODE] [nvarchar](30) NOT NULL,
	[POT_ORG] [nvarchar](30) NOT NULL,
	[POT_DESC] [nvarchar](80) NULL,
	[POT_NOTE] [ntext] NULL,
	[POT_DATE] [datetime] NULL,
	[POT_STATUS] [nvarchar](30) NULL,
	[POT_TYPE] [nvarchar](30) NULL,
	[POT_TYPE2] [nvarchar](30) NULL,
	[POT_TYPE3] [nvarchar](30) NULL,
	[POT_RSTATUS] [int] NULL,
	[POT_CREUSER] [nvarchar](30) NULL,
	[POT_CREDATE] [datetime] NULL,
	[POT_UPDUSER] [nvarchar](30) NULL,
	[POT_UPDDATE] [datetime] NULL,
	[POT_NOTUSED] [int] NULL,
	[POT_ID] [nvarchar](50) NULL,
	[POT_TXT01] [nvarchar](30) NULL,
	[POT_TXT02] [nvarchar](30) NULL,
	[POT_TXT03] [nvarchar](30) NULL,
	[POT_TXT04] [nvarchar](30) NULL,
	[POT_TXT05] [nvarchar](30) NULL,
	[POT_TXT06] [nvarchar](80) NULL,
	[POT_TXT07] [nvarchar](80) NULL,
	[POT_TXT08] [nvarchar](255) NULL,
	[POT_TXT09] [nvarchar](255) NULL,
	[POT_NTX01] [numeric](24, 6) NULL,
	[POT_NTX02] [numeric](24, 6) NULL,
	[POT_NTX03] [numeric](24, 6) NULL,
	[POT_NTX04] [numeric](24, 6) NULL,
	[POT_NTX05] [numeric](24, 6) NULL,
	[POT_COM01] [ntext] NULL,
	[POT_COM02] [ntext] NULL,
	[POT_DTX01] [datetime] NULL,
	[POT_DTX02] [datetime] NULL,
	[POT_DTX03] [datetime] NULL,
	[POT_DTX04] [datetime] NULL,
	[POT_DTX05] [datetime] NULL,
	[POT_STNID] [int] NULL,
	[CHK_GU_DZR] [int] NULL,
	[CHK_GU_IT] [int] NULL,
	[CHK_GU_RKB] [int] NULL,
	[CHK_GU_UR] [int] NULL,
	[POT_UZASADNIENIE] [nvarchar](70) NULL,
	[POT_UCHWALA_OPIS] [nvarchar](70) NULL,
	[POT_CZY_UCHWALA] [nvarchar](1) NULL,
	[POT_CZY_DECYZJA] [nvarchar](1) NULL,
	[POT_DECYZJA_OPIS] [nvarchar](70) NULL,
	[POT_CZY_ZAKRES] [nvarchar](1) NULL,
	[POT_ZAKRES_OPIS] [nvarchar](70) NULL,
	[POT_OCENA_OPIS] [nvarchar](70) NULL,
	[POT_CZY_OCENA] [nvarchar](1) NULL,
	[POT_CZY_EKSPERTYZY] [nvarchar](1) NULL,
	[POT_EKSPERTYZY_OPIS] [nvarchar](70) NULL,
	[POT_SPOSOBLIKW] [nvarchar](35) NULL,
	[POT_PSP_POSKI] [nvarchar](30) NULL,
	[POT_MIESIAC] [int] NULL,
	[CHK_GU_DZR_USER] [nvarchar](30) NULL,
	[CHK_GU_IT_USER] [nvarchar](30) NULL,
	[CHK_GU_RKB_USER] [nvarchar](30) NULL,
	[CHK_GU_UR_USER] [nvarchar](30) NULL,
	[POT_KOMISJA] [nvarchar](max) NULL,
	[POT_MANAGER] [nvarchar](50) NULL,
	[POT_REALIZATOR] [nvarchar](50) NULL,
	[POT_USERID] [nvarchar](60),
	[POT_EMAIL] [nvarchar](200),
	[POT_ACTION] [nvarchar](200)

)

declare	@xml table (
	POT_USERID nvarchar(60),
	POT_EMAIL nvarchar(200)
	, TRS nvarchar(max)
)

declare	@summtab table (
	USERID nvarchar(60),
	ENTITY nvarchar(10),
	c int
)

declare	@summary table (
	USERID nvarchar(60),
	d nvarchar(max)
)
insert @t (
	[POT_ROWID]
	,[POT_LP]
	,[POT_CODE]
	,[POT_ORG]
	,[POT_DESC]
	,[POT_NOTE]
	,[POT_DATE]
	,[POT_STATUS]
	,[POT_TYPE]
	,[POT_TYPE2]
	,[POT_TYPE3]
	,[POT_RSTATUS]
	,[POT_CREUSER]
	,[POT_CREDATE]
	,[POT_UPDUSER]
	,[POT_UPDDATE]
	,[POT_NOTUSED]
	,[POT_ID]
	,[POT_TXT01]
	,[POT_TXT02]
	,[POT_TXT03]
	,[POT_TXT04]
	,[POT_TXT05]
	,[POT_TXT06]
	,[POT_TXT07]
	,[POT_TXT08]
	,[POT_TXT09]
	,[POT_NTX01]
	,[POT_NTX02]
	,[POT_NTX03]
	,[POT_NTX04]
	,[POT_NTX05]
	,[POT_COM01]
	,[POT_COM02]
	,[POT_DTX01]
	,[POT_DTX02]
	,[POT_DTX03]
	,[POT_DTX04]
	,[POT_DTX05]
	,[POT_STNID]
	,[CHK_GU_DZR]
	,[CHK_GU_IT]
	,[CHK_GU_RKB]
	,[CHK_GU_UR]
	,[POT_UZASADNIENIE]
	,[POT_UCHWALA_OPIS]
	,[POT_CZY_UCHWALA]
	,[POT_CZY_DECYZJA]
	,[POT_DECYZJA_OPIS]
	,[POT_CZY_ZAKRES]
	,[POT_ZAKRES_OPIS]
	,[POT_OCENA_OPIS]
	,[POT_CZY_OCENA]
	,[POT_CZY_EKSPERTYZY]
	,[POT_EKSPERTYZY_OPIS]
	,[POT_SPOSOBLIKW]
	,[POT_PSP_POSKI]
	,[POT_MIESIAC]
	,[CHK_GU_DZR_USER]
	,[CHK_GU_IT_USER]
	,[CHK_GU_RKB_USER]
	,[CHK_GU_UR_USER]
	,[POT_KOMISJA]
	,[POT_MANAGER]
	,[POT_REALIZATOR]
	,[POT_USERID]
	,[POT_EMAIL]
	,[POT_ACTION]
)
select
	OBJTECHPROT.[POT_ROWID]
	,row_number() over(partition by USERID order by POT_UPDDATE, POT_CODE)
	,[POT_CODE]
	,[POT_ORG]
	,[POT_DESC]
	,[POT_NOTE]
	,[POT_DATE]
	,[POT_STATUS]
	,[POT_TYPE]
	,[POT_TYPE2]
	,[POT_TYPE3]
	,[POT_RSTATUS]
	,[POT_CREUSER]
	,[POT_CREDATE]
	,[POT_UPDUSER]
	,[POT_UPDDATE]
	,[POT_NOTUSED]
	,[POT_ID]
	,[POT_TXT01]
	,[POT_TXT02]
	,[POT_TXT03]
	,[POT_TXT04]
	,[POT_TXT05]
	,[POT_TXT06]
	,[POT_TXT07]
	,[POT_TXT08]
	,[POT_TXT09]
	,[POT_NTX01]
	,[POT_NTX02]
	,[POT_NTX03]
	,[POT_NTX04]
	,[POT_NTX05]
	,[POT_COM01]
	,[POT_COM02]
	,[POT_DTX01]
	,[POT_DTX02]
	,[POT_DTX03]
	,[POT_DTX04]
	,[POT_DTX05]
	,[POT_STNID]
	,[CHK_GU_DZR]
	,[CHK_GU_IT]
	,[CHK_GU_RKB]
	,[CHK_GU_UR]
	,[POT_UZASADNIENIE]
	,[POT_UCHWALA_OPIS]
	,[POT_CZY_UCHWALA]
	,[POT_CZY_DECYZJA]
	,[POT_DECYZJA_OPIS]
	,[POT_CZY_ZAKRES]
	,[POT_ZAKRES_OPIS]
	,[POT_OCENA_OPIS]
	,[POT_CZY_OCENA]
	,[POT_CZY_EKSPERTYZY]
	,[POT_EKSPERTYZY_OPIS]
	,[POT_SPOSOBLIKW]
	,[POT_PSP_POSKI]
	,[POT_MIESIAC]
	,[CHK_GU_DZR_USER]
	,[CHK_GU_IT_USER]
	,[CHK_GU_RKB_USER]
	,[CHK_GU_UR_USER]
	,[POT_KOMISJA]
	,[POT_MANAGER]
	,[POT_REALIZATOR]
	,[USERID]
	,[Email]
	,isnull(a.ACT,'inny') --case POT_CODE
from OBJTECHPROT
JOIN (
	SELECT CHK_GU_DZR_USER as POT_USERID, 'Składnik do zatwierdzenia' as ACT, POT_ROWID
	from (
		select CHK_GU_DZR_USER, POT_ROWID from OBJTECHPROT left join OBJTECHPROTCHECK_GU on POC_GROUPID = 'DZR' AND POC_POTID = POT_ROWID
		where CHK_GU_DZR_USER is not null
		and POC_POTID is NULL
		and POT_STATUS = 'POT_002'
		union
		select CHK_GU_IT_USER, POT_ROWID from OBJTECHPROT left join OBJTECHPROTCHECK_GU on POC_GROUPID = 'IT' AND POC_POTID = POT_ROWID
		where CHK_GU_IT_USER is not null
		and POC_POTID is NULL
		and POT_STATUS = 'POT_002'
		union
		select CHK_GU_RKB_USER, POT_ROWID from OBJTECHPROT left join OBJTECHPROTCHECK_GU on POC_GROUPID = 'RKB' AND POC_POTID = POT_ROWID
		where CHK_GU_RKB_USER is not null
		and POC_POTID is NULL
		and POT_STATUS = 'POT_002'
		union
		select CHK_GU_UR_USER, POT_ROWID from OBJTECHPROT left join OBJTECHPROTCHECK_GU on POC_GROUPID = 'UR' AND POC_POTID = POT_ROWID
		where CHK_GU_UR_USER is not null
		and POC_POTID is NULL
		and POT_STATUS = 'POT_002'
	) as GU
	union
	select POT_CREUSER, 'Protokół do zatwierdzenia', POT_ROWID
	from OBJTECHPROT
	where POT_STATUS = 'POT_002'
	AND CHK_GU_DZR = (select count(1) from OBJTECHPROTCHECK_GU dzr where dzr.POC_POTID = POT_ROWID AND dzr.POC_GROUPID = 'DZR' and case dzr.POC_CHECKUSER when 'SA' then CHK_GU_DZR_USER else dzr.POC_CHECKUSER end = CHK_GU_DZR_USER)
	AND CHK_GU_IT = (select count(1) from OBJTECHPROTCHECK_GU it where it.POC_POTID = POT_ROWID AND it.POC_GROUPID = 'IT' and case it.POC_CHECKUSER when 'SA' then CHK_GU_IT_USER else it.POC_CHECKUSER end = CHK_GU_IT_USER)
	AND CHK_GU_RKB = (select count(1) from OBJTECHPROTCHECK_GU rkb where rkb.POC_POTID = POT_ROWID AND rkb.POC_GROUPID = 'RKB' and case rkb.POC_CHECKUSER when 'SA' then CHK_GU_RKB_USER else rkb.POC_CHECKUSER end = CHK_GU_RKB_USER)
	AND CHK_GU_UR = (select count(1) from OBJTECHPROTCHECK_GU ur where ur.POC_POTID = POT_ROWID AND ur.POC_GROUPID = 'UR' and case POC_CHECKUSER when 'SA' then CHK_GU_UR_USER else ur.POC_CHECKUSER end = CHK_GU_UR_USER)
	union
	select POT_MANAGER, 'Protokół do oceny', POT_ROWID
	--select case POT_STATUS when 'PZO_004' then POT_REALIZATOR when 'PZO_002' then POT_MANAGER end, 'Protokół do zatwierdzenia', POT_ROWID
	from OBJTECHPROT
	where POT_STATUS = 'PZO_002'
	union
	select POT_MANAGER, 'Protokół potwierdzony z uwagami', POT_ROWID
	--select case POT_STATUS when 'PZO_004' then POT_REALIZATOR when 'PZO_002' then POT_MANAGER end, 'Protokół do zatwierdzenia', POT_ROWID
	from OBJTECHPROT
	where POT_STATUS = 'PZO_004'
) as a on OBJTECHPROT.POT_ROWID = a.POT_ROWID
join SYUsers on (UserID = POT_USERID or UserName = POT_USERID)
where Email is not null
	and datediff(dd, POT_UPDDATE, getdate()) >=3

insert @summtab (USERID, ENTITY, c)
select POT_USERID, left(POT_STATUS, 3), count(1)
from @t
group by POT_USERID, left(POT_STATUS, 3)

insert @summary (USERID, d)
	 SELECT p1.USERID
		,replace (replace (cast(
		   ( SELECT p2.ENTITY + ' - ' + cast (p2.c as nvarchar(10))
			   FROM @summtab p2
			  WHERE p2.USERID = p1.USERID
			  ORDER BY ENTITY
				FOR XML PATH('td')) as nvarchar(max)), '<td>','<tr><td>'), '</td>','</tr></td>' )
      FROM @summtab p1
      GROUP BY USERID;

insert @xml(POT_USERID, POT_EMAIL, TRS)
	 SELECT p1.POT_USERID, p1.POT_EMAIL,
       ( SELECT cast((select POT_LP as 'td' for xml path('')) as xml), cast((select left(POT_CODE,3) as 'td' for xml path('')) as xml), cast((select POT_ACTION as 'td' for xml path('')) as xml), cast((select POT_CODE as 'td' for xml path('')) as xml)
           FROM @t p2
          WHERE p2.POT_USERID = p1.POT_USERID
          ORDER BY POT_ROWID
            FOR XML PATH('tr') ) AS TRS
      FROM @t p1
      GROUP BY POT_USERID, POT_EMAIL ;
	  
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
			POT_Email
			, POT_USERID
			, ''
			, 'W systemie ZMT istnieją dokumenty, które oczekują na Pani/Pana interwencję dłużej niż 3 dni.'
			,'<pre><table><tr><th>Łącznie dokumentów:</th></tr>' + s.d + '</table>
			</br><table border="1">
	<caption>Dokumenty oczekujące</caption>
	<tr bgcolor="#D3D3D3">
		<th>Lp</td>
		<th>Obszar</td>
		<th>Wymagana akcja</td>
		<th>Numer dokumentu</td>
	</tr>'
	+ TRS  +
	'
	</table>
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
           from @xml x
		   join @summary s on s.USERID = x.POT_USERID
		   where @recip is null or x.POT_EMAIL = isnull(@recip, '')

end
GO