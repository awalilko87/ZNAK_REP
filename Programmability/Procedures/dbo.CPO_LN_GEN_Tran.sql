SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[CPO_LN_GEN_Tran]          
(          
 @p_POTID int,
 @p_UserID nvarchar(30),           
 @p_apperrortext nvarchar(4000) = null output          
)          
as          
begin          
  declare @v_errorid int          
  declare @v_errortext nvarchar(4000)           
  select @v_errorid = 0          
  select @v_errortext = null          
          
  begin transaction          
    exec @v_errorid = dbo.CPO_LN_GEN_Proc           
	@p_POTID,
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