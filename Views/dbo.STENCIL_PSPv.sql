﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[STENCIL_PSPv]
AS
SELECT        PSP_CODE, STS_ROWID
FROM            dbo.STENCIL_PSP AS s


GO