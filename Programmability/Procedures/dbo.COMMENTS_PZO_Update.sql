SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[COMMENTS_PZO_Update](    
    @p_ID nvarchar(50),    
    @p_ENTITY nvarchar(30),    
    @p_TEXT nvarchar(max),    
    @p_UserID varchar(20) = NULL    
)    
AS    
begin    
  declare @v_errorcode nvarchar(50)    
  declare @v_syserrorcode nvarchar(4000)    
  declare @v_errortext nvarchar(4000)    
      
    
if @p_ID is null or @p_ENTITY is null-- ## dopisac klucze    
  begin    
    select @v_errorcode = 'SYS_003'    
 goto errorlabel    
  end    
    
if rtrim(ltrim(isnull(@p_TEXT,''))) = ''    
begin    
 select @v_errorcode = 'SYS_021'    
 goto errorlabel    
end       
    
 BEGIN TRY    
   insert into dbo.COMMENTS    
   (    
    COM_ENTITY    
  , COM_ID    
  , COM_TEXT    
  , COM_DATE    
  , COM_USER    
   )    
   values    
   (    
    @p_ENTITY    
  , @p_ID    
  , @p_TEXT    
  , getdate()    
  , @p_UserID    
   )    
    END TRY    
    BEGIN CATCH    
    raiserror (@p_ENTITY,16,1)    
   select @v_errorcode = 'SYS_012'    
   goto errorlabel    
    END CATCH    
    
     
    
  return 0    
  errorlabel:    
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
    return 1    
end    
    
/*    
exec COMMENTS_Update    
'D4C6F846-89ED-48AB-B59C-AAD706FF9B67'    
, 'EVT'    
, 'test'    
, 'JR'      
*/    
GO