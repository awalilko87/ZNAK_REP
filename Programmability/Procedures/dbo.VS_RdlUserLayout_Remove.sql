SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_RdlUserLayout_Remove](
    @Rowid int
)
WITH ENCRYPTION
AS

    DELETE
        FROM VS_RdlUserLayout
            WHERE Rowid = @Rowid
GO