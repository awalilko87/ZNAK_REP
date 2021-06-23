SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[ParseJsonFiles](@json nvarchar(max))    
 as    
     
 declare @result table(fileGuid uniqueidentifier, [fileName] nvarchar(255), fileSize int)    
 declare @tmp table(name nvarchar(255), value nvarchar(255))    
     
 declare @name nvarchar(255),    
         @value nvarchar(max)    
     
 declare @fileName nvarchar(255),    
         @fileGuid nvarchar(36),    
         @fileSize int    
     
--{"fileGuid":"f93de361-c679-46c3-b08c-c62beded1061","fileName":"logo0.png","fileSize":"5681"}    
--{"fileGuid":"2431eb66-c536-4388-b3bb-4b2a2a6983d7","fileName":"gradient2.png","fileSize":"117"}    
--{"fileGuid":"34429bfd-8b41-4d45-b46d-30d464c4e960","fileName":"cr85win_en_sp2.exe","fileSize":"30262568"}
--{"fileGuid":"4db65cb5-d80a-9030-b4d9-5a5e71d0b303","fileName":"AddItem.png","fileSize":"35699","fileHref":"GetPdf.aspx?data=AQAAALry0YzPMfTO4OPqat6gmh\/fJii39uNhyqT55\/jDfJ5+oGYOLnNJlQUBcfKa8A26pUgu9gz92iOPqAHGVRjgIzw8OrS\/ovcTVvqXK7YHlALT"}    
      
  set @value = @json    
      
  insert into @tmp(name,value)    
  select name, value from dbo.fnSplitJson2(@value, null)    
      
  declare cur cursor static for select name,value from @tmp for read only    
  open cur    
  fetch next from cur into @name,@value    
  while @@fetch_status = 0    
  begin    
    delete @tmp     
    insert into @tmp(name,value)    
    select name, value from dbo.fnSplitJson2(@value, null)    
      
    declare cur1 cursor static for select name,value from @tmp for read only    
    open cur1    
    fetch next from cur1 into @name,@value    
    while @@fetch_status = 0    
    begin    
      if(@name='fileName')    
  select @fileName = @value    
   else if(@name = 'fileGuid')    
  select @fileGuid = @value    
   else if(@name = 'fileSize')    
  select @fileSize = @value    
   fetch next from cur1 into @name,@value    
    end    
    deallocate cur1    
        
    insert into @result(fileName,fileGuid,fileSize)    
    select @fileName, @fileGuid, @fileSize    
        
    fetch next from cur into @name,@value    
  end    
  deallocate cur    
      
  select * from @result 
GO