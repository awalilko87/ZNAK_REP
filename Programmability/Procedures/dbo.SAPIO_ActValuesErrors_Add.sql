SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--Dodanie info o błędzie-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValuesErrors_Add]
	 @p_SAE_SAVROWID int
	,@p_SAE_MESSAGE nvarchar(500)
	,@p_SAE_DATA xml
AS

	INSERT INTO dbo.SAPIO_ActValuesErrors
		(SAE_SAVROWID,SAE_MESSAGE,SAE_DATA)
	SELECT
		 @p_SAE_SAVROWID, @p_SAE_MESSAGE,@p_SAE_DATA
GO