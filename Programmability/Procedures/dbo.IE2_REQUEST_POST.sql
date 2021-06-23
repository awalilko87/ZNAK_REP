SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[IE2_REQUEST_POST]
as
begin

	if exists(select * from sysobjects where [name]= '__SLO_REQUEST_Dataitem')
	begin
		insert into SLO_REQUEST_POST
		select *,dt = getdate() from __SLO_REQUEST_Dataitem
		
		update dbo.IE2_DocRequest set
			FROM_DATE = case 
							when sap.ID_SLOWNIKA like 'ST[_]%' or sap.ID_SLOWNIKA like 'PSP[_]%' /*or sap.ID_SLOWNIKA = 'ST'*/ then FROM_DATE 
							else case
									when convert(varchar(5),getdate(),108) between '00:00' and '08:00' then convert(varchar,getdate()-1,112) 
									else convert(varchar,getdate(),112)
								end
						end
		from __SLO_REQUEST_Dataitem sap
		where IE2_DocRequest.ID_SLOWNIKA = sap.ID_SLOWNIKA
		
		/*
		declare @SLO_ID varchar(255)
		set @SLO_ID = (select top 1 ID_SLOWNIKA from [__SLO_REQUEST_Dataitem])
		update IE2_DOCREQUEST set FROM_DATE = GetDate() WHERE ID_SLOWNIKA = @SLO_ID 
		*/
	end
end
GO