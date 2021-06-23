SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[PZO_LN_STATUS_Update]      
(      
 @POT_ID int      
)as      
begin       
      
if exists (select 1 from OBJTECHPROTLN where POL_POTID = @POT_ID and POL_STATUS = 'PZL_001')      
      
 begin      
       
  
if not exists (select PRV_DVALUE from PROPERTYVALUES    
WHERE PRV_PROID = 279 /*START DATE - URUCHOMIONO DNIA*/      
  AND PRV_PKID in (      
  select POL_OBJID from OBJTECHPROTLN       
  JOIN OBJTECHPROT ON POT_ROWID = POL_POTID      
  WHERE POT_STATUS IN ('PZO_003', 'PZO_004')      
  AND   
  POL_STATUS = 'PZL_001'      
  AND POT_ROWID = @POT_ID      
  ) )  
  
  begin  
  
  insert into PROPERTYVALUES (PRV_PROID, PRV_PKID, PRV_ENT, PRV_DVALUE,PRV_NOTUSED)  
  select '279',POL_OBJID , 'OBJ', GETDATE(),'-'  
  from OBJTECHPROTLN       
    JOIN OBJTECHPROT ON POT_ROWID = POL_POTID      
    WHERE POT_STATUS IN ('PZO_003', 'PZO_004')      
    AND POL_STATUS = 'PZL_001' 
	AND POT_ROWID = @POT_ID   
    and not exists (select * from PROPERTYVALUES where POL_OBJID = PRV_PKID and PRV_PROID = 279)  
  
  end   
  
  else   
  begin  
  
    UPDATE PROPERTYVALUES      
    SET PRV_DVALUE = GETDATE()      
    WHERE PRV_PROID = 279 /*START DATE - URUCHOMIONO DNIA*/      
    AND PRV_PKID in (      
    select POL_OBJID from OBJTECHPROTLN       
    JOIN OBJTECHPROT ON POT_ROWID = POL_POTID      
    WHERE POT_STATUS IN ('PZO_003', 'PZO_004')      
    AND POL_STATUS = 'PZL_001' 
	AND POT_ROWID = @POT_ID)      
     end  
 end       
      
end


select * from STA
GO