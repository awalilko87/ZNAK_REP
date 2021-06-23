SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STENCIL_Delete_Proc] 
(
  @p_STSID int,

  @p_UserID nvarchar(30) -- uzytkownik
  --@p_apperrortext nvarchar(4000) output
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
  declare @v_date datetime

  declare @podskladniki int = null
  declare @skladniki int = null


  /*-- sprawdzenie czy są podskładniki
  SELECT TOP 1 @podskladniki = STL_PARENTID  FROM [dbo].[STENCILLN] WHERE [STL_PARENTID] = @p_STSID
  IF @podskladniki IS NOT NULL
  begin
	select @v_syserrorcode = error_message()
    select @v_errorcode = 'STS_012' -- blad kasowania
    goto errorlabel
  end*/ --kp po co sprawdzac skoro na dole jest i tak delete

  -- spawdzenie czy są podpięte składniki
  SELECT TOP 1 @skladniki = INO_STSID FROM [dbo].[INVTSK_NEW_OBJv] WHERE INO_STSID = @p_STSID
  IF @skladniki IS NOT NULL
  begin
	select @v_syserrorcode = error_message()
    select @v_errorcode = 'STS_013' -- blad kasowania
    goto errorlabel
  end

   -- sprawdzenie czy występuję jako składnik w innym szablonie
  SELECT TOP 1 @podskladniki = STL_PARENTID  FROM [dbo].[STENCILLN] WHERE [STL_CHILDID] = @p_STSID
  IF @podskladniki IS NOT NULL
  begin
	select @v_syserrorcode = error_message()
    select @v_errorcode = 'STS_014' -- blad kasowania
    goto errorlabel
  end
  
  if exists (select 1 from dbo.OBJ where OBJ_STSID = @p_STSID)
  begin
	select @v_syserrorcode = error_message()
    select @v_errorcode = 'STS_015' -- blad kasowania
    goto errorlabel
  end

 --delete
  BEGIN TRY
    -- dodatkowe parametry usuwane razem z szablonem
	DELETE FROM [dbo].[ADDSTSPROPERTIES] WHERE ASP_STSID = @p_STSID

	 -- słownik od elem. PSP usuwany razem z szablonem
	DELETE FROM [dbo].[STENCIL_PSP] WHERE STS_ROWID = @p_STSID

	DELETE FROM [dbo].[INVTSK_NEW_OBJ] WHERE INO_STSID = @p_STSID

	DELETE FROM [dbo].[STENCILLN] WHERE STL_PARENTID = @p_STSID

	DELETE FROM [dbo].[STENCIL] WHERE STS_ROWID = @p_STSID
  END TRY

  BEGIN CATCH
    select @v_syserrorcode = error_message()
    select @v_errorcode = 'OBG_003' -- blad kasowania
    goto errorlabel
  END CATCH;

  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    return 1
end
GO