SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_Remove](
    @ID int,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE FROM SYUserActivity WHERE ID = @ID
GO