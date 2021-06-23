SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STATION_Delete_Proc]   
(  
 @p_FormID nvarchar(50),  
 @p_ID nvarchar(50),    
  --- tutaj ewentualnie swoje parametry/zmienne/dane  
 @p_UserID nvarchar(30), -- uzytkownik  
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_date datetime  
 declare @v_Rstatus int  
 declare @v_Pref nvarchar(10)  
 declare @v_MultiOrg BIT 
 declare @stn_rowid int 

 select @stn_rowid = STN_ROWID from dbo.STATION where STN_ID = @p_ID
   
 if exists (select * from dbo.STATION (nolock) where STN_ID = @p_ID)  
 begin  
    
  BEGIN TRY 
  
	  if exists (select 1 from dbo.OBJSTATION where OSA_STNID = @stn_rowid)
	   begin 
		   select @v_syserrorcode = error_message()  
		   select @v_errorcode = 'OBG_004' -- blad usuwania  
		   goto errorlabel  
	   end
  
   delete from dbo.STATION where STN_ID = @p_ID  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OBG_003' -- blad usuwania  
   goto errorlabel  
  END CATCH;  
 end  
    
  
 return 0  
  
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
end  
GO