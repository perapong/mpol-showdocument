select   ---G1
         sdd.sddou_code
        ,sdd.cpgcampaign_year
        ,substr(sdd.curr_camp,1, 2)||'/'||substr(sdd.curr_camp,3,4)                curr_camp
        ---G2 
        ,sdd.sddnsm 
        ,sdd.nsm_desc
         ,sdd.dstmgr_position
        ,sdd.sdddiv                              
        ,sdd.div_desc    
        ,sdd.sddloc_code  
        ,sdd.district_name 
        ,sdd.manager 
        ,sdd.active_campaign
        ,sdd.pay_plan 
        ,sdd.dstmgr_payplan
        ,sdd.dstmgr_vehicle 
    ----G3               
        ,sdd.type_year
    ----G4         
        ,sdd.cpgquarter 
    ----Detail    
        ,sdd.sddcampaign 
         ,to_number(sdd.sddcampaign)              sddcampaign_num
           , to_number(decode(sdd.sddno_of_active,0,null,sdd.sddno_of_active))             sddno_of_active
        , to_number(decode(sdd.sddno_of_order,0,null,sdd.sddno_of_order))          sddno_of_order
        , to_number(decode(sdd.sddperc_activity,0,null,sdd.sddperc_activity))      sddperc_activity
        , to_number(decode(sdd.sddnet_sales,0,null,sdd.sddnet_sales))              sddnet_sales
        , to_number(decode(sdd.sddytd_amount,0,null,sdd.sddytd_amount))           sddytd_amount     
        , to_number(decode(sdd.sddavg_amount,0,null,sdd.sddavg_amount))            sddavg_amount
        ,  to_number(decode(sdd.sddtotal_receipt,0,null,sdd.sddtotal_receipt))     sddtotal_receipt
        ,  to_number(decode(sdd.sddreturn_amount,0,null,sdd.sddreturn_amount))     sddreturn_amount
        ,  to_number(decode(sdd.sddytd_return,0,null,sdd.sddytd_return))           sddytd_return
        , to_number(decode(sdd.sddbd_transfer,0,null,sdd.sddbd_transfer))          sddbd_transfer  
        ,  to_number(decode(sdd.sddbd_collect,0,null,sdd.sddbd_collect))           sddbd_collect         
        ,  to_number(decode(sdd.sddytd_bd,0,null,sdd.sddytd_bd))                   sddytd_bd 
        ,  to_number(decode(sdd.sddno_of_appt,0,null,sdd.sddno_of_appt))            sddno_of_appt
        ,  to_number(decode(sdd.sddno_of_rein,0,null,sdd.sddno_of_rein))            sddno_of_rein
        ,  to_number(decode(sdd.sddall_of_first,0,null,sdd.sddall_of_first))        sddall_of_first
        ,  to_number(decode(sdd.sddno_of_rem,0,null,sdd.sddno_of_rem))              sddno_of_rem
from       su_param_dtl pad, db_sales_location dst,  
         (    
            select  ---G1
                                             sdd.sddou_code  
                                            ,cpg.cpgcampaign_year
                                            ,PKGDB_DESC.getCurrent_Campaign   curr_camp
                                            ---G2 
                                            ,sdd.sddnsm 
                                            ,pkgom_master.get_dstloc_desc (:s_ou_code
                                                                           ,sdd.sddnsm) nsm_desc
                                            ,sdd.sdddiv                              
                                            ,pkgom_master.get_dstloc_desc (:s_ou_code
                                                                            ,sdd.sdddiv) div_desc    
                                            ,sdd.sddloc_code  
                                            ,dst.dstloc_name                 district_name 
                                           ,dst.dstmgr_name                 manager 
                                           ,(SELECT 'POSITION : '||DECODE (:s_lin_id,
                                                                                                   'EN', param.padentry_edesc,
                                                                                                        param.padentry_ldesc
                                                                                                       )
                                                FROM su_param_dtl param
                                               WHERE param.padparam_id = 303
                                                 AND param.padentry_code =  decode(nvl(dst.dstmgr_position,'1'),'1',null,dst.dstmgr_position)       )          dstmgr_position
                                            ,dst.dstmgr_activate_campaign    active_campaign
                                            ,(SELECT DECODE (:s_lin_id,
                                                             'EN', param.padentry_edesc,
                                                             param.padentry_ldesc
                                                            )
                                                FROM su_param_dtl param
                                               WHERE param.padparam_id = 304
                                                 AND param.padentry_code = dst.dstmgr_payplan) pay_plan 
                                            ,dst.dstmgr_payplan
                                               ,decode(dst.dstmgr_vehicle,'1','CO.''S CAR',null)               dstmgr_vehicle 
                                        ----G3               
                                            ,case  when (cpgquarter <=  (select    count(1) /2  half
                                                                         from (select distinct cpg_temp.CPGCAMPAIGN_YEAR , cpg_temp.CPGQUARTER
                                                                         from db_campaign        cpg_temp
                                                                         where  cpg_temp.CPGCAMPAIGN_YEAR = '2010' ))
                                                                            ) then   'HALF'
                                                                              else   'FULL'
                                             end     type_year
                                        ----G4         
                                            ,cpg.cpgquarter 
                                        ----Detail    
                                            ,sdd.sddcampaign 
                                            ,sdd.sddno_of_active
                                            ,sdd.sddno_of_order
                                            ,sdd.sddperc_activity
                                            ,sdd.sddnet_sales
                                            ,sdd.sddytd_amount
                                            ,sdd.sddavg_amount
                                            ,sdd.sddtotal_receipt
                                            ,sdd.sddreturn_amount
                                            ,sdd.sddytd_return
                                            ,sdd.sddbd_transfer
                                            ,sdd.sddbd_collect
                                            ,sdd.sddytd_bd
                                            ,sdd.sddno_of_appt
                                            ,sdd.sddno_of_rein
                                            ,sdd.sddall_of_first
                                            ,sdd.sddno_of_rem  
                                            ,dst.dstparent_loc_code                     g_division
                       from      su_param_dtl       pad
                              ,db_sales_location  dst
                              ,sa_daily_byloc_hdr sdd
                              ,db_campaign        cpg
                              ,db_mailplan_sales      mps 
                      where    sdd.sddou_code       =  :S_OU_CODE
                      and     substr(sdd.sddcampaign, 3,4)||substr(sdd.sddcampaign, 1, 2)  between   
                            substr(:S_SHIP_CAMP, 3, 4)||'01'  and  substr(:S_SHIP_CAMP, 3, 4)||substr(:S_SHIP_CAMP, 1, 2) 
                      and      sdd.sddnsm  like nvl(:P_S_NSM, '%')  
                      and      sdd.sdddiv    between nvl(:P_S_DIV, '$') and nvl(:P_E_DIV, chr(250))
                      and      dst.dstloc_code    BETWEEN NVL(:P_S_DISTRICT, '$') AND NVL(:P_E_DISTRICT, CHR(250)) 
                      and      pad.padparam_id          =  300 -- check district type
                      and      nvl(pad.padnum1, 1)      =  3     -- only loc level 3 (district)
                      and      dst.dstloc_type          = pad.padentry_code
                      and      sdd.sddou_code           = cpg.cpgou_code
                      and      sdd.sddcampaign          = cpg.cpgcampaign_code   
                      and      sdd.sddou_code           = dst.dstou_code 
                      and      sdd.sddloc_code          = dst.dstloc_code 
                      and     mps.mpsou_code   =  dst.dstou_code 
                      and     mps.mpsloc_code  =  dst.dstloc_code 
                      and     mps.mpsou_code   =     :s_ou_code    
                      and     trunc(mps.mpsshipdate)  =   nvl(to_date(:P_S_SHIPDATE,'dd/mm/rrrr') ,to_date('03/01/2011','dd/mm/rrrr') )
                                  ) sdd
where      dst.dstou_code          = :S_OU_CODE
and        pad.padparam_id         =  300 -- check district type]
and        nvl(pad.padnum1, 1)     =  2     -- only loc level 2 (Division)
and        dst.dstloc_type         = pad.padentry_code
and        dst.dstou_code = sdd.sddou_code  
and        dst.dstloc_code   = sdd.g_division
order by  sdd.cpgquarter ,   sdd.sddcampaign 
