SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetEntCode]
( 
	@p_ROWID int,
	@p_table nvarchar(30),
	@p_ent nvarchar(30),
	@p_Number nvarchar(30) output
)
as
begin
	declare 
		@v_Number nvarchar(50), 
		@v_No int,
		@v_ent_entity nvarchar(30), 
		@v_ent_prefix nvarchar(100),
		@v_ent_suffix nvarchar(100)
	
	----------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------ENT Config------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------	 	
	select top 1
		@v_ent_prefix = ltrim(rtrim(ENT_PREFIX)),
		@v_ent_suffix = ltrim(rtrim(ENT_SUFFIX)),
		@v_ent_entity = ENT_CODE
	from ENT (nolock) 
	where 
		ENT_TABLE = @p_table
		and ENT_CODE = isnull(@p_ent, ENT_CODE) --additional check tool/assort
		 
	if  @v_ent_entity is null
	begin
		raiserror ('Niepoprawna konfiguracja tabeli ENT / Incorrect ENT table configuration',16,1)	
		return 1
	end
	
	if 	isnull(@v_ent_prefix,'') = '' set @v_ent_prefix = ''''''
	if 	isnull(@v_ent_suffix,'') = '' set @v_ent_suffix = ''''''
	
	----------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------Prefix--------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	declare
		@v_prefix nvarchar(15),  
		@v_prequery nvarchar(max),
		@v_preparams nvarchar(max)
	
	set @v_preparams = N'@v_prefix nvarchar(15) output'
	set @v_prequery = 'select @v_prefix = ' + @v_ent_prefix + ' from ' + @p_table + ' (nolock) where '+ @p_ent +'_ROWID = ' + cast(@p_ROWID as nvarchar(10))
	begin try
		exec sp_executesql @query = @v_prequery, @params = @v_preparams, @v_prefix = @v_prefix output
	end try
	begin catch
		raiserror ('Niepoprawna konfiguracja tabeli ENT w kolumnie ENT_PREFIX/ Incorrect ENT table configuration on ENT_PREFIX column',16,1)	
		return 1
	end catch
	
	----------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------Suffix--------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	declare
		@v_suffix nvarchar(10), 
		@v_sufquery nvarchar(max),
		@v_sufparams nvarchar(max)
 
 	set @v_sufparams = N'@v_suffix nvarchar(10) output'
	set @v_sufquery = 'select @v_suffix = ' + @v_ent_suffix + ' from ' + @p_table + ' (nolock) where '+ @p_ent +'_ROWID = ' + cast(@p_ROWID as nvarchar(10))
	
	begin try
		exec sp_executesql @query = @v_sufquery, @params = @v_sufparams, @v_suffix = @v_suffix output
	end try
	begin catch
		raiserror ('Niepoprawna konfiguracja tabeli ENT w kolumnie ENT_SUFFIX/ Incorrect ENT table configuration on ENT_SUFFIX column',16,1)	
		return 1
	end catch
	 	
	----------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------Number--------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------
	declare
		@v_numquery nvarchar(max),
		@v_numparams nvarchar(max)
	
	if @p_table = 'ZWFOT' and @p_ent = 'OT'
	begin
		set @v_prefix = (case @v_prefix 
			when 'OT11' then 'OT'
			when 'OT12' then 'OTK'
			when 'OT21' then 'W'
			when 'OT31' then 'MT1'
			when 'OT32' then 'MT2'
			when 'OT33' then 'MT3'
			when 'OT40' then 'LTS'
			when 'OT41' then 'LTW'
			when 'OT42' then 'PL' 
			else @v_prefix end) + @v_suffix + '_'
		set @v_suffix = ''
	end
	
	
	set @v_numquery = 'exec dbo.VS_GetNumber' + 
		' @Type = ' + @v_ent_entity + 
		', @Pref = ''' + isnull(@v_prefix,'') + '''' +
		', @Suff = ''' + isnull(@v_suffix,'') + '''' + 
		', @Number = @v_Number output' + 
		', @No = @v_No output'
	
	set @v_numparams = N'@v_Number nvarchar(50) output, @v_No int output'
	
	begin try
		exec sp_executesql @query = @v_numquery, @params = @v_numparams,  @v_Number = @v_Number output, @v_No = @v_No output
	end try
	begin catch
		raiserror ('Wystąpił błąd podczas generowania numeru dokumentu / Error occured during generation of document number',16,1)	
		return 1
	end catch
	
	set @p_Number = @v_Number
 
	return 0
end
GO