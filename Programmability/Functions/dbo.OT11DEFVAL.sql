SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[OT11DEFVAL](@p_FIELD nvarchar(50), @p_KEY nvarchar(30), @p_OBJKEYS nvarchar(max),@p_OBJ nvarchar(30))  
returns nvarchar(30)  
as  
begin  
 declare @v_ret nvarchar(30)  
  
 if @p_FIELD = 'OT11_GDLGRP_POSKI'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = KL5_CODE   
   from dbo.KLASYFIKATOR5   
   join dbo.STATION on STN_KL5ID = KL5_ROWID  
   join dbo.OBJSTATION on OSA_STNID = STN_ROWID  
   join dbo.OBJ on OBJ_ROWID = OSA_OBJID   
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  end  
  else  
  begin  
   select top 1  
    @v_ret = KL5_CODE --CCD_CODE + '0'  
   from INVTSK_NEW_OBJ (nolock)  
   join STATION (nolock) on STN_ROWID = INO_STNID  
   join COSTCODE (nolock) on CCD_ROWID = STN_CCDID  
   join KLASYFIKATOR5 on KL5_ROWID = STN_KL5ID  
   where INO_ROWID = @p_KEY  
  end  
 end  
 else if @p_FIELD = 'OT11_POSNR_POSKI'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = PSP_CODE   
   from dbo.PSP   
   join dbo.OBJ on OBJ_PSPID = PSP_ROWID   
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  end  
  else  
  begin  
   set @v_ret = @p_KEY  
  end  
 end  
 else if @p_FIELD = 'OT11_KOSTL_POSKI'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = CCD_CODE   
   from dbo.COSTCODE   
   join dbo.STATION on STN_CCDID = CCD_ROWID  
   join dbo.OBJSTATION on OSA_STNID = STN_ROWID  
   join dbo.OBJ on OBJ_ROWID = OSA_OBJID   
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  end  
  else  
  begin  
   select top 1  
    @v_ret = CCD_CODE  
   from INVTSK_NEW_OBJ (nolock)  
   join STATION (nolock) on STN_ROWID = INO_STNID  
   join COSTCODE (nolock) on CCD_ROWID = STN_CCDID  
   where INO_ROWID = @p_KEY  
  end  
 end  
 else if @p_FIELD = 'OT11_TYP_SKLADNIKA'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   set @v_ret = '2'  
  end  
  else  
  begin  
   select top 1 @v_ret = case     
      when isnull(INO_STNID,0) = 0 then 2     
     else   
      case when INO_TXT12 is not null then 2 else 1 end -- OBJ_TXT12 - doniesienie lub nowy składnik  
     end     
     from dbo.INVTSK_NEW_OBJ (nolock)     
     where INO_ROWID = @p_KEY   
  end  
 end  
  
/*NOWE - na potrzeby obsługi doniesień do wartości - zgłaszenie PKATA_878*/  
  else if @p_FIELD = 'OT11_ANLN1_POSKI'    
  begin    
   if @p_OBJKEYS <> ''    
   begin    
    select    
   @v_ret = NULL  
   end    
   else    
   begin    
    select top 1    
   @v_ret = AST_CODE    
     from INVTSK_NEW_OBJ (nolock)      
     join OBJ (nolock) on OBJ_INOID = INO_ROWID  
     left join OBJASSET on OBA_OBJID = OBJ_ROWID  
     left join ASSET  on AST_ROWID = OBA_ASTID  
     where INO_ROWID = @p_KEY  
   end    
 end  
 /*### NOWE ###*/  
  
 else if @p_FIELD = 'OT11_MUZYTKID'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = OSA_STNID   
   from dbo.OBJSTATION  
   join dbo.OBJ on OBJ_ROWID = OSA_OBJID   
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  end  
  else  
  begin  
   select top 1   
    @v_ret = STN_ROWID  
   from INVTSK_NEW_OBJ (nolock)  
   join STATION (nolock) on STN_ROWID = INO_STNID  
   join COSTCODE (nolock) on CCD_ROWID = STN_CCDID  
   where INO_ROWID = @p_KEY  
  end  
 end  
 else if @p_FIELD = 'OT11_WOJEWODZTWO'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = STN_VOIVODESHIP   
   from dbo.STATION  
   join dbo.OBJSTATION on OSA_STNID = STN_ROWID  
   join dbo.OBJ on OBJ_ROWID = OSA_OBJID   
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  end  
  else  
  begin  
   select top 1   
    @v_ret = STN_VOIVODESHIP   
   from dbo.STATION  
   join dbo.INVTSK_NEW_OBJ on INO_STNID = STN_ROWID   
   where INO_ROWID = @p_KEY  
  end  
 end  
----------------------------------------------------------

/*Wartość domyślna na symbolu KsT*/
  else if @p_FIELD = 'OT11_ANLKL_POSKI'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
	select top 1 @v_ret =  AST_SAP_ANLKL from ASSET 
	where AST_CODE = (select AST_CODE from ASSET where AST_ROWID 
	in (select OBA_ASTID from OBJASSET where OBA_OBJID in 
	(select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')))
  end  
  else  
  begin  
	select top 1 @v_ret =  AST_SAP_ANLKL from ASSET 
	where AST_CODE = (select AST_CODE from ASSET where AST_ROWID 
	in (select OBA_ASTID from OBJASSET where OBA_OBJID in 
	(select OBJ_ROWID from OBJ where OBJ_CODE = @p_OBJ)))
  end  
 end  
 --------------------------------------------------------------


 else if @p_FIELD = 'OT11_WART_NAB_PLN'  
 begin  
  if @p_OBJKEYS <> ''  
  begin  
   select top 1   
    @v_ret = sum(OBJ_VALUE)   
   from dbo.OBJ  
   where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> '')  
  
   set @v_ret = nullif(@v_ret, '')  
  end  
  else  
  begin  
   select top 1   
    @v_ret = OBJ_VALUE  
   from dbo.OBJ   
   where OBJ_CODE = @p_KEY  
  
   set @v_ret = nullif(@v_ret, '')  
  end  
 end  
  
 return @v_ret  
end  
GO