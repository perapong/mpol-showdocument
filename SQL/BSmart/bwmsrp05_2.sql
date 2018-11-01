
--- Summarry BY Brand----
/* --- 07/02/2012 -------*/
SELECT d.dstou_code recou_code_b,
       decode(pkgom_master.fndLOC_defBrand(d.dstou_code,d.dstloc_code),'2','1',pkgom_master.fndLOC_defBrand(d.dstou_code,d.dstloc_code)) brand_code_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(b.recbeg_rep_count,0)),0) ) begin_repc_b ,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(b.recbeg_appt_count_to,0)),null) ) rep_count_to_b ,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(b.recbeg_appt_count_to,0)) + (nvl(b.recbeg_appt_count_re,0)) + (nvl(b.recbeg_appt_count_de,0)) - (nvl(Cycle,0)) , null) )  rep_move_by_manager_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(b.recbeg_appt_count_ti,0)) + (nvl(b.recbeg_appt_count_ri,0)),null) ) rein_staments_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(cam.campaign1,0)) ,null) ) campaign1_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(cam.campaign2,0)) ,null) ) campaign2_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(cam.campaign3,0)) ,null) ) campaign3_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(cam.campaign4,0)) ,null) ) campaign4_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(cam.campaign5,0)) ,null) ) campaign5_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(Cycle,0)) ,null) )  Cycle_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(Manager,0)) ,null) ) Manager_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(MSL,0)) ,null) ) MSL_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(User1,0)) ,null) ) User_b ,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(CAMPAIGNYTD1,0)) ,null) ) CAMPAIGNYTD1_b,
       sum( decode(trunc(b.recas_of_date) , TO_DATE (:P_AS_OF_DATE, 'DD/MM/YYYY'),(nvl(CAMPAIGNYTD2,0)) ,null) ) CAMPAIGNYTD2_b
FROM   db_sales_location c       
       inner join                    
       db_sales_location d on  c.dstou_code  = d.dstou_code 
                           and c.dstloc_type = 'D'
                           and c.dstloc_code = d.dstparent_loc_code 
                           and d.dstloc_type = 'S'
       inner join 
       db_sales_location n on  n.dstou_code  = c.dstou_code
                           and n.dstloc_type = 'N'
                           and n.dstloc_code = c.dstparent_loc_code
       left outer join 
       ms_count_rep b on  d.dstou_code  = b.recou_code
                      and d.dstloc_code = b.recloc_code 
       left outer join 
           (SELECT  msj.retou_code, 
                    msj.rettran_loc_code,
                    SUM(DECODE (l.padentry_code,'1', 1,0)) Cycle,
                    SUM(DECODE (l.padentry_code,'2', 1,0)) Manager,
                    SUM(DECODE (l.padentry_code,'3', 1,0)) MSL,
                    SUM(DECODE (l.padentry_code,'4', 1,0)) User1                   
            FROM ( SELECT  j.retou_code, 
                           j.rettran_loc_code,
                           rettran_reason_code,
                           j.rettran_date,
                           j.rettran_seq,
                           j.retrep_code
                    FROM ms_transaction j
                    WHERE j.rettran_type = 'RE'
                    AND j.rettran_date = TO_DATE (:P_AS_OF_DATE,'DD/MM/YYYY')   
                    AND j.retcre_date = ( SELECT MAX (d.retcre_date)
                                          FROM ms_transaction d
                                          WHERE NVL (d.rettran_type, 'NR') = 'RE'
                                          AND d.retou_code =  :S_OU_CODE
                                          AND j.retrep_seq = d.retrep_seq
                                          AND j.retou_code = d.retou_code
                                          GROUP BY d.retou_code, d.rettran_type, d.retrep_seq)
                   ) msj, su_param_dtl k , su_param_dtl l
             WHERE msj.rettran_reason_code = k.padentry_code
             AND k.padparam_id = 103
             AND l.padparam_id = 115
             AND k.padcha1 = l.padentry_code
             GROUP BY  msj.retou_code, msj.rettran_loc_code
             ORDER BY  msj.rettran_loc_code  ) 
       reson on  d.dstou_code  = reson.retou_code   
             and d.dstloc_code = reson.rettran_loc_code 
       left outer join 
            (SELECT --distinct 
                      rep.repou_code, 
                      rep.reploc_code,
                      SUM(DECODE (REP.repappt_campaign, :P_PREV_CAMP, 1, 0)) campaign1,
                      SUM(DECODE (REP.repappt_campaign, :P_CURR_CAMP, 1, 0)) campaign2,
                      SUM(DECODE (REP.repappt_campaign, :P_NEXT1_CAMP,1, 0)) campaign3,
                      SUM(DECODE (REP.repappt_campaign, :P_NEXT2_CAMP,1, 0)) campaign4,
                      SUM(DECODE (REP.repappt_campaign, :P_NEXT3_CAMP,1, 0)) campaign5 
               FROM ms_representative rep
               WHERE ( REP.REPAPPT_CAMPAIGN   = :P_PREV_CAMP OR 
                         REP.REPAPPT_CAMPAIGN = :P_CURR_CAMP OR
                         REP.REPAPPT_CAMPAIGN = :P_NEXT1_CAMP OR
                         REP.REPAPPT_CAMPAIGN = :P_NEXT2_CAMP OR
                         REP.REPAPPT_CAMPAIGN = :P_NEXT3_CAMP )
               AND   REP.REPOU_CODE = :S_OU_CODE
               AND   rep.reploc_code not in ('0001', '0002', '0991', '0992', '0993', '0994', '0995', '0996', '0997', '0998') /*20120918*/
               AND   (  (  TRUNC(REP.REPAPPT_DATE) =  TO_DATE(:P_AS_OF_DATE,'DD/MM/YYYY')   AND     
                                REP.REPAPPT_STATUS <> 'DE'    )   
                            OR
                            (  TRUNC(REP.REPAPPT_DATE)         =  TO_DATE(:P_AS_OF_DATE,'DD/MM/YYYY')  AND 
                               TRUNC(REP.REPAPPT_ST_DATE) <> TO_DATE(:P_AS_OF_DATE,'DD/MM/YYYY')  AND      
                                REP.REPAPPT_STATUS =   'DE'    ) ) 
               GROUP BY rep.repou_code, rep.reploc_code) 
       cam on d.dstou_code = cam.repou_code
           and d.dstloc_code = cam.reploc_code  
       left outer join 
            (   select decode(g1.repou_code,null, g2.repou_code,g1.repou_code) repou_code ,
                          decode(g1.reploc_code,null, g2.reploc_code,g1.reploc_code) reploc_code ,
                          sum(nvl(g1.campaignytd1,0))campaignytd1 , 
                          sum(nvl(g2.campaignytd2,0))campaignytd2
                from 
                (select a.repou_code , a.repappt_campaign , a.reploc_code ,
                       count(a.reploc_code) campaignytd1
                from  db_campaign b , ms_representative a
                where b.cpgou_code = :S_OU_CODE
                and   b.cpgcampaign_year = :P_EFF_YEAR
                and   b.cpgcampaign_code = :P_CURR_CAMP
                and   b.cpgcampaign_no = :P_CAMP_NO_CURR 
                and   a.repou_code = b.cpgou_code
                AND   A.REPAPPT_STATUS = 'NR' 
                AND   TRUNC(A.REPAPPT_DATE) <=  TO_DATE(:P_AS_OF_DATE,'DD/MM/YYYY')   
                AND   a.reploc_code not in ('0001', '0002', '0991', '0992', '0993', '0994', '0995', '0996', '0997', '0998') /*20120918*/
                and   a.repappt_campaign = b.cpgcampaign_code
                group by a.repou_code , a.repappt_campaign , a.reploc_code 
                order by a.repou_code , a.repappt_campaign , a.reploc_code 
                ) G1 full outer join 
                (select a.repou_code , a.repappt_campaign , a.reploc_code ,
                        count(a.reploc_code) campaignytd2
                from  db_campaign b , ms_representative a
                where b.cpgou_code = :S_OU_CODE
                and   b.cpgcampaign_year = :P_EFF_NEXT1_YEAR
                and   b.cpgcampaign_code = :P_NEXT1_CAMP
                and   b.cpgcampaign_no = :P_CAMP_NO_NEXT
                and   a.repou_code = b.cpgou_code
                AND  A.REPAPPT_STATUS = 'NR' 
                AND TRUNC(A.REPAPPT_DATE) <=  TO_DATE(:P_AS_OF_DATE,'DD/MM/YYYY')   
                and   a.repappt_campaign = b.cpgcampaign_code
                group by a.repou_code , a.repappt_campaign , a.reploc_code 
                order by a.repou_code , a.repappt_campaign , a.reploc_code ) G2
                on   g1.repou_code  = g2.repou_code 
                and  g1.reploc_code = g2.reploc_code
                group by decode(g1.repou_code,null, g2.repou_code, g1.repou_code) , decode(g1.reploc_code,null, g2.reploc_code, g1.reploc_code)
             ) 
        m_ytd on  d.dstou_code  = m_ytd.repou_code 
              and d.dstloc_code = m_ytd.reploc_code
WHERE nvl(D.DSTSPECIAL_STATUS,'0') = '0'
group by d.dstou_code 
       ,decode(pkgom_master.fndLOC_defBrand(d.dstou_code,d.dstloc_code),'2','1',pkgom_master.fndLOC_defBrand(d.dstou_code,d.dstloc_code))
ORDER BY   2 


