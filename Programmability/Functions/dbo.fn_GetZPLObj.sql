SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[fn_GetZPLObj]( @p_KEY nvarchar(max))
returns nvarchar(max)
as
begin
  declare @zebra_code nvarchar(max)

  declare @c_ROWID int, @c_PARENTID int, @c_GROUPID int, @c_DESC nvarchar(500), @c_SAP_DESC nvarchar(500), @c_PARENT_DESC nvarchar(500)
		, @c_CODE nvarchar(30), @c_SERIAL nvarchar(30), @c_DATE datetime, @c_PARENT nvarchar(30), @c_STSCODE nvarchar(30)
  declare c_ZPL cursor for select
  OBJ_ROWID, OBJ_PARENTID, OBJ_GROUPID, OBJ_DESC, OBJ_ASSET_DESC, OBJ_PARENT_DESC, OBJ_CODE, OBJ_SERIAL, /*OBJ_DATE*/OBJ_ASTAKTIV, OBJ_PARENT, STS_CODE
	from OBJ_PRINTv
  where OBJ_ROWID in (select string from dbo.VS_Split3(@p_KEY,';'))
  order by OBJ_GROUP desc, OBJ_ROWID desc

  open c_ZPL
  fetch next from c_ZPL into @c_ROWID, @c_PARENTID, @c_GROUPID, @c_DESC, @c_SAP_DESC, @c_PARENT_DESC, @c_CODE, @c_SERIAL, @c_DATE, @c_PARENT, @c_STSCODE
  while @@FETCH_STATUS=0
  begin
	declare @f_TYPE int
	,@f_ORG nvarchar(30)
	,@f_DESC nvarchar(500)
	,@f_PARENT_DESC nvarchar(500)
	,@f_SERIAL nvarchar(30)
	,@f_CODE nvarchar(30)
	,@f_DATE nvarchar(30)
	,@f_SERIAL_DATE nvarchar(60)
	,@f_UNDERSCORE nvarchar(30)
	

	if @c_GROUPID <=7 set @f_ORG = N'PKN ORLEN S.A.' 
	else if @c_GROUPID = 8 set @f_ORG = N'Majątek obcy'
	else set @f_ORG = ''

			select @c_DATE = case when @c_DATE < '1950-01-01' then null else @c_DATE end
			
			if (select isnull(STS_SAP_CHK,0) from STENCILv where STS_CODE = @c_STSCODE) = 1
				begin
					set @f_DESC = LEFT('[SAP] ' + ISNULL(@c_SAP_DESC,''),80)
				end
				else begin
					set @f_DESC = ISNULL(@c_DESC,'')
				end
				
			set @f_SERIAL = ISNULL(@c_SERIAL,'')
			select @f_SERIAL = case when @f_SERIAL <> '' then 'SN:'+@f_SERIAL else '' end
			set @f_PARENT_DESC = case when isnull(@c_PARENT,'') = ISNULL(@c_CODE,'') then '' 
				else LEFT(ISNULL(@c_PARENT,'') + '  ' + ISNULL(@c_PARENT_DESC,''),38) end
			--set @f_UNDERSCORE = REPLICATE('_',LEN(ISNULL(@c_SERIAL,'')))
			set @f_CODE = ISNULL(@c_CODE, '')
			set @f_DATE =ISNULL(convert(nvarchar(10),@c_DATE,121),'')
			select @f_DATE = case when @f_DATE <> '' then 'E:' + @f_DATE else '' end
			-- wyświetlanie SERIAL + DATA EKSPLOATACJI
			-- set @f_SERIAL_DATE = LEFT(@f_SERIAL + '  ' + @f_DATE,45)
			-- wyświetlanie tylko DATY EKSPLOATACJI
			set @f_SERIAL_DATE = @f_DATE


	
	/*

		#   # #   #   #   #####   #     #
		#   # #   #  # #  #      # #    #
		#   # # # # ##### # ### #####  
		##### ## ## #   # ##### #   #   #
	
	NIE RUSZAĆ WCIĘĆ W ZPL KODZIE!!! TAM MUSI BYĆ TEKST Z ENTERAMI!

	
	*/

	set @zebra_code = isnull(@zebra_code,'')+N'^XA
^PR4
~SD30
^PW400
^LL240
^LH0,0

^FO8,33^FB384,1,0,C
^A@N,1,1,E:ARI000.FNT^FD
'+ @f_ORG +N'
^FS

^FO8,60^FB384,2,0,C
^A@N,1,1,E:ARI000.FNT^FD
'+ @f_DESC +N'
^FS

^FO8,100^FB384,1,0,C
^A@N,1,1,E:ARI004.FNT^FD
'+ @f_PARENT_DESC +N'
^FS

^FO96,110^BY1^BCN,70,N,N
^FD
'+ @f_CODE +N'
^FS

^FO8,192^FB384,1,0,C
^A@N,1,1,E:ARI004.FNT^FD
'+ @f_CODE +N'
^FS

^FO8,215^FB384,1,0,C
^A@N,1,1,E:ARI005.FNT^FD
'+ @f_SERIAL_DATE +N'
^FS

^PQ1
^XZ
'

		fetch next from c_ZPL into @c_ROWID, @c_PARENTID, @c_GROUPID, @c_DESC, @c_SAP_DESC, @c_PARENT_DESC, @c_CODE, @c_SERIAL, @c_DATE, @c_PARENT, @c_STSCODE
	end
	deallocate c_ZPL

  return @zebra_code
end
--select dbo.fn_GetZPLObj('pl03#1200001')
GO