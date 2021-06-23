SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_RemoveFooterByRepIDTabName](
    @ReportID nvarchar(50),
    @TableName nvarchar(50),
    @_USERID_ varchar(20) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYExMaps
            WHERE ReportID = @ReportID AND TableName = @TableName AND [Type] = 'FOOTER'
GO