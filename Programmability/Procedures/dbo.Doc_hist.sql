SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create proc [dbo].[Doc_hist]
as 

select * from 
vs_audit


select * from  docentities where dae_entity = 'OBJ'   
GO