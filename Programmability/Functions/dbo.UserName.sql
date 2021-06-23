SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--select dbo.UserName('jr')  
  
CREATE function [dbo].[UserName](@p_UserID nvarchar(30))  
returns nvarchar(1000)  
as  
begin  
 declare @v_ret nvarchar(255)  
  
 select @v_ret =  
 case when @p_UserID like 'XLS_%' then (select 'XLS_' + UserName from dbo.SYUsers (nolock) where UserID = right(@p_UserID, LEN (@p_UserID)-4)) 
 else 
 (select UserName from dbo.SYUsers (nolock) where UserID = @p_UserID)
 end
  
 return @v_ret  
end
GO