SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_STATION_ADD_DEL_Multi](  
	@TYP int = NULL,  
	@ITSID int = NULL,  
	@p_Key nvarchar(max) = NULL,  
	@p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) = null output
)  
AS
BEGIN
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)

	declare @cr_STNID nvarchar(10);

	if isnull(@p_Key,'') = ''
	begin
		set @v_errorcode = 'MULTI_EMPTY'
		goto errorlabel
	end

    declare c_instr cursor for 
	select string from dbo.VS_Split3(@p_KEY,';')
		where   string != ''
	
    open c_instr
	fetch next from c_instr into @cr_STNID
	while @@fetch_status = 0
	begin try 
		  
		if @TYP = 1 and not exists (select * from [dbo].[INVTSK_STATIONS] (nolock) where INS_ITSID = @ITSID and INS_STNID = @cr_STNID)  
		begin
			insert into [dbo].[INVTSK_STATIONS] (INS_ITSID, INS_STNID)
			select @ITSID, @cr_STNID
		end
		else if @TYP = 0 
		begin
			if not exists (select * from INVTSK_NEW_OBJ (nolock) join PSP (nolock) on PSP_ROWID = INO_PSPID where INO_STNID = @cr_STNID and PSP_ITSID = @ITSID)
			begin
				delete from [dbo].[INVTSK_STATIONS] where INS_ITSID = @ITSID and INS_STNID = @cr_STNID
			end
			else
			begin
				select @v_errorcode = 'INS_002'
				--select * From vs_langmsgs where objectid = 'INVTSK_MULTI_001'
				goto errorlabel
			end
		end


		fetch next from c_instr into @cr_STNID
	end try
	begin catch
		close c_instr
		deallocate c_instr	
		set @v_errorcode = 'INVTSK_MULTI_001' -- blad dodawania instrukcji multi
		goto errorlabel
	end catch

	close c_instr
	deallocate c_instr

	RETURN 0
 
	  
 	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
END
GO