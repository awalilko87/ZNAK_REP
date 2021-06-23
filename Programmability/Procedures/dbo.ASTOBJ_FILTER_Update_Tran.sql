SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ASTOBJ_FILTER_Update_Tran]
(
  @p_FormID nvarchar(50),
  @p_ID nvarchar(50), 
  @p_CODE nvarchar (30),
  @p_DESC nvarchar (80),
  @p_GROUP nvarchar (30),
  @p_STATION nvarchar (30),
  @p_TYPE nvarchar (30), 
  @p_PSP nvarchar (30), 
  @p_ASSET nvarchar (30), 
  @p_CREUSER nvarchar (30),
  @p_CREDATE datetime,
  @p_NOTUSED int,
  
  --- tutaj ewentualnie swoje parametry/zmienne/dane
 
  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[ASTOBJ_FILTER_Update_Proc] 
		@p_FormID,
		@p_ID, 
		@p_CODE,
		@p_DESC,
		@p_GROUP,
		@p_STATION,
		@p_TYPE,
		@p_PSP,
		@p_ASSET,
		@p_CREUSER,
		@p_CREDATE,
		@p_NOTUSED,
   
--- swoje ewentualnie

----
		@p_UserID, 
		@p_apperrortext output
		
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