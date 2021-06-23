SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPI_Insert_Proc]
as
begin
 
 -- tylko do zasilenia inicjalnego
 --exec dbo.ZASILENIE_LAST_DATE
 
		--exec [dbo].[SAPI_DocStatus_Insert_Proc] 

		exec [dbo].[SAPI_DocStatus_ZMT_PM_Insert_Proc] 
	 
		exec [dbo].[SAPI_ErrorMessages_Insert_Proc]
 
		exec [dbo].[SAPI_ST_Insert_Proc] 
 
		exec [dbo].[SAPI_INW_Insert_Proc] 
 	 
		exec [dbo].[SAPI_PSP_Insert_Proc] 
 
		exec [dbo].[SAPI_MPK_Insert_Proc] 
 
		exec [dbo].[SAPI_KST_Insert_Proc] 
 
		exec [dbo].[SAPI_KONTRAHENCI_Insert_Proc] 
 
		exec [dbo].[SAPI_KLASYFIKATOR5_Insert_Proc]

		exec [dbo].[IE2_PM_DICTIONARY_Insert_Proc]


end 

--exec [dbo].[SAPI_Insert_Proc]
GO