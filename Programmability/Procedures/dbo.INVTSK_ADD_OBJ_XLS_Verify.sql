SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_XLS_Verify]   
(   
@p_UserID nvarchar(30)  
)  
 as   
 begin   
   
 declare    
  @v_PARENTID int,  
  @v_STSID int,  
  @c_STN nvarchar(30),  
  @v_STNID int,  
  @v_PSPID int,  
  @v_OBJID int,  
  @v_ASTID int,  
  @c_STS nvarchar(255), --STS_CODE   
  @v_STS_PARENT nvarchar(255), --STS_CODE_PARENT  
  @c_VALUE nvarchar(255), --VALUE  
  @c_QTY nvarchar(255), --QTY  
  @v_COUNT int = 0, --QTY  
  @v_INOID int = 0 ,  
  @v_ITSID int,  
  @c_PARENT_OBJ nvarchar(30),  
  @c_ROWID int,  
  @v_errorcode nvarchar(50),  
  @v_errortext nvarchar(4000),  
  @v_syserrorcode nvarchar(4000),  
  @p_apperrortext nvarchar(max),
  @c_DEVICE_PM_NUMBER nvarchar(max);  
  
 declare c_XLS cursor for  
 select rowid, c01, c02, c03, replace(replace(nullif(c04,''),',','.'),' ',''), replace(replace(nullif(c05,''),',','.'),' ',''), c09 from dbo.INVTSK_ADD_OBJ_XLS where importuser = @p_UserID order by rowid  
 open c_XLS  
 fetch next from c_XLS into @c_ROWID, @c_STN, @c_STS, @c_PARENT_OBJ, @c_QTY, @c_VALUE, @c_DEVICE_PM_NUMBER  
 while @@FETCH_STATUS = 0   
 begin  
  set @v_errortext = ''  
  
  if isnumeric(@c_QTY) = 0 and @c_QTY is not null  
  begin  
   set @v_errortext = 'Ilość nie jest numeryczna;'  
  end  
  
  if isnumeric(@c_VALUE) = 0 and @c_VALUE is not null  
  begin  
   set @v_errortext = @v_errortext+'Wartość nie jest numeryczna;'  
  end  
  
  --if isnull(@c_STS,'') = ''  
  --begin  
  -- set @v_errortext = @v_errortext+'Szablon nie może być pusty;'  
  --end  
  

  if @c_STS <> '' and  not exists (select 1 from dbo.STENCIL where STS_CODE = @c_STS and STS_NOTUSED = 0)  
		  begin  
			 set @v_errortext = @v_errortext+'Szablon nie istnieje lub jest nieaktywny;'  
		  end  

  
  if @c_PARENT_OBJ <> '' and not exists (select 1 from dbo.OBJ where OBJ_CODE = @c_PARENT_OBJ and OBJ_PARENTID = OBJ_ROWID and OBJ_NOTUSED = 0)  
  begin  
   set @v_errortext = @v_errortext+'Składnik nadrzędny nie istnieje lub jest nieaktywny;'  
  end  
  
  if not exists (select 1 from dbo.STATION where convert(varchar,STN_CODE) = @c_STN and STN_TYPE in ('STACJA', 'SERWIS'))  
  begin  
   set @v_errortext = @v_errortext+'Stacja nie jest zdefiniowana w systemie;'  
  end  
  
  --IF NOT EXISTS (SELECT obj_rowid FROM OBJ WHERE OBJ_PM = @c_DEVICE_PM_NUMBER) ---- Czy urządzenie SAP PM istnieje
  --begin  
  -- set @v_errortext = @v_errortext+'Nie istnieje wcześniej utworzone urządzenie w SAP PM;'  
  --end  

  if @v_errortext <> ''  
  begin  
   update dbo.INVTSK_ADD_OBJ_XLS set  
    ErrorMessage = @v_errortext  
   where rowid = @c_ROWID  
  end  
    
  fetch next from c_XLS into @c_ROWID, @c_STN, @c_STS, @c_PARENT_OBJ, @c_QTY, @c_VALUE, @c_DEVICE_PM_NUMBER  
  
 end  
  
 close c_XLS   
 deallocate c_XLS   
  
   
return 0  
  
errorlabel:  
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
 raiserror (@v_errortext, 16, 1)   
 return 1    
end  

GO