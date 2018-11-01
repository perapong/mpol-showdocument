select ou_code , 
dstmgr_st_camp , 
       decode(nvl(:p_nsm_cond, '0'), '0', 'ALL', a_nsm) a_nsm , 
       case when nvl(:p_nsm_cond, '0') = '0' then null else pkgom_master.get_dstloc_desc('000', a_nsm) end nsm_desc , 
       a_div , 
       a_loc_code , 
camp_count, 
--       firt_camp_no_msl , 

       tot_no_of_msl , 
       avg_rep , 
       rnk_first_rep ,

       tot_no_order , 
       avg_no_order , 
       rnk_no_order , 

       tot_net_sales , 
       avg_net_sales ,
       inc_per ,
       rnk_net_sales ,

       tot_first_600 , 
       avg_first_600 , 
       rnk_first_600 , 
       
       tot_bd_net , 
       rnk_bd_net , 
       
       tot_bd_per ,
       rnk_bd_per ,

       dstmgr_name ,
       --dstmgr_st_camp , 
       position ,
       base_amt , 
       nvl(rnk_first_rep,0) + nvl(rnk_no_order,0) + nvl(rnk_net_sales,0) + nvl(rnk_first_600,0) + nvl(rnk_bd_net,0) + nvl(rnk_bd_per,0) total_point
from 
      (select 
             '000' ou_code , 
             a_nsm , 
             a_div , 
             a_loc_code  
           , firt_camp_no_msl 
           , camp_count
           , ceil(tot_no_of_msl/camp_count) avg_rep
           , ceil(tot_no_order /camp_count) avg_no_order
           , ceil(tot_net_sales/camp_count) avg_net_sales
           , ceil(tot_no_first /camp_count) avg_first_600
           , tot_no_of_msl
           , tot_no_order
           , tot_net_sales
           , tot_no_first tot_first_600
           , tot_bd_net
          -- , round((tot_bd_net/tot_net_sales)*100,2) 
           , 0 tot_bd_per
           , rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm)
                               order by ceil(tot_no_of_msl/camp_count) desc) rnk_first_rep
           , rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm)
                               order by ceil(tot_no_order/camp_count) desc) rnk_no_order
           , round((tot_net_sales - (ar_par.p3hqualified_amt * camp_count)) /(ar_par.p3hqualified_amt * camp_count) * 100,2) inc_per 
--           , dense_rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), 0, '%', a_nsm) 
--                                     order by (((tot_net_sales/(ar_par.p3hqualified_amt * camp_count))*100) -100) desc )
                        , 0              rnk_net_sales
           , rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
                               order by tot_no_first desc ) rnk_first_600
           , rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
                               order by tot_bd_net desc ) rnk_bd_net
          -- , rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
          --                     order by round((tot_bd_net/decode(tot_net_sales,0,tot_bd_net,tot_net_sales))*100,2) desc ) 
           , 0 rnk_bd_per
           , dstmgr_name
           , dstmgr_activate_campaign dstmgr_st_camp
           , t_post.padentry_edesc position 
           , ar_par.p3hqualified_amt base_amt
           --(ar_par.p3hqualified_amt * camp_count) base_amt , 
           --round(((tt_receipt/(ar_par.p3hqualified_amt * camp_count))*100) -100,2) inc_per ,  -- 18/09/2012
             
      from      (  select distinct 
                          sddnsm  a_nsm, 
                          sdddiv  a_div,
                          sddloc_code a_loc_code, 
                          first_value (sddno_of_msl) over    (partition by  sddnsm, sdddiv, sddloc_code 
                                                                  order by  sddnsm, sdddiv, sddloc_code , substr(sddcampaign,3,4)||substr(sddcampaign,1,2))  firt_camp_no_msl , 
                          count(*) over (partition by sddnsm, sdddiv, sddloc_code
                                             order by sddnsm, sdddiv, sddloc_code nulls first) camp_count    
                     from sa_daily_byloc_hdr 
                    where sddou_code = '000'
                      and sddnsm between nvl(:p_select_s_nsm, '$') and nvl(:p_select_e_nsm , chr(250))
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = sddloc_code)
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) >= (select nvl(substr(dstmgr_activate_campaign,3,4)||substr(dstmgr_activate_campaign,1,2),'999999') 
                                                                                 from db_sales_location 
                                                                                where dstou_code  = sddou_code and dstloc_code = sddloc_code)
                      and sddloc_code in ('0142','0165','0166','0167','0168','0707','0409','0046','0507','0687','0223')
                 order by sddnsm , sdddiv , sddloc_code                   
                ) a, 
                ----------------------------------------------------------------
                (  select sddnsm b_nsm, 
                          sdddiv b_div,
                          sddloc_code b_loc_code
                        , nvl(sum(case when substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp then sddno_of_order else 0 end),0) tot_no_order
                        , nvl(sum(case when substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp then sddno_of_msl   else 0 end),0) tot_no_of_msl
                        , nvl(sum(case when substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp then sddnet_sales   else 0 end),0) tot_net_sales
                        , nvl(sum(case when substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp then sddno_of_first else 0 end),0) tot_no_first
                        , nvl(sum(case when substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp then nvl(sddbd_transfer,0) - nvl(sddbd_collect,0) else 0 end),0) tot_bd_net
                     from sa_daily_byloc_hdr
                    where sddou_code = '000' 
                    --and sddnsm between nvl(:p_select_s_nsm, '$') and nvl(:p_select_e_nsm , chr(250))
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = sddloc_code)
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp 
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) >= (select nvl(substr(dstmgr_activate_campaign,3,4)||substr(dstmgr_activate_campaign,1,2),'999999') 
                                                                                 from db_sales_location 
                                                                                where dstou_code  = sddou_code and dstloc_code = sddloc_code)
                      and sddloc_code in ('0142','0165','0166','0167','0168','0707','0409','0046','0507','0687','0223')
                 group by sddnsm , sdddiv , sddloc_code 
                 order by sddnsm , sdddiv , sddloc_code
                ) b ,
                --- Position ---- 
                (  select dstloc_code, dstmgr_position, dstmgr_payplan, dstmgr_activate_campaign, 
                          dstmgr_name||case when trim(dstmgr_shrtname) is not null then ' ('||trim(dstmgr_shrtname)||')' else null end dstmgr_name, nvl(padentry_code, '1') padentry_code,                            
                          nvl(padcha1, padentry_ldesc) padentry_edesc
                     from db_sales_location , su_param_dtl 
                    where dstou_code                = '000' --:s_ou_code
                      and padparam_id               = 303
                      and nvl(dstmgr_position,1) = padentry_code   
                      and nvl(dstmgr_activate_campaign,'999999') <= :p_end_camp
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = dstloc_code)
                ) t_post ,
                --- Base Amount for Commission --- 
                (  select padentry_code p3hposition_code, padnum1 p3hqualified_amt
                     from su_param_dtl
                    where padparam_id = 906 
                ) ar_par  
      where a_nsm = b_nsm 
        and a_div = b_div 
        and a_loc_code = b_loc_code 
        and a_loc_code = dstloc_code
        and t_post.padentry_code  = ar_par.p3hposition_code(+)
      ) temp_result 
where  not exists (select dstinactive_status from db_sales_location where dstou_code = ou_code   and dstloc_code = a_loc_code  and dstloc_type ='S'  and dstinactive_status ='1' )
 
order by decode(nvl(:p_nsm_cond, '0'), '0', 'ALL', a_nsm) 
, nvl(rnk_first_rep,0) + nvl(rnk_no_order,0) + nvl(rnk_net_sales,0) + nvl(rnk_first_600,0) + nvl(rnk_bd_net,0) + nvl(rnk_bd_per,0) asc
, a_loc_code




--sa_daily_byloc_hdr
