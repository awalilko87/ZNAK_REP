SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZOLN_LSRC_Update_Proc](  
@p_FormID nvarchar(50),  
@p_ROWID int,  
@p_STATUS nvarchar(30),  
@p_DATE datetime,  
@p_DTX01 datetime,  
@p_COM01 nvarchar(max),  
@p_COM02 nvarchar(max),
@p_COM03 nvarchar(max),   
@p_PS_ACCEPT int, 
@p_PS_COMMENT nvarchar(max),
@p_UserID nvarchar(30)  
)  
as  
begin  
	declare @v_errortext nvarchar(1000)  
	
	declare @v_COM01 nvarchar(max)
	declare @v_COM02 nvarchar(max)
	declare @v_COM03 nvarchar(max)
	declare @v_POTID int
	declare @v_REALIZATOR nvarchar(30)
	declare @v_ODBIERAJACY nvarchar(30)

	select 
		 @v_POTID = POL_POTID
		,@v_COM01 = POL_COM01
		,@v_COM02 = POL_COM02
		,@v_COM03 = POL_COM03
	from dbo.OBJTECHPROTLN 
	where POL_ROWID = @p_ROWID

	select
		 @v_REALIZATOR = POT_REALIZATOR
		,@v_ODBIERAJACY = POT_MANAGER
	from dbo.OBJTECHPROT
	where POT_ROWID = @v_POTID
  
	if @p_STATUS = 'PZL_002' and (@p_DATE is null or @p_COM01 is null)  
	begin  
		set @v_errortext = 'Dla statusu "Nieodebrany" należy wypełnić Uwagi oraz termin usunięcia uwag'  
		goto errorlabel  
	end  
  
	if exists (select 1 from dbo.OBJTECHPROTLN where POL_ROWID = @p_ROWID and POL_RSTATUS = 1)  
	begin  
		set @v_errortext = 'Nie można edytować potwierdzonego wcześniej składnika.'  
		goto errorlabel  
	end  

	if isnull(@p_COM01,'') <> isnull(@v_COM01,'') and @p_UserID <> @v_ODBIERAJACY
	begin
		set @v_errortext = 'Nie masz uprawnień do edycji uwag odbierającego'  
		goto errorlabel
	end

	if isnull(@p_COM02,'') <> isnull(@v_COM02,'') and @p_UserID <> @v_REALIZATOR
	begin
		set @v_errortext = 'Nie masz uprawnień do edycji uwag zdającego'  
		goto errorlabel
	end
  
	begin try  
		update dbo.OBJTECHPROTLN set  
			 POL_STATUS = @p_STATUS  
			,POL_DATE = @p_DATE  
			,POL_DTX01 = @p_DTX01  
			,POL_COM01 = @p_COM01  
			,POL_COM02 = @p_COM02
			,POL_COM03 = @p_COM03
			,POL_UPDUSER = @p_UserID  
			,POL_UPDDATE = getdate()
			,POL_PS_ACCEPT = @p_PS_ACCEPT
			,POL_PS_COMMENT = @p_PS_COMMENT  
		where POL_ROWID = @p_ROWID

		If @p_COM03 is not null and isnull(@v_COM03,'') <> @p_COM03
		begin
			insert OBJTECHPROTLN_POL_COM03_HISTORY (
				OCH_POLROWID
				, OCH_COM
				, OCH_USERID
				, OCH_DATE
				)
			select @p_ROWID
				, @p_COM03
				, @p_UserID
				, GETDATE()
		end

	end try  
	begin catch  
		set @v_errortext = error_message()  
		goto errorlabel  
	end catch  
  
	return 0  
  
errorlabel:  
 raiserror(@v_errortext, 16, 1)  
 return 1  
end  
GO