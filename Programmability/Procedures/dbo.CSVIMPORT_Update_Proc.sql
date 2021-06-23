SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CSVIMPORT_Update_Proc] 
(
	 @p_Pole nvarchar(30),
	 @p_Wartosc nvarchar(80),
	 @p_Zrodlo nvarchar(6),
	 @p_UserID nvarchar(30) = NULL -- uzytkownik)
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
--  declare @v_date datetime
--  declare @v_Rstatus int
--  declare @v_Pref nvarchar(10)
--  declare @v_MultiOrg bit
 
 select * from dbo.CSVIMPORT (nolock) where Pole = 'C1' and [KodZrodla] = 'ASTOBJ'

 --insert
	if not exists (select * from dbo.CSVIMPORT (nolock) where Pole = @p_Pole and [KodZrodla] = @p_Zrodlo)
	begin

      BEGIN TRY
		INSERT INTO [dbo].[CSVIMPORT]
			   ([Pole]
			   ,[Wartosc]
			   ,[KodZrodla])
		 VALUES
			   (@p_Pole
			   ,@p_Wartosc
			   ,@p_Zrodlo)


	  END TRY
	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'UOM_001' -- blad wstawienia
		goto errorlabel
	  END CATCH;
	end
    else
    begin 
		BEGIN TRY
		  UPDATE dbo.CSVIMPORT SET
			Pole = @p_Pole
			,Wartosc = @p_Wartosc 
		  where Pole = @p_Pole and [KodZrodla] = @p_Zrodlo 

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'UOM_002' -- blad aktualizacji zgloszenia
			goto errorlabel
		END CATCH;
  end
  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    return 1
end

GO