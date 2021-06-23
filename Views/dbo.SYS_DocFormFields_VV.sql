SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocFormFields_VV]
AS
SELECT     FieldID, FormID, Caption, IsPK, ControlType, DataType, PanelGroup, FieldDesc, AllowReportParam
FROM         dbo.VS_FormFields

GO