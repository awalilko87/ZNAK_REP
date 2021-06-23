SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_DataSpy_Remove](
    @DataSpyID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    DELETE FROM dbo.VS_DataSpy WHERE DataSpyID = @DataSpyID
            
    DELETE FROM dbo.VS_DataSpyUsers WHERE DataSpyID = @DataSpyID      
GO