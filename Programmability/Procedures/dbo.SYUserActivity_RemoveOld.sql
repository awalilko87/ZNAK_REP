SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_RemoveOld](
    @timeout int
)
WITH ENCRYPTION
AS
    DELETE FROM SYUserActivity WHERE DATEADD(minute,@timeout, LastUpdate) < GETDATE() AND UserID != 'SA'
GO