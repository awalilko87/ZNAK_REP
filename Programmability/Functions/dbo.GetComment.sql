SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--select dbo.[GetComment] ('EVT', '1')
CREATE function [dbo].[GetComment] (@p_ENTITY nvarchar(50),@p_ID nvarchar(50),@p_UserID nvarchar(30))
returns nvarchar(max)
as
begin
	declare @v_LangID nvarchar(10)
	declare @v_text nvarchar(max)
	declare @v_user nvarchar(50)
	declare @v_date nvarchar(150)
	declare @v_com nvarchar(max) 
	declare @v_username nvarchar(100)
	declare @v_OT_ENTITY nvarchar(10)
	
	if @p_ENTITY = 'OT'
		select @v_OT_ENTITY  = LEFT (OT_STATUS, 4) from ZWFOT (nolock) where OT_ID = @p_ID
	
	select @v_LangID = LangID from dbo.SYUsers(nolock) where UserID = @p_UserID
	
	declare cr cursor for
	  select 
	    COM_USER
	  , COM_DATE = convert(varchar(19),COM_DATE,121) + case when COM_ENTITY in ('RST','EVT') then ' <font color="grey">('+DES_TEXT+')</font>' else '' end
	  , COM_TEXT 
	  from
	  (
		select 
		  COM_USER
		, COM_DATE
		, COM_TEXT 
		, COM_ENTITY
		from dbo.COMMENTS (nolock) 
		where (COM_ENTITY = @p_ENTITY or COM_ENTITY = case @p_ENTITY when 'EVT' then 'RST' when 'RST' then 'EVT' else @p_ENTITY end) and COM_ID = @p_ID 
	    union
		select
		  STH_USER
		, STH_DATE
		, STH_TEXT = Caption +' <font color="red">'+isnull(s1.STA_DESC,'')+'</font> > <font color="red">'+isnull(s2.STA_DESC,'')+'</font>'
		, STH_ENTITY
		from dbo.STAHIST (nolock)
		  left join dbo.STA S1 on S1.STA_CODE = STH_OLD and S1.STA_ENTITY = STH_ENTITY
		  left join dbo.STA S2 on S2.STA_CODE = STH_NEW and S2.STA_ENTITY = STH_ENTITY
		  left join dbo.VS_LangMSGS(nolock) on LangID = @v_LangID and ControlID = '' and ObjectType = 'MSG' and ObjectID = 'StatusChange'
		--where (STH_ENTITY = @p_ENTITY or STH_ENTITY = case @p_ENTITY when 'EVT' then 'RST' when 'RST' then 'EVT' else @p_ENTITY end) and STH_ID = @p_ID 
		where (STH_ENTITY = @p_ENTITY or STH_ENTITY = case @p_ENTITY when 'OT' then @v_OT_ENTITY else @p_ENTITY end) and STH_ID = @p_ID 
		union
		select 
		 OTM_USERID
		, OTM_DATE
		, isnull(OTM_MESSAGE, N'Błąd integracji. Skontaktuj się z administratorem.')
		, OTM_OT_TYPE
		from dbo.ZWFOT_SAP_MESSAGES (nolock)
			join [dbo].[ZWFOT] (nolock) on OTM_OTID = ZWFOT.OT_ROWID
		where OTM_OT_TYPE = @v_OT_ENTITY and OT_ID = @p_ID
		union
		select
			h.OCH_USERID as COM_USER
			,  h.OCH_DATE
			, 'Użytkownik: ' + h.OCH_USERID + ', Składnik: ' + o.OBJ_CODE + ' (' + o.OBJ_DESC + ') <br> Uwaga obszaru majątkowego: ' + cast(h.OCH_COM as nvarchar(max)) as COM_TEXT
			, 'PZO' as COM_ENTITY
		from OBJTECHPROTLN_POL_COM03_HISTORY h
		join OBJTECHPROTLN l on h.OCH_POLROWID = l.POL_ROWID
		join OBJ o on o.OBJ_ROWID = l.POL_OBJID
		join OBJTECHPROT p on p.POT_ROWID = l.POL_POTID
		where p.POT_ID = @p_ID
		and h.OCH_COM is not null
	  ) A
	  left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = 'ENT' and DES_TYPE = 'DESC' and DES_CODE = COM_ENTITY and DES_LANGID = @v_LangID
	order by COM_DATE ASC

	set @v_com = ''
	open cr	
	fetch next from cr into @v_user, @v_date, @v_text
	while @@FETCH_STATUS = 0
	begin
		set @v_username = ''
		select @v_username = UserName from SYUsers where UserID = @v_user
		set @v_com = @v_com + ''+isnull('<font color="green">'+@v_username,'')+'</font> '+@v_date +'<br>'+replace(replace(@v_text,char(13)+char(10),'<br>'),char(10),'<br>')+'<br><br>'

		fetch next from cr into @v_user, @v_date, @v_text
	end
	close cr
	deallocate cr
	
  if @v_com = ''
	select @v_com = Caption from dbo.VS_LangMsgs(nolock) where LangID = @v_LangID and ControlID = '' and ObjectType = 'MSG' and ObjectID = 'NoComments'
  return (@v_com)
end
GO