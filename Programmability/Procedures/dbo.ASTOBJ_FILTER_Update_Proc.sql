SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ASTOBJ_FILTER_Update_Proc] 
(
  @p_FormID nvarchar(50),
  @p_ID nvarchar(50), 
  @p_CODE nvarchar (30),
  @p_DESC nvarchar (80),
  @p_GROUP nvarchar (30),
  @p_STATION nvarchar (30),
  @p_TYPE nvarchar (30), 
  @p_PSP nvarchar (30), 
  @p_ASSET nvarchar (30), 
  @p_CREUSER nvarchar (30),
  @p_CREDATE datetime,
  @p_NOTUSED int,
  
  --- tutaj ewentualnie swoje parametry/zmienne/dane
 
  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
  declare @v_date datetime
  declare @v_Rstatus int
  declare @v_Pref nvarchar(10)
  declare @v_MultiOrg BIT
  
  -- czy klucze niepuste
  if @p_ID is null -- ## dopisac klucze
  begin
    select @v_errorcode = 'SYS_003'
	goto errorlabel
  end
 
  set @v_date = getdate()
   
 --insert
	if not exists (select * from dbo.ASTOBJ_FILTER (nolock) where OBJ_USERID = @p_UserID)
	begin 
      BEGIN TRY
		insert into dbo.ASTOBJ_FILTER  
		(
			OBJ_USERID,
			OBJ_CODE,
			OBJ_DESC,
			OBJ_GROUP,
			OBJ_STATION,
			OBJ_TYPE,
			OBJ_PSP,
			OBJ_ASSET,
			OBJ_ID,
			OBJ_CREUSER,
			OBJ_CREDATE,
			OBJ_NOTUSED
		)
		values 
		(
			@p_USERID,
			@p_CODE,
			@p_DESC,
			@p_GROUP,
			@p_STATION,
			@p_TYPE,
			@p_PSP,
			@p_ASSET,
			@p_ID,
			@p_USERID,
			@v_date,
			0
		) 
	  END TRY
	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'SYS_001' -- blad wstawienia
		goto errorlabel
	  END CATCH;
	end
    else
    begin
      

		BEGIN TRY
		  UPDATE dbo.ASTOBJ_FILTER SET
			
			OBJ_CODE = @p_CODE,
			OBJ_DESC = @p_DESC,
			OBJ_GROUP = @p_GROUP,
			OBJ_STATION = @p_STATION,
			OBJ_TYPE = @p_TYPE, 
			OBJ_PSP = @p_PSP,
			OBJ_ASSET = @p_ASSET,
			OBJ_CREUSER = @p_CREUSER, 
			OBJ_NOTUSED = @p_NOTUSED
 
		  where/* OBJ_ID = @p_ID and */ OBJ_USERID = @p_USERID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OBJ_002' -- blad aktualizacji zgloszenia
			goto errorlabel
		END CATCH;
  end
  
  return 0
  
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end
GO