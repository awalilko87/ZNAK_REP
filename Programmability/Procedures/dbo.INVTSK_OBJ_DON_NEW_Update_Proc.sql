SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_OBJ_DON_NEW_Update_Proc]  
(  
  @p_ROWID int  
 ,@p_PSP nvarchar(30)
 ,@p_STNID int  
 ,@p_ZMT_CODE int
 ,@p_UserID nvarchar(30) = NULL -- uzytkownik  
 ,@p_apperrortext nvarchar(4000) = null output  
)  
as  
	BEGIN 
     
 declare @v_errorcode nvarchar(50)  
  , @v_syserrorcode nvarchar(4000)  
  , @v_errortext nvarchar(4000)  
  , @v_date datetime  
  , @v_PSPID int   
  , @v_STSID int   
  , @v_EXSTSID int  
  , @v_STS_CODE nvarchar(30)  
  , @v_OBJ_COUNT int  
  , @v_OTID int  
  , @v_SETTYPE nvarchar(30)  
  , @v_OPER_TYPE nvarchar(10)  
  , @v_ITSID int
  , @v_OBJ_INOID_OLD int


 set @v_date = getdate()  
    
 select @v_PSPID = PSP_ROWID, @v_ITSID = PSP_ITSID from PSP (nolock) where PSP_CODE = @p_PSP  
 select @v_STSID = OBJ_STSID, @v_OBJ_INOID_OLD = OBJ_INOID from OBJ where OBJ_ROWID = @p_ZMT_CODE


  
 --wystawiony składnik (przynajmniej jeden)  
 select top 1   
  @v_OBJ_COUNT = COUNT(*),  
  @v_EXSTSID = OBJ_STSID,  
  @v_OTID = OT_ROWID  
 from [INVTSK_NEW_OBJ] (nolock)  
  join STENCIL (nolock) on STS_ROWID = INO_STSID  
  join SETTYPE (nolock) on STT_CODE = STS_SETTYPE  
  left join OBJ (nolock) on OBJ_INOID = INO_ROWID  
  left join ZWFOT (nolock) on OT_INOID = INO_ROWID  
 where INO_ROWID = @p_ROWID   
 group by OBJ_STSID,OT_ROWID  
  
      
 --if @v_OPER_TYPE = 'INSERT'  
 -- select @p_ROWID = NULL  
   
 if @p_ROWID is null  
		 begin  
		  --usuwa stare wpisy (dla których żaden składnik nie powstał) 
		  ;with ob as (select OBJ_INOID from dbo.OBJ where OBJ_INOID is not null) 
		  delete from [INVTSK_NEW_OBJ] where INO_CREUSER = @p_UserID and not exists (select 1 from ob where isnull(OBJ_INOID,0) = INO_ROWID)
			and not exists (select 1 from ZWFOT where ino_rowid = ot_inoid)  
     
		  insert into [INVTSK_NEW_OBJ] (INO_ITSID, INO_QTY, INO_STSID, INO_PSPID, INO_STNID, INO_CODE, INO_ORG, INO_DESC, INO_DATE, INO_STATUS, INO_TYPE, INO_TYPE2, INO_TYPE3, INO_RSTATUS, INO_CREUSER, INO_CREDATE, INO_NOTUSED, INO_ID, INO_TXT12)  
		  select @v_ITSID, 1, STS_ROWID, @v_PSPID, @p_STNID, NULL, STS_ORG, '', getdate(), NULL, NULL, NULL, NULL, 0, @p_UserID, getdate(), 0, newid(), 'DON'  
		  from STENCIL (nolock) where STS_ROWID = @v_STSID  
   END

	  /*Jeżeli składnik został dodany z zadania inwestycyjnego updatujemy pole INO_ID nową wartością a starą wartość zapisujemy do pola OBJ_TXT12*/

		  select @p_ROWID = IDENT_CURRENT('dbo.INVTSK_NEW_OBJ')  

		  --raiserror(@p_ZMT_CODE,16,1) 

		  update OBJ
		  set OBJ_INOID = @p_ROWID
		  ,OBJ_TXT12 = @v_OBJ_INOID_OLD
		  ,OBJ_PSPID = @v_PSPID
		  where OBJ_ROWID = @p_ZMT_CODE
	 end  
  
	  raiserror(N'Składnik poprawnie dodany do listy.',1,1) 



 --errorlabel:  
 -- exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
 -- raiserror (@v_errortext, 16, 1)   
 -- select @p_apperrortext = @v_errortext  
 -- return 1  
  


GO