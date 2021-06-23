SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROC [dbo].[INWAST_CANCEL_Proc]
(
@p_UserId NVARCHAR(30),
@p_SIN_ROWID INT,
@p_GroupID nvarchar(30),
@p_SIN_STATUS_DESC nvarchar(30)
)
AS
BEGIN
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
  DECLARE @v_status nvarchar(50)
  DECLARE @v_creuser nvarchar(30)

SELECT @v_creuser = SIN_CREUSER FROM ST_INW WHERE SIN_ROWID = @p_SIN_ROWID


IF @p_GroupID NOT IN ('BRS', 'BRSA', 'SA')
	BEGIN
	select @v_errorcode = 'INW_CAN_001'
	GOTO errorlabel
	END


IF @p_SIN_STATUS_DESC = 'Anulowany'
	BEGIN
	select @v_errorcode = 'INW_CAN_003'
	GOTO errorlabel
	END


IF (@p_GroupID = 'BRS' AND @v_creuser = @p_UserId) OR (@p_GroupID = 'BRSA') or (@p_GroupID = 'SA')
  BEGIN TRY 

  UPDATE ST_INW
  SET SIN_STATUS = 'SIN_010',
  SIN_TXT09 = @p_UserId
  WHERE SIN_ROWID = @p_SIN_ROWID

  END TRY
  BEGIN CATCH
    select @v_syserrorcode = error_message()
    select @v_errorcode = 'INW_CAN_002' 
    goto errorlabel
  END CATCH

  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    return 1
end


GO