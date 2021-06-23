SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocReports_VV]
AS
SELECT     ReportID, ReportName, ReportCaption, OutputType
FROM         dbo.SYReports

GO