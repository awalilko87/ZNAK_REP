SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[COSTCLASSIFICATIONv]
as
select 
	  [CCF_ROWID]
      ,[CCF_CODE]
      ,[CCF_ORG]
      ,[CCF_DESC]
      ,[CCF_CREUSER]
      ,[CCF_CREDATE]
      ,[CCF_UPDUSER]
      ,[CCF_UPDDATE]
      ,[CCF_NOTUSED]
      ,[CCF_SAP_Active]
      ,[CCF_SAP_ANLKL]
      ,[CCF_SAP_TXK50]
      ,[CCF_SAP_BUKRS]
      ,[CCF_SAP_KTOGR]
from [dbo].[COSTCLASSIFICATION] (nolock)
 
GO