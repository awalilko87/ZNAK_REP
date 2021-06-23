SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		DG
-- Create date: 2020-12-14
-- Description:	Update z kalkulatora % likwidacji częściowej
-- =============================================
CREATE PROCEDURE [dbo].[POT_Partial_Removal_Calc] 
@p_POL_POTID int,
@p_POL_ID nvarchar(60),
@p_USER nvarchar(100),
@p_POL_NTX02 numeric(24,6),
@p_POL_NTX03 numeric(24,6)
AS
BEGIN

	if exists (select 1 from OBJTECHPROTLN where POL_POTID = @p_POL_POTID and POL_ID = @p_POL_ID)
		begin
			if (@p_POL_NTX03 <= 0 or @p_POL_NTX03 > 99)
				begin
					raiserror( 'Błąd! Procent częściowej likwidacji musi być większy niż 0 i nie może przekroczyć 99!',18,1)
				end
			else
				begin
					update OBJTECHPROTLN set
					POL_UPDDATE = getdate()
					, POL_UPDUSER = @p_USER
					, POL_NTX02 = @p_POL_NTX02
					, POL_NTX03 = @p_POL_NTX03
					where POL_POTID = @p_POL_POTID and POL_ID = @p_POL_ID
				end
		end

	else
		begin
			raiserror( 'Błąd! Nie zaktualizowano wartości!',16,1)
		end

END

GO