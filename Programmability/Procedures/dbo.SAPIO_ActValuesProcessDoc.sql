SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SAPIO_ActValuesProcessDoc](
@p_SAVCODE nvarchar(30) = null
)
as
begin
	declare @v_errordata xml

	declare @c_SAVID int
	declare @c_ENTITY nvarchar(30)
	declare @c_ENTID int
	declare @c_ASTID int
	declare @c_INITIALVALUE numeric(24,2)
	declare @c_NETVALUE numeric(24,2)
	declare @c_AMORTIZATIONPERIOD nvarchar(30)

	declare cH cursor for select SAV_ROWID, SAV_ENTITY, SAV_ENTID from dbo.SAPIO_ActValuesHeaders where SAV_SASROWID = 601 and SAV_CODE = isnull(@p_SAVCODE, SAV_CODE)
	open cH
	fetch next from cH into @c_SAVID, @c_ENTITY, @c_ENTID
	while @@fetch_status = 0
	begin
		declare cL cursor for select SAL_ASTROWID, SAL_INITIALVALUE, SAL_NETVALUE, ltrim(rtrim(SAL_AMORTIZATIONPERIOD)) from dbo.SAPIO_ActValuesLines where SAL_SAVROWID = @c_SAVID order by SAL_ROWID
		open cL
		fetch next from cL into @c_ASTID, @c_INITIALVALUE, @c_NETVALUE, @c_AMORTIZATIONPERIOD
		while @@fetch_status = 0
		begin
			begin try
				if @c_ENTITY = 'POT'
				begin
					update pol set
						 POL_NTX01 = @c_NETVALUE
						,POL_DTX01 = getdate()
					from dbo.OBJTECHPROTLN pol
					inner join dbo.OBJTECHPROT on POT_ROWID = POL_POTID
					inner join dbo.OBJASSETv on OBJ_ROWID = POL_OBJID and OBJ_PARENTID = OBJ_ROWID
					where AST_ROWID = @c_ASTID
					and POT_STATUS in ('POT_001', 'POT_002')
					and POL_STATUS = 'POL_004'
				end
				else if @c_ENTITY = 'OT11'
				begin
					update dbo.SAPO_ZWFOT11 set
						 OT11_NETVALUE = @c_NETVALUE
						,OT11_AKT_OKR_AMORT = @c_AMORTIZATIONPERIOD
						,OT11_ACTVALUEDATE = getdate()
					where OT11_ZMT_ROWID = @c_ENTID
					and OT11_IF_STATUS <> 4
				end

				update dbo.ASSET set
					 AST_INITIALVALUE = @c_INITIALVALUE
					,AST_NETVALUE = @c_NETVALUE
					,AST_AMORTIZATIONPERIOD = @c_AMORTIZATIONPERIOD
					,AST_ACTVALUEDATE = getdate()
				where AST_ROWID = @c_ASTID
			end try
			begin catch
				--set @v_errortext = @v_errortext+'ASTID:'+convert(varchar, @c_ASTID)+' ['+error_message()+']|'
				set @v_errordata = (select * from(
					select 
						t.x.value('SAL_ROWID[1]','int') as SAL_ROWID,
						t.x.value('SAL_ASTROWID[1]','int') as SAL_ASTROWID
						from @v_errordata.nodes('/Data/Line') t(x)
						union all
						select 
						SAL_ROWID
						,SAL_ASTROWID
						from SAPIO_ActValuesLines
						where SAL_SAVROWID = 18
						and SAL_NETVALUE is not null)d
					FOR XML PATH('Line'), ROOT('Data')
				)
			end catch
			
			fetch next from cL into @c_ASTID, @c_INITIALVALUE, @c_NETVALUE, @c_AMORTIZATIONPERIOD
		end
		deallocate cL

		if (select count(*) from @v_errordata.nodes('/Data/Line') t(x)) > 0
		begin
			exec dbo.SAPIO_ActValuesErrors_Add
				 @p_SAE_SAVROWID = @c_SAVID
				,@p_SAE_MESSAGE = 'Błąd podczas przetwarzania biznes'
				,@p_SAE_DATA = @v_errordata
					
			exec dbo.SAPIO_ActValuesHeader_ChangeStatus
				 @p_SAV_ROWID = @c_SAVID
				,@p_SAV_SASCODE = 'PRZETWORZONO_ODP_BIZNES_BLAD'
		end
		else
		begin
			exec dbo.SAPIO_ActValuesHeader_ChangeStatus
				 @p_SAV_ROWID = @c_SAVID
				,@p_SAV_SASCODE = 'PRZETWORZONO_ODPOWIEDZ_BIZNES'
		end

		fetch next from cH into @c_SAVID, @c_ENTITY, @c_ENTID
	end
	deallocate cH
		

end
GO