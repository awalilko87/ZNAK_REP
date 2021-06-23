SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create proc [dbo].[SP_REQUEST_Delete]
(
@p_SRQ_ROWID int -- id zgłoszenia ruchu
)as 
begin 

	if exists (select 1 from SP_REQUEST where SRQ_ROWID = @p_SRQ_ROWID)
		begin
			declare @p_SRQ_OBJ int
			select @p_SRQ_OBJ = SRQ_OBJID from SP_REQUEST where SRQ_ROWID = @p_SRQ_ROWID

			if exists (select 1 from OBJ where obj_rowid = @p_SRQ_OBJ and OBJ_STATUS <> 'OBJ_002')
				begin
					update dbo.OBJ
					set OBJ_STATUS = 'OBJ_002'
					where OBJ_ROWID = @p_SRQ_OBJ
				end

			delete from SP_REQUEST where SRQ_ROWID = @p_SRQ_ROWID
		end

	RaisError ('Zgłoszenie poprawnie usunięte.',1,1)

end
GO