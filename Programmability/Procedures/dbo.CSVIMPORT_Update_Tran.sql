SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CSVIMPORT_Update_Tran]
(
	 @p_Pole nvarchar(30),
	 @p_Wartosc nvarchar(80),
	 @p_Zrodlo nvarchar(6),
	 @p_UserID nvarchar(30) = NULL -- uzytkownik
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[CSVIMPORT_Update_Proc] 
	 @p_Pole,
	 @p_Wartosc,
	 @p_Zrodlo,
	 @p_UserID

  if @v_errorid = 0
  begin
    commit transaction
    return 0
  end
  else
  begin
    rollback transaction
    return 1
  end
end


GO