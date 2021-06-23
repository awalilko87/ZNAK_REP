SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetFilesCodeFromEntity] (@p_ENTITY nvarchar(4), @p_PK1 nvarchar(50), @p_PK2 nvarchar(50), @p_PK3 nvarchar(50))  
returns nvarchar(50)  
as  
begin  
 declare @v_Code nvarchar(50)  
  
 if @p_Entity = ('')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('OBJ')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('AGR')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('EVT')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('OPL')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('EMP')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('VEN')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('MFC')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('AST')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('LOC')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('OBG')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('TSK')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('ASS')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('RST')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('REQ')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('PRD')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('WRC')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('ORD')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('CFG')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('TSI')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('SIN')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('TOO')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('SRW')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('IVO')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('PKT')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('STS')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else  
 if @p_Entity = ('POT')  
  set @v_Code = @p_PK1+'#'+@p_PK2  
   else  
 if @p_Entity = ('CPO')  
  set @v_Code = @p_PK1+'#'+@p_PK2 
 else  
 if @p_Entity like ('OT%') --wszystkie OT (11,12,21,31,32,33,40,41,42) tak samo  
  set @v_Code = @p_PK1+'#'+@p_PK2  
 else   
  select @v_Code = null  
  
 return (@v_Code)  
end  
  
  
  
GO