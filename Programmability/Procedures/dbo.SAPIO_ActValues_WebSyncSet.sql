SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--Procedura dla WebSync-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValues_WebSyncSet]
	 @ZmtGetActValueRequestId nvarchar(60)
	,@Anln1 nvarchar(60)
	,@Anln2 nvarchar(60)
	,@Wartoscpocz numeric(24,6)
	,@Wartoscnetto numeric(24,6)
	,@OkrAmort nvarchar(60)
	,@OstatniaLinia bit
AS

	DECLARE
		 @v_SAS_ERRORROWID int = (SELECT s.SAS_ROWID FROM dbo.SAPIO_Statuses s WITH (NOLOCK) WHERE s.SAS_CODE = 'PRZETWORZONO_ODPOWIEDZ_ZBLEDEM')
		,@v_SAV_ROWID int = (SELECT h.SAV_ROWID FROM dbo.SAPIO_ActValuesHeaders h WITH (NOLOCK) WHERE 1 = 1 AND h.SAV_CODE = @ZmtGetActValueRequestId)
		,@v_SAE_ERROR bit = 0
		,@v_SAE_MESSAGE nvarchar(500) = 'Command(s) completed successfully.'
		,@v_SAE_DATA xml = (
								SELECT 
									   @ZmtGetActValueRequestId as ZmtGetActValueRequestId
									 , @Anln1				    as Anln1
									 , @Anln2				    as Anln2
									 , @Wartoscpocz			    as Wartoscpocz
									 , @Wartoscnetto		    as Wartoscnetto
								 FOR XML PATH('Line'), ROOT('Data')
							)

BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM dbo.SAPIO_ActValuesHeaders h WITH (NOLOCK) WHERE h.SAV_ROWID = @v_SAV_ROWID AND h.SAV_SASROWID =  @v_SAS_ERRORROWID)
		BEGIN
			EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
					 @p_SAV_ROWID = @v_SAV_ROWID
					,@p_SAV_SASCODE = 'OTRZYMANO_ODPOWIEDZ'
		END

		IF @ZmtGetActValueRequestId is null OR @Anln1 is null OR @Anln2 is null OR @Wartoscpocz is null OR @Wartoscnetto is null OR @OkrAmort is null
			SELECT @v_SAE_ERROR = 1, @v_SAE_MESSAGE = 'Brak lub niepełne dane'

		IF @v_SAE_ERROR = 0
		BEGIN
			UPDATE l SET 
				 SAL_INITIALVALUE		= @Wartoscpocz
				,SAL_NETVALUE			= @Wartoscnetto
				,SAL_AMORTIZATIONPERIOD	= @OkrAmort
			FROM dbo.SAPIO_ActValuesLines l WITH (ROWLOCK, XLOCK)
			WHERE 1 = 1
				AND l.SAL_SAVROWID = @v_SAV_ROWID
				AND EXISTS (SELECT 1
							FROM dbo.ASSET a WITH (NOLOCK)
							WHERE 1 = 1 
								AND a.AST_SAP_ANLN1 = @Anln1
								AND a.AST_SAP_ANLN2 = @Anln2
								AND a.AST_ROWID = l.SAL_ASTROWID
							)

			IF @@ROWCOUNT = 0 
				SELECT @v_SAE_ERROR = 1, @v_SAE_MESSAGE = 'Nie zaktualiowano wiersza'
		END

		IF IsNull(@OstatniaLinia,0) = 1 AND EXISTS (SELECT 1 FROM dbo.SAPIO_ActValuesLines l WITH (NOLOCK) WHERE l.SAL_SAVROWID = @v_SAV_ROWID AND (SAL_INITIALVALUE is null OR SAL_AMORTIZATIONPERIOD is null OR SAL_NETVALUE is null))
			SELECT @v_SAE_ERROR = 1, @v_SAE_MESSAGE = 'Brak odpowiedzi dla wszystkich lini'


END TRY BEGIN CATCH
	SELECT @v_SAE_ERROR = 1, @v_SAE_MESSAGE = ERROR_MESSAGE();
END CATCH



	IF @v_SAE_ERROR = 1
	BEGIN
		EXEC dbo.SAPIO_ActValuesErrors_Add
					 @p_SAE_SAVROWID = @v_SAV_ROWID
					,@p_SAE_MESSAGE = @v_SAE_MESSAGE
					,@p_SAE_DATA = @v_SAE_DATA
					
		EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
				 @p_SAV_ROWID = @v_SAV_ROWID
				,@p_SAV_SASCODE = 'PRZETWORZONO_ODPOWIEDZ_ZBLEDEM'
	END
	ELSE IF 1 = 1 
			AND IsNull(@OstatniaLinia,0) = 1 
			AND NOT EXISTS (SELECT 1 FROM dbo.SAPIO_ActValuesHeaders h WITH (NOLOCK) WHERE h.SAV_ROWID = @v_SAV_ROWID AND h.SAV_SASROWID =  @v_SAS_ERRORROWID)
			AND NOT EXISTS (SELECT 1 FROM dbo.SAPIO_ActValuesErrors e WITH (NOLOCK) WHERE e.SAE_SAVROWID = @v_SAV_ROWID)
	BEGIN
		
		EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
				 @p_SAV_ROWID = @v_SAV_ROWID
				,@p_SAV_SASCODE = 'PRZETWORZONO_ODPOWIEDZ'

		exec dbo.SAPIO_ActValuesProcessDoc
				@p_SAVCODE = @ZmtGetActValueRequestId
	END


GO