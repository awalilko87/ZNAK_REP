SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--Procedura dla WinSync-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValues_WinSyncGet]
AS

	DECLARE
		 @v_SAV_SASROWID int  = (SELECT s.SAS_ROWID FROM dbo.SAPIO_Statuses s WITH (NOLOCK) WHERE s.SAS_CODE = 'DO_WYSYLKI')
		,@v_SAV_ROWID int
		,@v_SAV_CODE nvarchar(30)

	SELECT TOP 1
		 @v_SAV_ROWID = s.SAV_ROWID
		,@v_SAV_CODE = s.SAV_CODE
	FROM dbo.SAPIO_ActValuesHeaders s WITH (NOLOCK)
	WHERE 1 = 1
		 AND s.SAV_SASROWID = @v_SAV_SASROWID
	ORDER BY 
		 s.SAV_CREDATE

	EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
			 @p_SAV_ROWID = @v_SAV_ROWID
			,@p_SAV_SASCODE = 'WYSYLANIE'


	SELECT 
		 AST_SAP_ANLN1 as Anln1
		,AST_SAP_ANLN2 as Anln2
	FROM dbo.ASSET a WITH (NOLOCK)
	WHERE 1 = 1 
		AND EXISTS (SELECT 1 
					FROM dbo.SAPIO_ActValuesLines al WITH (NOLOCK)
					WHERE 1 = 1
						AND al.SAL_SAVROWID = @v_SAV_ROWID
						AND al.SAL_ASTROWID = a.AST_ROWID
		
					)

	IF @v_SAV_CODE is not null
		SELECT 
			 @v_SAV_CODE as ZmtGetActValueRequestId

	EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
			 @p_SAV_ROWID = @v_SAV_ROWID
			,@p_SAV_SASCODE = 'WYSLANO'
GO