SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[AST_INWLN_MAIL] (
@SIN_ID int 
)

AS
BEGIN 
--DECLARE @sin_id INT= 2
declare @SIN_DATE datetime
, @SIN_STN int
, @STN_DESC nvarchar(80)
, @SUBJECT nvarchar(80)
, @BODY NVARCHAR(MAX)
, @BODY1 NVARCHAR(MAX)
, @BODY2 NVARCHAR(MAX)
, @BODY3 NVARCHAR(MAX)
, @BODY4 NVARCHAR(MAX)
, @BODY5 NVARCHAR(MAX)
, @RESPON NVARCHAR(MAX)
, @OBSZAR NVARCHAR(30)
, @RECEIP NVARCHAR(30)

select @SIN_DATE = SIN_CREDATE, @SIN_STN = SIN_STNID from dbo.ST_INW(nolock) where SIN_ROWID =  @SIN_ID
select @STN_DESC = STN_DESC from dbo.STATION (nolock) where STN_ROWID = @SIN_STN

if exists (select 1 from dbo.AST_INWLN(nolock) where SIA_SINID = @sin_id and SIA_NEWQTY = 0 and SIA_STATUS = 'INW')

	BEGIN

	/*WRZUCAMY OBSZARY ODPOWIEDZIALNOŚCI NA DANEJ STACJI*/
	DECLARE @OBSZARY TABLE (SINID int, [OBJID] int, STNID int, OBSZAR nvarchar(10), RESPONID NVARCHAR(30))

	insert into @OBSZARY (SINID,[OBJID], STNID, OBSZAR, RESPONID )
		
	select SIN_STNID, SIA_OBJID, SIN_STNID, GROUPID, STR_RESPONID
	from  dbo.AST_INWLN(nolock) 
	INNER JOIN  dbo.ST_INW(nolock) on SIN_ROWID = SIA_SINID  
	LEFT JOIN OBJ on OBJ_ROWID = SIA_OBJID
	LEFT JOIN dbo.OBJGROUP_RESPONv on OBG_ROWID = OBJ_GROUPID 
	LEFT JOIN STATION_RENSPON on SIN_STNID = STR_STNID and STR_OBSZAR = GROUPID
	WHERE SIN_ROWID = @SIN_ID AND SIA_STATUS = 'INW' AND SIA_NEWQTY = 1

	select @RECEIP=''
	select @RECEIP=@RECEIP+IsNull(Email+';','') 
	FROM SYUsers WHERE UserID IN (SELECT RESPONID FROM @OBSZARY);



	--DECLARE @ CURSOR FOR SELECT SIA_OBJID  from dbo.AST_INWLN(nolock) where SIA_SINID = @SIN_ID and SIA_NEWQTY = 0 and SIA_STATUS = 'INW'

	--Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot12.[OT12_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))


	
		SELECT @BODY1='', @BODY2='', @BODY3='' , @BODY4='' , @BODY5=''

		SELECT @SUBJECT = 'Powiadomienie z systemu ZMT - Niedobory na ' + cast(@STN_DESC as nvarchar(30))


		SELECT @BODY1 = 'Komisja spisowa w trakcie inwentaryzacji w dniu '+CONVERT(varchar(10),@SIN_DATE ,120) +' na '+ IsNull(@STN_DESC, '') +' zidentyfikowała następujące niedobory składników.<br/> 
				Należy nie później niż w ciągu 5 dni roboczych wystawić i przeprocesować odpowiednie wnioski workflow dokumentujące ruchy niżej wspomnianych składników.'

	
		--SELECT @BODY2=@BODY2+'</TABLE>'

		SELECT  @BODY3=@BODY3+'<HR><TABLE width="100%" border="1"><TR>'
				+'<TD >Kod kreskowy ZMT'
				+'<TD >Numer inwentarzowy'
				+'<TD >Podnumer inwentarzowy'
				+'<TD >Nazwa środka trwałego'
				+'<TD >Potwierdził'
				+'<TD >Data potwierdzenia'


		select @BODY4=@BODY4
				+'<TR><TD align="left">'+Cast(IsNull(SIA_BARCODE,'') as nvarchar)+'&nbsp;'
				+'<TD align="left">'+Cast(IsNull(SIA_ASTCODE,'') as nvarchar)+'&nbsp;'
				+'<TD align="right">'+Cast(IsNull(SIA_ASTSUBCODE,'') as nvarchar)+'&nbsp;'
				+'<TD align="left">'+Cast(IsNull(SIA_ASTDESC,'') as nvarchar(50))+'&nbsp;'
				+'<TD align="left">'+Cast(IsNull(SIA_CONFIRMUSER_DESC,'') as nvarchar)+'&nbsp;'
				+'<TD align="left">'+Cast(IsNull(CONVERT(DATE,SIA_CONFIRMDATE),'') as nvarchar)+'&nbsp;'
				from dbo.AST_INWLNv(nolock) where SIA_SINID = @SIN_ID
				and SIA_STATUS = 'INW' and SIA_NEWQTY = 0



	SELECT @BODY5 ='</TABLE><BR><HR>
					<B>Kliknij w poniższy link aby zalogować się do systemu ZMT</B>
					<BR>
					<A HREF="https://zmt.orlen.pl">
					<font color="BLUE">https://zmt.orlen.pl</a>'

					select @BODY5 = @BODY5+
					'<HR>
					<i><font color="BLACK">Wiadomość została wygenerowana automatycznie, proszę na nią nie odpowiadać.</i>

					<br>'

		SELECT @BODY =  IsNull(@BODY1,'')+Isnull(@BODY3,'')+Isnull(@BODY4,'')+IsNull(@BODY5,'')


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
			  @RECEIP  -- [MAIB_RECEIVER]
			, ''	   -- [MAIB_USER]
			, 'PKN'	   -- [MAIB_ORG]
			, @SUBJECT -- [MAIB_SUBJECT]
			, @BODY    -- [MAIB_BODY]
			, 'STN'    -- [MAIB_ENT]
			, ''	   -- [MAIB_TYPE]
			, ''	   -- [MAIB_STATUS]		
			, 0		   -- [MAIB_ISSEND]		
			, null	   -- [MAIB_SENDTIME]
			, getdate()-- [MAIB_CREATED]
			, 0		   -- [MAIB_NROFRETRY]
			,''		   -- [MAIB_NRDOC]
			,1		   -- [MAIB_MAISID]
			, null	   -- [MAIB_QUERY]
			, 'NIE'	   -- [MAIB_MGTYPE]
			, null	   -- [MAIB_DW]
			, null     -- [MAIB_REPORTNAME]
			, null	   -- [MAIB_REPORTPARAMS]
			, null	   -- [MAIB_ATTACHNAME]
			, null	   -- [MAIB_ATTACH]
			, null     -- [MAIB_STATUS_IM]


	END
		ELSE 
		RETURN;


		Print 'Powiadomienie mailowe zostało wysłane'

END



--exec dbo.AST_INWLN_MAIL 2


--select * from  [dbo].[MAILBOX] order by  MAIB_CREATED desc


--select * from [dbo].[MAILPROFILES]
--select * from [dbo].[MAILRECIPIENTS]
--select * from [dbo].[MAILSETTINGS]
--select * from [dbo].[MAILSETTINGS_TABLE]
--select * from [dbo].[STAMAIL]
GO