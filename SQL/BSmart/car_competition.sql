--:p_period = 13
--:p_start_camp = 201305
--:p_end_camp = 201308
--: mistine or faris  ctrl+f '8
select 
       --ou_code , 
       decode(nvl(:p_nsm_cond, '0'), '0', 'ALL', a_nsm) a_nsm , 
       --case when nvl(:p_nsm_cond, '0') = '0' then null else pkgom_master.get_dstloc_desc(:s_ou_code, a_nsm) end nsm_desc , 
       position ,
       a_loc_code , 
       a_div , 
       dstmgr_name , 
       
       avg_rep, 
       first_rep,
       
       tt_netsales ,
       inc_point , 
--       inc_point2, 
       
--       tt_no_first , 
--       first_point , 
       tt_all_first , 
       allfirst_point , 
       
       nvl(first_rep,0) + nvl(allfirst_point,0) + nvl(inc_point,0)  total_point
--       nvl(first_rep,0) + nvl(first_point,0) + nvl(inc_point,0)  total_point
--       tt_receipt , 
--       base_amt , 
--       inc_per ,
--       firt_camp_no_msl , 
from 
      (select 
            :s_ou_code ou_code , 
             a_nsm , 
             a_div , 
             a_loc_code , 
             firt_camp_no_msl , 
             ceil(tt_no_of_msl/camp_count) avg_rep ,
             rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm)
                                    order by ceil(tt_no_of_msl/camp_count) desc) first_rep ,   
             tt_netsales ,
             rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
                                    order by tt_netsales desc ) inc_point ,
            
             tt_no_first , 
             rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
                                    order by tt_no_first desc ) first_point , 
             tt_all_first , 
             rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), '0', '%', a_nsm) 
                                    order by tt_all_first desc ) allfirst_point , 
                                    
             dstmgr_name , 
             t_post.padentry_edesc position ,
             tt_receipt , 
             (ar_par.p3hqualified_amt * :p_period) base_amt ,
          --   (ar_par.p3hqualified_amt * camp_count) base_amt , 
          --   round(((tt_receipt/(ar_par.p3hqualified_amt * camp_count))*100) -100,2) inc_per ,  -- 18/09/2012
               round((tt_receipt - (ar_par.p3hqualified_amt * :p_period)) /(ar_par.p3hqualified_amt * :p_period) * 100,2) inc_per,   
          --   dense_rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), 0, '%', a_nsm) 
          --                                     order by (((tt_receipt/(ar_par.p3hqualified_amt * camp_count))*100) -100) desc ) 
             dense_rank() over ( partition by decode(nvl(:p_nsm_cond, '0'), 0, '%', a_nsm) 
                                               order by (((tt_netsales/(ar_par.p3hqualified_amt * camp_count))*100) -100) desc )                                  
                          inc_point2
      from      (  select distinct 
                          sddnsm  a_nsm, 
                          sdddiv  a_div,
                          sddloc_code a_loc_code, 
                          first_value (sddno_of_msl) over    (partition by  sddnsm, sdddiv, sddloc_code 
                                                                                 order by  sddnsm, sdddiv, sddloc_code , substr(sddcampaign,3,4)||substr(sddcampaign,1,2))  firt_camp_no_msl , 
                          count(*) over (partition by sddnsm, sdddiv, sddloc_code
                                                    order by sddnsm, sdddiv, sddloc_code nulls first) camp_count                 
                     from sa_daily_byloc_hdr
                      --, db_sales_location 
                    where sddou_code = :s_ou_code
                      and sddnsm between nvl(:p_select_s_nsm, '$') and nvl(:p_select_e_nsm , chr(250))
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = sddloc_code)
                      and (sdddiv between '001' and '033'
                          or sdddiv between '801' and '806')
                      and sddloc_code not in ('049','0904','0970','0999','9994','9996','9997','9998','9999')
                      /*and sddloc_code not like '8%'
                      and sddou_code = dstou_code
                      and sddloc_code = dstloc_code
                      and dstloc_type = 'S'
                      and NVL (dstspecial_status, '0') = '0'
                      and dstdistrict_type <> '02'*/
                    order by sddnsm , sdddiv , sddloc_code                   
                ) a, 
                ----------------------------------------------------------------
                (
                   select sddnsm  b_nsm, 
                          sdddiv b_div,
                          sddloc_code b_loc_code,
                          nvl(sum(sddno_of_msl),0) tt_no_of_msl, 
                          nvl(sum(sddtotal_receipt),0) tt_receipt, 
                          nvl(sum(sddnet_sales),0) tt_netsales, 
                          nvl(sum(sddno_of_first),0) tt_no_first,
                          nvl(sum(sddall_of_first),0) tt_all_first
                     from sa_daily_byloc_hdr
                      --, db_sales_location
                    where sddou_code = :s_ou_code 
                      and sddnsm between nvl(:p_select_s_nsm, '$') and nvl(:p_select_e_nsm , chr(250))
                      and substr(sddcampaign,3,4)||substr(sddcampaign,1,2) between :p_start_camp and :p_end_camp   
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = sddloc_code)
                      and (sdddiv between '001' and '033'
                          or sdddiv between '801' and '806')
                      and sddloc_code not in ('049','0904','0970','0999','9994','9996','9997','9998','9999')
                      /*and sddou_code = dstou_code
                      and sddloc_code = dstloc_code
                      and dstloc_type = 'S'
                      and NVL (dstspecial_status, '0') = '0'
                      and dstdistrict_type <> '02'*/
                    group by sddnsm , sdddiv , sddloc_code 
                    order by sddnsm , sdddiv , sddloc_code
                ) b,
                --- Position ---- 
                ( 
                   select dstloc_code, dstmgr_position, dstmgr_payplan, 
                          dstmgr_name||case when trim(dstmgr_shrtname) is not null then ' ('||trim(dstmgr_shrtname)||')' else null end dstmgr_name, nvl(padentry_code, '1') padentry_code,                            
                          nvl(padcha1, padentry_ldesc) padentry_edesc
                     from db_sales_location , su_param_dtl 
                    where dstou_code             = :s_ou_code
                      and padparam_id            = 303
                      and nvl(dstmgr_position,1) = padentry_code                   
                      and not exists (select 'x' from su_param_dtl where padparam_id = 955 and padentry_code = dstloc_code)
                      and dstloc_code not in ('049','0904','0970','0999','9994','9996','9997','9998','9999')
                      --and dstloc_code not like '8%'
                      --and dstloc_code like '8%'
                ) t_post ,
                --- Base Amount for Commission --- 
                ( 
                    select padentry_code p3hposition_code, padnum1 p3hqualified_amt
                      from su_param_dtl
                     where padparam_id = 905 
                ) ar_par  
      where a_nsm = b_nsm 
        and a_div = b_div 
        and a_loc_code = b_loc_code 
        and a_loc_code = dstloc_code
        and t_post.padentry_code  = ar_par.p3hposition_code(+)
        and t_post.dstmgr_name is not null
      ) temp_result 
--order by decode(nvl(:p_nsm_cond, '0'), '0', 'ALL', a_nsm) , nvl(first_rep,0) + nvl(first_point,0) + nvl(inc_point,0) asc, a_loc_code
order by decode(nvl(:p_nsm_cond, '0'), '0', 'ALL', a_nsm) , nvl(first_rep,0) + nvl(allfirst_point,0) + nvl(inc_point,0) asc, a_loc_code
--:p_period = 13
--:p_start_camp = 201305
--:p_end_camp = 201308
--: mistine or faris  ctrl+f '8
