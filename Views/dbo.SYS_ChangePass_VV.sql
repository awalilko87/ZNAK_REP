SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SYS_ChangePass_VV]
WITH ENCRYPTION
AS
SELECT     [UserID], [UserName], [Password]
FROM         [SYUsers]

GO