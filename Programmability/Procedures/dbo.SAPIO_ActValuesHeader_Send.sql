SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--Zmiana status na "wyślij"-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValuesHeader_Send]
	 @p_SAV_ROWID int
AS

	DECLARE 
		@v_SAV_SASROWID int = (SELECT s.SAS_ROWID FROM dbo.SAPIO_Statuses s WITH (NOLOCK) WHERE s.SAS_CODE = 'DO_WYSYLKI') 

		UPDATE dbo.SAPIO_ActValuesHeaders
		SET SAV_SASROWID = @v_SAV_SASROWID
		WHERE SAV_ROWID = @p_SAV_ROWID 

GO