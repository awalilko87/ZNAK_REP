SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[TrainingExport_RPT]
as
select
MessageID = null
,PERSONID = convert(int,null)
,TrainingGroupId = convert(int,null)
,PER_CODE = convert(nvarchar(30),null) collate latin1_general_bin
,PER_FIRSTNAME = convert(nvarchar(30),null) collate latin1_general_bin
,PER_LASTNAME = convert(nvarchar(30),null) collate latin1_general_bin
,PER_ELUSERID = convert(nvarchar(30),null) collate latin1_general_bin
,PER_ELPASS = convert(nvarchar(30),null) collate latin1_general_bin
,TrainingDate = convert(datetime,null)
GO