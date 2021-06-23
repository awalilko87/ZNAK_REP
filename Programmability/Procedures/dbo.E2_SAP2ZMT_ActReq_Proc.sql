SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[E2_SAP2ZMT_ActReq_Proc]
AS



		SELECT '1210058' as Anln1, '0000' as Anln2
UNION	SELECT '1809410' as Anln1, '0000' as Anln2
UNION	SELECT '3001244' as Anln1, '0000' as Anln2

SELECT REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(nvarchar(30),getdate(),121),'-',''),' ','_'),':',''),'.','') as ZmtGetActValueRequestId

GO