SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31DON_Recalculate] 
	(@p_OT31ID int)
as
begin
			--declare @v_ZMT_ROWID int
			--select @v_ZMT_ROWID = OT31_ZMT_ROWID from dbo.SAPO_ZWFOT31 (nolock) where OT31_ROWID = @p_OT31ID
			
			if (select COUNT(*) from dbo.SAPO_ZWFOT31LN (nolock) where OT31LN_OT31ID = @p_OT31ID) > 0
			begin
			
				--usuwanie nieaktywnych (widok SAPO_ZWFOT31DONv jest dynamiczny, tabela SAPO_ZWFOT31DON musi być aktualizowana) 
				delete from actual
				from dbo.SAPO_ZWFOT31DON actual 
					left JOIN ZWFOT31DONv calculated on 
						calculated.OT31DON_ANLN1 = actual.OT31DON_ANLN1 and 
						calculated.OT31DON_ANLN2 = actual.OT31DON_ANLN2 and 
						calculated.OT31DON_OT31ID = actual.OT31DON_OT31ID 
					where actual.OT31DON_OT31ID = @p_OT31ID and calculated.OT31DON_LP is null
					
				declare @c_DON_LP int
					, @c_DON_BUKRS nvarchar(30)
					, @c_DON_ANLN1 nvarchar(12)
					, @c_DON_ANLN2 nvarchar(4)
				
				declare OT31_LINES cursor for 
				select OT31DON_LP, OT31DON_BUKRS, OT31DON_ANLN1, OT31DON_ANLN2 
				from dbo.ZWFOT31DONv  
				where 
					OT31DON_OT31ID = @p_OT31ID
				
				open OT31_LINES
				
				fetch next from OT31_LINES
				into @c_DON_LP, @c_DON_BUKRS, @c_DON_ANLN1, @c_DON_ANLN2
				 
				while @@FETCH_STATUS = 0
				begin
					if not exists (select * from dbo.SAPO_ZWFOT31DON (nolock) where OT31DON_ANLN1 = @c_DON_ANLN1 and OT31DON_ANLN2 = @c_DON_ANLN2 and OT31DON_OT31ID = @p_OT31ID)
					begin
						insert into dbo.SAPO_ZWFOT31DON(OT31DON_LP, OT31DON_BUKRS, OT31DON_ANLN1, OT31DON_ANLN2, OT31DON_ZMT_ROWID, OT31DON_OT31ID)
						select @c_DON_LP, @c_DON_BUKRS, @c_DON_ANLN1, @c_DON_ANLN2, NULL, @p_OT31ID
					end
					else
					begin
						update dbo.SAPO_ZWFOT31DON set 
							OT31DON_LP = @c_DON_LP
						where OT31DON_ANLN1 = @c_DON_ANLN1 and OT31DON_ANLN2 = @c_DON_ANLN2  and OT31DON_OT31ID = @p_OT31ID
					end
					
					fetch next from OT31_LINES
					into @c_DON_LP, @c_DON_BUKRS, @c_DON_ANLN1, @c_DON_ANLN2
				end
								
				close OT31_LINES
				deallocate OT31_LINES
			end
end			 
GO