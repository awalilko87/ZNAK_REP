SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--exec KPI_GET_REPORTS_ELEMENTS 'SA'
create procedure [dbo].[KPI_GET_REPORTS_ELEMENTS](  
@_UserID nvarchar(30) = null,  
@_LangID nvarchar(30) = null
)
as  
  DECLARE @cr_id varchar(max)            
  DECLARE @cr_desc varchar(max)            
  DECLARE @cr_source varchar(max)            
  DECLARE @cr_where varchar(max)            
  DECLARE @cr_defimage varchar(max)            
  DECLARE @cr_link varchar(max)           
  DECLARE @cr_formid nvarchar(50)      
  DECLARE @cr_dataspy nvarchar(100)       
  DECLARE @cr_rpt varchar(max)            
  DECLARE @cr_rpt_Encode varchar(max)   
    
  DECLARE @sp_count int    
  declare @sp_link nvarchar(max)   
  DECLARE @v_org varchar(30)            
  DECLARE @v_image varchar(max)            
  DECLARE @v_GroupID nvarchar(20)
  DECLARE @inbox_type bit    
  DECLARE @kpu_show_when_zero bit    
  DECLARE @sp_where nvarchar(max);         
  DECLARE @sp_query nvarchar(max);          
  DECLARE @sp_SQLString nvarchar(max);            
  DECLARE @sp_ParmDefinition nvarchar(max);           
  
  declare @tmp_tab table(cr_id int,   
                         cr_desc nvarchar(max),  
                         cr_link nvarchar(max),  
                         cr_defimage varchar(max),  
                         cr_count int)  
                           
  SELECT @v_org = SiteID, 
         @v_GroupID = isnull(UserGroupID,'')
  from dbo.SYUsers (nolock) 
  where UserID = @_UserID    
  
  DECLARE cKPI CURSOR STATIC FOR            
  SELECT KPI_ID, isnull(Caption,KPI_DESC), KPI_SOURCE, KPI_WHERE, KPI_DEFIMAGE, KPI_LINK, KPI_RPT, RPT_TYPE, KPI_FORMID, KPI_DATASPY, KPU_SHOW_WHEN_ZERO           
  FROM dbo.VS_KPI (nolock)         
    LEFT JOIN VS_KPIUSERS ON VS_KPI.ROWID = KPU_KPIID
    left join dbo.VS_LangMsgs(nolock) on ObjectType = 'KPI' and ControlID = convert(varchar,KPI_ID) and LangID = @_LangID
  WHERE KPU_USERID = @_UserID   
  AND KPI_ACTIVE = 1   
  AND isnull(KPU_ORDER,0) <> 0  
  AND RPT_TYPE = 1       
  ORDER BY ISNULL(KPU_ORDER, 0)  
    
  OPEN cKPI            
  FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @inbox_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero               
  WHILE @@FETCH_STATUS = 0            
  BEGIN        
	IF isnull(@cr_rpt,'') <> '' BEGIN
		SELECT @cr_rpt_Encode =  N'CR_'+@cr_rpt      
		SELECT @sp_link = 'javascript:Simple_Popup(''/Forms/SimplePopup/' + isnull(@cr_rpt_Encode,'') + ''',null,''top=10 left=400 width=440 height=370,scrollbars=yes,menubar=no,resizable=yes'');void(0);'          
	END
	ELSE BEGIN
		SELECT @sp_link = '#'
	END

    insert into @tmp_tab(cr_id, cr_desc, cr_link, cr_defimage, cr_count)  
    select @cr_id,  
           (isnull(@cr_desc,'')),  
           isnull(@sp_link,''),  
           isnull(@cr_defimage,''),  
           isnull(@sp_count,'')    
    FETCH NEXT FROM cKPI INTO @cr_id, @cr_desc, @cr_source, @cr_where, @cr_defimage, @cr_link, @cr_rpt, @inbox_type, @cr_formid, @cr_dataspy, @kpu_show_when_zero               
  END  
    
  CLOSE cKPI  
  DEALLOCATE cKPI  
    
  select cr_id, cr_desc, cr_link, cr_defimage, cr_count from @tmp_tab  
    
  return 0   
GO