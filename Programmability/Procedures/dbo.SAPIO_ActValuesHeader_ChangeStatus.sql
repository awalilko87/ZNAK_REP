SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--Zmiana statusu-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SAPIO_ActValuesHeader_ChangeStatus]
	 @p_SAV_ROWID int
	,@p_SAV_SASCODE nvarchar(30)
AS

	DECLARE 
		@v_SAV_SASROWID int = (SELECT s.SAS_ROWID FROM dbo.SAPIO_Statuses s WITH (NOLOCK) WHERE s.SAS_CODE = @p_SAV_SASCODE) 

		UPDATE dbo.SAPIO_ActValuesHeaders
		SET SAV_SASROWID = @v_SAV_SASROWID
			,SAV_UPDDATE = getdate()
		WHERE SAV_ROWID = @p_SAV_ROWID 

GO