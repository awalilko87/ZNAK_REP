SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
  
CREATE Procedure [dbo].[Get_UnMatchAttachments]
AS
/****** Procedura ususwa niepodpięte do żadnego elementu załączniki ******/
/****** Ze względu na zróżnicowan sposoby działania załączników procedura do nadpisania przez konsultantów ******/
select * from SYFiles where 0=1
GO