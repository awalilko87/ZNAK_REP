SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--Tworzenie dokumentu-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValuesHeader_Add]
	 @p_SAV_CODE nvarchar(30) = null
	,@p_SAV_TYPE nvarchar(30) = null
	,@p_SAV_ENTITY nvarchar(30) = null
	,@p_SAV_ENTID int = null
	,@p_UserId nvarchar(30)
	,@o_SAV_ROWID int OUT
AS

	DECLARE 
		 @v_SAV_CODE nvarchar(30) = @p_SAV_CODE
		,@v_SAV_SASROWID int = (SELECT s.SAS_ROWID FROM dbo.SAPIO_Statuses s WITH (NOLOCK) WHERE s.SAS_CODE = 'W_PRZYGOTOWANIU')
		,@v_SAV_ID nvarchar(50) = CAST(NEWID() as nvarchar(50))
		,@v_SAV_CREUSER nvarchar(30) = @p_UserId
		,@v_SAV_CREDATE datetime = getdate()

	IF @v_SAV_CODE is null
	BEGIN
		EXEC dbo.VS_GetNumber  
			 @Type = 'SAV'
			,@Pref = 'SAV'
			,@Suff = ''
			,@Number = @v_SAV_CODE out
			,@No = null
	END

	INSERT INTO dbo.SAPIO_ActValuesHeaders
		(
			 SAV_CODE
			,SAV_TYPE
			,SAV_SASROWID
			,SAV_ID
			,SAV_ENTITY
			,SAV_ENTID
			,SAV_CREUSER
			,SAV_CREDATE
		)
	SELECT
		 @v_SAV_CODE
		,@p_SAV_TYPE
		,@v_SAV_SASROWID
		,@v_SAV_ID
		,@p_SAV_ENTITY
		,@p_SAV_ENTID
		,@v_SAV_CREUSER
		,@v_SAV_CREDATE

	SET @o_SAV_ROWID = SCOPE_IDENTITY();


	IF OBJECT_ID('tempDb..#SAV_ASSETS','u') IS NOT NULL
	BEGIN
		
		INSERT INTO dbo.SAPIO_ActValuesLines
			(SAL_SAVROWID,SAL_ASTROWID)
		SELECT 
			 @o_SAV_ROWID
			,AST_ROWID
		FROM #SAV_ASSETS

		EXEC dbo.SAPIO_ActValuesHeader_ChangeStatus
				 @p_SAV_ROWID = @o_SAV_ROWID
				,@p_SAV_SASCODE = 'DO_WYSYLKI'
	END
GO