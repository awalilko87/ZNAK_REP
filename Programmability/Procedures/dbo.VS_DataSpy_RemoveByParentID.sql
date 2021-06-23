SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_RemoveByParentID](
    @ParentID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    DELETE
        FROM VS_DataSpy
            WHERE ParentID = @ParentID
GO