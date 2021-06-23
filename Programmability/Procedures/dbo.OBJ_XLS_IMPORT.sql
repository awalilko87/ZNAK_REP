SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OBJ_XLS_IMPORT]             
(            
 @p_STNID int , -- nr stacji             
 @p_UserID nvarchar(30),            
 @STN_KL5ID int -- nr klasyfikacji            
)            
as             
begin             
            
--declare            
--    @p_STNID int,            
-- @p_UserID nvarchar(30)            
            
-- select @p_STNID = 4825            
-- select @p_UserID = 'SA'            
            
 declare              
  @v_ROWID_NAG int,            
  @v_PARENTID int,            
  @SQL_COLUMNS nvarchar(max),            
  @SQL_STSID nvarchar(max),             
  @SQL_ASTID nvarchar(max),             
  @SQL_PARAMETER nvarchar(max),             
  @v_STS_COL nvarchar(50),            
  @v_STS nvarchar(30),            
  @v_STSID int,   -- id szablonu          
  @v_AST_COL nvarchar(50),            
  @v_AST nvarchar(30),            
  @v_AST_SUBCODE_COL nvarchar(50),            
  @v_AST_SUBCODE nvarchar(30),            
  @v_ASTID int,            
  @v_PM_COL nvarchar(50),            
  @v_PM nvarchar(30),             
  @v_PM_PARENT_COL nvarchar(50),            
  @v_PM_PARENT nvarchar(30),             
  @v_PM_SERVICE_COL nvarchar(50),            
  @v_PM_SERVICE nvarchar(30),             
  @v_PM_NAME_COL nvarchar(50),            
  @v_PM_NAME nvarchar(255),             
  @v_VALUE_COL nvarchar(50),            
  @v_VALUE_REPL nvarchar(30),             
  @v_VALUE nvarchar(30),             
  @v_SERIAL_COL nvarchar(50),            
  @v_SERIAL nvarchar(30),             
  @v_DATE_COL nvarchar(50),            
  @v_DATE nvarchar(30),             
  @v_OBJID int,            
  @v_PROPERTY_COL nvarchar(50),            
  @v_PROPERTY nvarchar(255),            
  @v_AST_CCDID int,             
  @v_AST_CCD nvarchar(30),             
  @v_STN_CCDID int,             
  @v_STS_TYPE nvarchar(30),              
  @v_apperrortext nvarchar(max),          
  @Mes nvarchar(max); -- zmiennna do komunikatów, przy imporcie. Jeżeli jakiś parametrów nie ma w property values wtedy wyświetli sie komunikat              
              
  /**Updatujemy tabelę, aby dodać informację, że dane zostały zaczytane z pliku Excel*/            
              
  update STN_ADD_OBJ_EXCEL             
  set importuser = cast ('XLS_' + @p_UserID as nvarchar(30))            
              
  /*Ustawiamy w kodzie użytkownika informację, iż import był zrobiony z excela*/            
  set @p_UserID = cast ('XLS_' + @p_UserID as nvarchar(30))            
             
 delete from STN_ADD_OBJ_EXCEL where c01 in ('Nazwa SAP>' ,'Kod SAP>') -- usunięcie z pliku Excel dwóch pierwszych rekordów z kodami            
             
 declare             
  @c_ROWID int,    -- zmienna sterująca do kursora. id rekordu w xls          
  @c_PRVID int,  -- id propertyvalues          
  @C_PRO_TEXT nvarchar(255)  -- nazwa propertyvalues           
            
 select top 1 @v_ROWID_NAG = ROWID from STN_ADD_OBJ_EXCEL (nolock) where ImportUser = @p_UserID order by rowid asc            
           
 /*deklarujemy kursor, w którym prztworzymy rekord po rekordzie z pliku excel*/          
              
 DECLARE c_OBJ CURSOR STATIC FOR -- kursor 1 c_OBJ            
             
 select             
  ROWID            
 from STN_ADD_OBJ_EXCEL            
 where             
  ImportUser = @p_UserID            
  and ROWID <> @v_ROWID_NAG            
  --and c18 like '%1457'              
 union --importujemy dwukrotnie, aby zapewnić że pójdą nadrzędne a następnie podrzędne            
 select             
  ROWID            
 from STN_ADD_OBJ_EXCEL            
 where             
  ImportUser = @p_UserID            
  and ROWID <> @v_ROWID_NAG            
  --and c18 like '%1457'             
             
 OPEN c_OBJ             
            
 FETCH NEXT FROM c_OBJ             
 INTO @c_ROWID             
             
 WHILE @@FETCH_STATUS = 0             
           
           
 begin            
             
  -----------------------------------------------------------------------------------------------------------------------------------------------------------            
  ---------------------------------------------------------------PARAMETRY STAŁE-----------------------------------------------------------------------------          
  -----------------------------------------------------------------------------------------------------------------------------------------------------------            
  select @v_STS_COL = NULL            
  select @v_STS = NULL            
  select @v_STSID = NULL            
  select @v_AST_COL = NULL            
  select @v_AST = NULL            
  select @v_ASTID = NULL            
  select @v_PM_COL = NULL            
  select @v_PM = NULL            
  select @v_VALUE_COL = NULL            
  select @v_VALUE = NULL            
  select @v_SERIAL_COL = NULL            
  select @v_SERIAL = NULL            
  select @v_OBJID = NULL           
  ------NOWE PARAMETRY-------          
  --(do obsugi pól, któych nie ma w property values)        
  --declare @kolumna nvarchar(255) = N'Podnumer'        
  --set  @kolumna = cast(cast(@kolumna  as int) as nvarchar(30))        
             
  /*Przypisujemy kolumny z XLS do poszczególnych zmiennych*/          
             
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Kod szablonu', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_STS_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Numer SAP PM', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_PM_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Nadrzędne SAP PM', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_PM_PARENT_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Oznaczenie', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_PM_NAME_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Serwis', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_PM_SERVICE_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Wartość nabycia', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_VALUE_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Numer seryjny', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_SERIAL_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Składnik', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_AST_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Podnumer', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_AST_SUBCODE_COL OUTPUT            
  exec dbo.[GetTableColumnName] @v_ROWID_NAG, N'Data uruchomienia', N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_DATE_COL OUTPUT          
            
  ----------------------------------------------------------------------------------------------------------------------------          
           
              
            
   ----------------------------------------------------------------------------------------------------------------------------            
            
  --select @v_STS_COL = dbo.GetImportColumnName (@v_ROWID_NAG, N'Kod szablonu')             
  --select @v_PM_COL = dbo.GetImportColumnName (@v_ROWID_NAG, N'Numer PM')             
  --select @v_VALUE_COL = dbo.GetImportColumnName (@v_ROWID_NAG, N'Wartość')             
  --select @v_SERIAL_COL = dbo.GetImportColumnName (@v_ROWID_NAG, N'Nr. seryjny')             
  --select @v_AST_COL = dbo.GetImportColumnName (@v_ROWID_NAG, N'Nr. inwentarzowy')           
            
            
  if @v_STS_COL is not null            
            
  begin            
           
   select @SQL_COLUMNS =              
    'select top 1 @v_STS = ' + @v_STS_COL +            
    /*Numer SAP PM*/  case when @v_PM_COL is not null then ', @v_PM = ' + @v_PM_COL else '' end +            
    /*Nadrzędne SAP PM*/ case when @v_PM_PARENT_COL is not null then ', @v_PM_PARENT = ' + @v_PM_PARENT_COL else '' end +            
    /*Oznaczenie*/   case when @v_PM_NAME_COL is not null then ', @v_PM_NAME = ' + @v_PM_NAME_COL else '' end +            
    /*Serwis*/    case when @v_PM_SERVICE_COL is not null then ', @v_PM_SERVICE = ' + @v_PM_SERVICE_COL else '' end +            
    /*Wartość nabycia*/  case when @v_VALUE_COL is not null then ', @v_VALUE = ' + @v_VALUE_COL else '' end +            
    /*Numer seryjny*/  case when @v_SERIAL_COL is not null then ', @v_SERIAL = ' + @v_SERIAL_COL else '' end +            
    /*Data uruchomienia*/ case when @v_DATE_COL is not null then ', @v_DATE = ' + @v_DATE_COL else '' end +            
    /*Składnik*/   case when @v_AST_COL is not null then ', @v_AST = ' + @v_AST_COL else '' end +            
    /*Podnumer*/   case when @v_AST_SUBCODE_COL is not null then ', @v_AST_SUBCODE = ' + @v_AST_SUBCODE_COL else '' end +            
        ' from STN_ADD_OBJ_EXCEL (nolock) where ROWID = '            
        + cast(@c_ROWID as nvarchar(30))+ ''  -- numer linii w bazie          
                
   exec sp_executesql             
    @query = @SQL_COLUMNS,            
    @params = N'@v_STS nvarchar(30) OUTPUT, @v_PM nvarchar(30) OUTPUT          
    , @v_PM_PARENT nvarchar(30) OUTPUT, @v_PM_NAME nvarchar(30) OUTPUT          
    , @v_PM_SERVICE nvarchar(30) OUTPUT, @v_VALUE nvarchar(30) OUTPUT          
    , @v_SERIAL nvarchar(30) OUTPUT, @v_DATE nvarchar(30) OUTPUT          
    , @v_AST nvarchar(30) OUTPUT, @v_AST_SUBCODE nvarchar(30) OUTPUT'            
    , @v_STS = @v_STS OUTPUT          
    , @v_PM = @v_PM OUTPUT          
    , @v_PM_PARENT = @v_PM_PARENT OUTPUT          
    , @v_PM_NAME = @v_PM_NAME OUTPUT          
    , @v_PM_SERVICE = @v_PM_SERVICE OUTPUT          
    , @v_VALUE = @v_VALUE OUTPUT          
    , @v_SERIAL = @v_SERIAL OUTPUT          
    , @v_DATE = @v_DATE OUTPUT          
    , @v_AST = @v_AST OUTPUT          
    , @v_AST_SUBCODE = @v_AST_SUBCODE OUTPUT          
              
 /*Wyciągamy rowid składnika na podtawie jego kodu */          
              
    set @SQL_STSID =  'select top 1 @v_STSID = STS_ROWID from STENCIL (nolock) where STS_CODE = ''' + @v_STS + ''''            
    exec sp_executesql             
    @query = @SQL_STSID,            
    @params = N'@v_STSID int OUTPUT',            
    @v_STSID = @v_STSID OUTPUT           
            
    --print @v_AST   
    --print @v_AST_SUBCODE   
                 
  /*Wyciągamy rowid ŚT na podtawie jego kodu */        
         
    set @SQL_ASTID =  'select top 1 @v_ASTID = AST_ROWID from ASSET (nolock) where AST_CODE = ''' + @v_AST + ''' and cast(AST_SUBCODE as int) = ''' + @v_AST_SUBCODE + ''''            
    exec sp_executesql             
    @query = @SQL_ASTID,            
    @params = N'@v_ASTID int OUTPUT',            
    @v_ASTID = @v_ASTID OUTPUT            
  end            
           
           
     -- print @v_ASTID     
           
  ---------------------------------------------------------------------------------------------------------------------------------------------------            
            
  /*SPRAWDZAMY, CZY DLA DANYCH PARAMETRÓW ISTNIEJE ODNIESIENIE W TABELI PROPERTY VALUES*/          
            
   EXEC CHECK_PROPERTY_FOR_STS @v_STSID, @v_PM, @p_UserID,@p_STNID;          
            
  /*----------------------------------------------------------------------------------*/          
               
  select @v_STN_CCDID = STN_CCDID from STATION (nolock) where STN_ROWID = @p_STNID  --id  MPK przypisanego do stacji          
  select @v_AST_CCDID = AST_CCDID from ASSET (nolock) where AST_ROWID = @v_ASTID  -- id  MPK składnika (musi być taki sam jak dla stacji)          
  select @v_AST_CCD = CCD_CODE from COSTCODE (nolock) where CCD_ROWID = @v_AST_CCDID  -- kod MPK (widnieje na rekordzie stacji)          
          
/*jeżeli nie istnieje żaden obiekt z tej stacji i tej klasyfikacji 5*/           
           
  if             
   not exists (select 1 from dbo.OBJ where             
   OBJ_ROWID in (select OSA_OBJID from OBJSTATION           
   where OSA_STNID = @p_STNID and OSA_KL5ID = @STN_KL5ID)            
          
   and OBJ_PM = isnull(@v_PM,'!@#$_%^_&*(') and OBJ_PM <> '' )             
   and @v_STSID is not null             
   and @p_STNID is not null            
   and isnull(@v_AST_CCDID, @v_STN_CCDID) = @v_STN_CCDID            
            
  begin            
                
   select @v_STS_TYPE = STS_TYPE from STENCIL where STS_ROWID = @v_STSID  -- pobierz typ składnika szablonu          
        
                 
   /* Jeżeli na tej stacji nie istnieje główny system kasowo zarządzający*/          
             
   if not exists (select * from OBJ where OBJ_ROWID = OBJ_PARENTID and OBJ_STSID = 23            
    and OBJ_ROWID in (select OSA_OBJID from OBJSTATION where OSA_STNID = @p_STNID))            
   and @v_STS_TYPE = 'INFORMATYKA' --tylko gdy zakładamy coś z informatyki          
                
   begin            
             
   /*Dodawanie rekordu systemu kasowo zarządzającego dla stacji*/          
    exec [dbo].[GenStsObj]            
     @p_STSID = 23,            
     @p_PSPID = NULL,            
     @p_ANOID = NULL,            
     @p_PARENTID = NULL,            
     @p_STNID = @p_STNID,            
     @p_UserID = @p_UserID,            
     @p_OBJID = @v_PARENTID output,    -- tylko rekord systemu kasowo zarządzjącego        
     @p_apperrortext = @v_apperrortext output            
   end           
           
                     
   if @v_STS_TYPE = 'INFORMATYKA'            
   begin            
             
    select top 1 @v_PARENTID = OBJ_ROWID           
    from OBJ (nolock)           
    where OBJ_ROWID = OBJ_PARENTID           
    and OBJ_STSID = 23            
    and OBJ_ROWID in (select OSA_OBJID from OBJSTATION where OSA_STNID = @p_STNID)         
            
           
   --------------------------------------------------            
   end           
          
             
   else if isnull(@v_PM_PARENT,'') <> '' and exists (select OBJ_ROWID from OBJ (nolock) where OBJ_PM = @v_PM_PARENT)            
   begin             
    select top 1 @v_PARENTID = OBJ_ROWID from OBJ (nolock) where OBJ_PM = @v_PM_PARENT                
   end            
   else             
    select @v_PARENTID = NULL            
            
           
   /*Dodawanie rekordów do PROPERTYVALUES dla konkretnego składnika*/               
   exec [dbo].[GenStsObj]            
    @p_STSID = @v_STSID,  --id składnika          
    @p_PSPID = NULL,            
    @p_ANOID = NULL,            
    @p_PARENTID = @v_PARENTID,            
    @p_STNID = @p_STNID,  -- id stacji          
    @p_UserID = @p_UserID,            
    @p_OBJID = @v_OBJID output,-- w procedurze GenStsObj zostanie wygenerowany maks rowid dla naszego przetwarzanego rekordu          
    @p_apperrortext = @v_apperrortext output           
           
          
                  
   if @v_OBJID is not null and @v_ASTID is not null     
                         
    insert into OBJASSET            
     (OBA_OBJID,            
     OBA_ASTID,            
     OBA_CREDATE,            
     OBA_CREUSER)            
    select             
     @v_OBJID,            
     @v_ASTID,            
     GETDATE(),            
     @p_UserID            
  end            
           
  else             
  if isnull(@v_AST_CCDID, @v_STN_CCDID) <> @v_STN_CCDID            
  print 'Niezgodny MPK środka trwałego z MPK stacji paliw: ' + @v_AST + '(MPK: ' + @v_AST_CCD +')'            
             
   else           
             
   if exists (select 1 from dbo.OBJ             
   where OBJ_ROWID in (select OSA_OBJID from OBJSTATION where OSA_STNID = @p_STNID and OSA_KL5ID = @STN_KL5ID)            
   and OBJ_PM = isnull(@v_PM,'!@#$_%^_&*(') and OBJ_PM <> '' )         
               
   print 'Istnieje już składnik z tym numerem SAP PM: ' + @v_PM + '(MPK: ' + @v_AST_CCD +')'            
            
  else           
            
  if @p_STNID is null             
  print 'Nie podano numeru stacji paliw'            
            
  else           
            
  if @v_STSID is null            
  print 'Nie podano kodu szablonu'            
                
  --------------------------------------------------------------------------------------------------------------------------------------------------------            
 -- select @v_OBJID = OBJ_ROWID from OBJ (nolock) where OBJ_PM = @v_PM  -- PM - numer SAP PM        
          
        
  --------------------------------------------------------------------------------------------------------------------------------------------------------            
  ---------------------------------------------------------------PARAMETRY--------------------------------------------------------------------------------            
  --------------------------------------------------------------------------------------------------------------------------------------------------------              
  if @v_OBJID is not null            
            
  begin       
               
   select @v_VALUE_REPL = replace(replace(replace(@v_VALUE,' ',''),',','.'),' ','')               
   if isnumeric(@v_VALUE_REPL) = 1            
    select @v_VALUE =  cast(@v_VALUE_REPL as decimal(18,2))            
   else             
    select @v_VALUE = 0            
            
   if isdate(@v_DATE) = 1            
    select @v_DATE =  cast (@v_DATE as datetime)            
   else             
    select @v_DATE = NULL            
            
            
             
   update OBJ set             
    OBJ_PM = @v_PM,            
    OBJ_PM_NAME = @v_PM_NAME,            
    OBJ_PM_SERVICE = @v_PM_SERVICE,            
    OBJ_VALUE = @v_VALUE,             
    OBJ_SERIAL = @v_SERIAL,            
    OBJ_DATE = @v_DATE,
    OBJ_CREDATE = @v_DATE,            
    OBJ_STATUS = 'OBJ_001'            
   where             
    OBJ_ROWID = @v_OBJID           
               
                
   declare c_OBJ_PV cursor static for -- kursor 2 c_OBJ_PV  DODAWANIE PROPERTYVAUES DLA SKŁANIKA          
               
   select             
    PRV_ROWID            
    ,PRO_TEXT            
   from dbo.PROPERTYVALUES            
    join dbo.PROPERTIES (nolock) on PRO_ROWID = PRV_PROID            
   where             
    PRV_PKID = @v_OBJID  -- PRV_PKID - identyfikator obiektu w property.          
    and PRV_ENT = 'OBJ'            
              
   open c_OBJ_PV            
            
   fetch next from c_OBJ_PV            
   into @c_PRVID, @C_PRO_TEXT            
            
   while @@FETCH_STATUS = 0            
   begin            
              
    select @v_PROPERTY_COL = NULL            
    select @v_PROPERTY = NULL            
            
    exec dbo.[GetTableColumnName] @v_ROWID_NAG, @C_PRO_TEXT, N'STN_ADD_OBJ_EXCEL', @p_COLUMNNAME = @v_PROPERTY_COL OUTPUT            
            
    if @v_PROPERTY_COL is not null            
    begin            
     select @SQL_PARAMETER =              
      'select top 1 @v_PROPERTY = ' + @v_PROPERTY_COL +            
      ' from STN_ADD_OBJ_EXCEL (nolock) where ROWID = '            
      + cast(@c_ROWID as nvarchar(30))+ ''            
                
     exec sp_executesql             
      @query = @SQL_PARAMETER,            
      @params = N'@v_PROPERTY nvarchar(30) OUTPUT',            
      @v_PROPERTY = @v_PROPERTY OUTPUT            
    end            
            
    update PROPERTYVALUES             
    set PRV_VALUE = @v_PROPERTY             
    where PRV_ROWID = @c_PRVID             
    and @v_PROPERTY is not null            
                 
    fetch next from c_OBJ_PV            
    into @c_PRVID, @C_PRO_TEXT            
            
   end            
            
   close c_OBJ_PV            
   deallocate c_OBJ_PV -- kursor 2 c_OBJ_PV             
            
  end            
              
  select @v_OBJID = NULL            
              
  fetch next from c_OBJ            
  into @c_ROWID            
            
 end            
            
 close c_OBJ             
 deallocate c_OBJ -- kursor 1 c_OBJ          
         
         
 delete from STN_ADD_OBJ_EXCEL          
              
 end 
GO