SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[E2_SAP2ZMT_SetActResp]
	 @ZmtGetActValueRequestId nvarchar(60)
	,@Anln1 nvarchar(60)
	,@Anln2 nvarchar(60)
	,@Wartoscpocz numeric(24,6)
	,@Wartoscnetto numeric(24,6)
	,@OkrAmort nvarchar(60)
AS

	INSERT INTO dbo.E2_SAP2ZMT_ActResp
		(
			 ZmtGetActValueRequestId
			,Anln1
			,Anln2
			,Wartoscpocz
			,Wartoscnetto
			,OkrAmort
			,CREDATE
		)
	SELECT
		 @ZmtGetActValueRequestId
		,@Anln1
		,@Anln2
		,@Wartoscpocz
		,@Wartoscnetto
		,@OkrAmort
		,getdate()
GO