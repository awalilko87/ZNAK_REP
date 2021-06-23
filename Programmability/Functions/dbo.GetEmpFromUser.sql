SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetEmpFromUser](@p_UserID nvarchar(30),@p_ORG nvarchar(30), @p_FormID nvarchar(50) = NULL)  
returns nvarchar(30)  
as  
begin  
 declare @v_EMP nvarchar(30)  
  
 select @v_EMP = DefWorkerID from dbo.SYUsers(nolock) where UserID = @p_UserID  
  
 if @p_ORG is null select @p_ORG = dbo.GetOrgDef(@p_FormID,@p_UserID)

 if exists (select * from dbo.EMP(nolock) where EMP_CODE = @v_EMP and EMP_ORG in (isnull(@p_ORG,'*'),'*'))  
 begin  
  return @v_EMP  
 end  
 else  
 begin  
  select @v_EMP = null  
 end  
   
 return @v_EMP  
end
GO