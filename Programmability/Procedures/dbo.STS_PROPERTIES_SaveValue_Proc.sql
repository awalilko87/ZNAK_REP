SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_PROPERTIES_SaveValue_Proc]
(
	@p_PROID int, 
	@p_STSID int, 
	@p_VALUE nvarchar(512),
	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as 
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)

  if @p_PROID is null 
  begin
    select @v_errorcode = 'PRO_001'
	goto errorlabel
  end
  
  if @p_STSID is null 
  begin
    select @v_errorcode = 'STS_001'
	goto errorlabel
  end
 
		BEGIN TRY
		  UPDATE dbo.ADDSTSPROPERTIES SET
			ASP_VALUE = @p_VALUE,
			ASP_UPDATECOUNT = ASP_UPDATECOUNT + 1,
			ASP_UPDATED = getdate()
		  where ASP_PROID = @p_PROID and ASP_STSID = @p_STSID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'STS_002' -- blad aktualizacji zgloszenia
			goto errorlabel
		END CATCH;

  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end

GO