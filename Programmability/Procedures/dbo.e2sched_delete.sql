SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[e2sched_delete]
	@rowid int
AS
BEGIN
	DELETE FROM e2sched where rowid=@rowid
END
GO