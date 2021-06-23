SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_Remove](
    @MapID nvarchar(50),
    @_USERID_ varchar(20) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYExMaps
            WHERE MapID = @MapID
GO