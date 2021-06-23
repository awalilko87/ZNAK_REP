SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetMT3Type]   
()  
returns   
@t table  
(  
   [OPER] int 
  ,[OPER_DESC] nvarchar(120)  
)  
  
as  
begin  
	 
	insert into @t  ([OPER], [OPER_DESC])
	select '1', N'1. (GWP) Wydz. wart. ze skł. gł. na podnumer'
	union
    select '2', N'2. (GWI) Wydz. wart. ze skł. gł. na nowy podnr w istn. skł.'
	union
    select '3', N'3. (GWN) Wydz. wart. ze skł. gł. na nowy składnik główny'
	union
    select '4', N'4. (PWI) Wydz. wart. z podnr na nowy podnr w istn. skł.'
	union
    select '5', N'5. (PWN) Wydz. wart. z podnr na nowy składnik główny'
	union
    select '6', N'6. (PI) Przen. całej wart. z podnr na nowy podnr w istn. skł.'
	union
    select '7', N'7. (PN) Przen. całej wart. z podnr na nowy składnik główny'
    union
    select '8', N'8. Przeks. pomiędzy istniejącymi składnikami'
    
	return  
	 
end  
 
GO