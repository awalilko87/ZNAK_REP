SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OBJ_Delete_Proc](
@p_OBJID int,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	
	if exists (select 1 from dbo.OBJASSET where OBA_OBJID = @p_OBJID)
	begin
		set @v_errortext = 'Nie można usunąć składnika. Składnik jest powiązany ze składnikiem SAP FI/AA'
		goto errorlabel
	end
	
	if exists (select 1 from dbo.OBJ where OBJ_PARENTID = @p_OBJID and OBJ_ROWID <> @p_OBJID)
	begin
		set @v_errortext = 'Nie można usunąć składnika. Składnik jest nadrzędnym dla innych składników'
		goto errorlabel
	end
	
	if exists (select 1 from dbo.OBJTECHPROTLN where POL_OBJID = @p_OBJID and POL_STATUS <> 'POL_004')
	begin
		set @v_errortext = 'Nie można usunąć składnika. Składnik został przypisany do protokołu oceny technicznej'
		goto errorlabel
	end
	
	begin try
		delete from dbo.OBJTECHPROTLN where POL_OBJID = @p_OBJID
		delete from dbo.PROPERTYVALUES where PRV_ENT = 'OBJ' and PRV_PKID = @p_OBJID
		delete from dbo.OBJSTATION where OSA_OBJID = @p_OBJID
		delete from dbo.OBJ where OBJ_ROWID = @p_OBJID
	end try
	begin catch
		set @v_errortext = error_message()
		goto errorlabel
	end catch
	
	return 0
	
errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO