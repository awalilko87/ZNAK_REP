SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[UD_SAMPLE_VV]
AS
SELECT     ID, pValue, pDesc, Type, Type2, Type3, Type4
FROM         dbo.VS_UDictionary
WHERE     (Type = N'SAMPLE')

GO