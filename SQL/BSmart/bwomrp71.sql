/****************************************************************************************************************************************************/
/****************************************************************************************************************************************************/
SELECT '000' ou_code,
       opt.optupd_rep_code rep_code,
       SUBSTR (opt.optupd_rep_code, 1, 4) || '-' || SUBSTR (opt.optupd_rep_code, 5, 5) || '-' || SUBSTR (opt.optupd_rep_code, 10, 1) rep_code_fm,
       opt.optnsm pnt_nsm,
       opt.point_bal_with_sign,
       scd.scdlevel_disp level_disp,
       opt.optact_point_bal,
       opt.optact_point_bal_sign
  FROM (SELECT /*+USE_MERGE(ds1,op1)*/
               op1.optou_code,
               op1.optupd_rep_code optupd_rep_code,
               op1.optnsm,
               op1.optact_point_bal point_bal_with_sign,
               op1.optline_seq optline_seq,
               ABS (op1.optact_point_bal) optact_point_bal,
               DECODE (SIGN (op1.optact_point_bal), -1, '-', '') optact_point_bal_sign
          FROM om_transaction_pnt op1
               --,db_sales_location ds1
         WHERE op1.optou_code = '000'
           AND op1.optpoint_prog_type = 'B'
           --AND op1.optpnt_type = 'P'
           --AND ds1.dstloc_type = 'S'
           --AND NVL (ds1.dstspecial_status, '0') = '0'
           AND op1.optline_seq = (SELECT MAX (op2.optline_seq)
                                    FROM om_transaction_pnt op2
                                   WHERE op2.optou_code = '000'
                                     AND op2.optpoint_prog_type = 'B'
                                     AND TRUNC (op2.opttrans_date) BETWEEN TO_DATE ('01/12/2013', 'DD/MM/YYYY') AND TO_DATE ('31/12/2013', 'DD/MM/YYYY') + 0.99999
                                     AND op2.optou_code = op1.optou_code
                                     AND op2.optupd_rep_code = op1.optupd_rep_code)
           AND TRUNC (op1.opttrans_date) BETWEEN TO_DATE ('01/01/2014', 'DD/MM/YYYY') AND TO_DATE ('31/01/2014', 'DD/MM/YYYY') + 0.99999
           --AND INSTR (NVL (:p_select_dist, '@' || ds1.dstsales_group || '@'), '@' || ds1.dstsales_group || '@') > 0
           --AND ds1.dstou_code = op1.optou_code
           --AND ds1.dstloc_code = SUBSTR (op1.optupd_rep_code, 1, 4)
           ) opt,
       sa_criteria_lvl_dtl scd
 WHERE scd.scdou_code = '000'
   AND scd.scdprogref_id = 'BWOMRP71'
   AND scd.scdcode = '71/103/13' --:p_level_temp
   AND opt.point_bal_with_sign BETWEEN scd.scdcriteria_snumber AND scd.scdcriteria_enumber
GROUP BY opt.optupd_rep_code, opt.optnsm, opt.point_bal_with_sign, scd.scdlevel_disp, opt.optact_point_bal, opt.optact_point_bal_sign
ORDER BY opt.optupd_rep_code



/****************************************************************************************************************************************************/
SELECT opt.optupd_rep_code rep_code_p,
       opt.optpoint_campaign pnt_camp_p,
       CASE
           WHEN NVL (opt.optpoint_campaign, ' ') <> ' ' THEN SUBSTR (opt.optpoint_campaign, 1, 2) || '/' || SUBSTR (opt.optpoint_campaign, 3, 4)
       END pnt_camp_p_fm,
       opt.optrefer_trans_no ref_trans_no_p,
       SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0)) point_p,
       ABS (SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0))) pnt_point_p,
       DECODE (SIGN (SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0))), -1, '-', '') sign_point_p
  FROM db_sales_location dst,
       om_transaction_pnt opt
 WHERE opt.optou_code = :s_ou_code
   AND opt.optpoint_prog_type = 'B'
   AND opt.optupd_rep_code = :rep_code
   AND opt.optpnt_type = 'P'
   AND TRUNC (opt.opttrans_date) BETWEEN TO_DATE (:p_s_date, 'DD/MM/YYYY') AND TO_DATE (:p_e_date, 'DD/MM/YYYY')
   AND NVL (dst.dstspecial_status, '0') = '0'
   AND INSTR (NVL (:p_select_dist, '@' || dst.dstsales_group || '@'), '@' || dst.dstsales_group || '@') > 0
   AND dst.dstou_code = opt.optou_code
   AND dst.dstloc_code = SUBSTR (opt.optupd_rep_code, 1, 4)
GROUP BY opt.optupd_rep_code, opt.optpoint_campaign, opt.optrefer_trans_no
ORDER BY SUBSTR (opt.optpoint_campaign, 3, 4) || SUBSTR (opt.optpoint_campaign, 1, 2), opt.optrefer_trans_no

/****************************************************************************************************************************************************/

SELECT opt.optupd_rep_code rep_code_r,
       opt.optpoint_campaign pnt_camp_r,
       CASE
           WHEN NVL (optpoint_campaign, ' ') <> ' ' THEN SUBSTR (optpoint_campaign, 1, 2) || '/' || SUBSTR (optpoint_campaign, 3, 4)
       END pnt_camp_r_fm,
       opt.optrefer_trans_no ref_trans_no_r,
       SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0)) point_r,
       ABS (SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0))) pnt_point_r,
       DECODE (SIGN (SUM (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0))), -1, '-', '') sign_point_r
  FROM db_sales_location dst,
       om_transaction_pnt opt
 WHERE opt.optou_code = :s_ou_code
   AND opt.optpoint_prog_type = 'B'
   AND opt.optupd_rep_code = :rep_code
   AND opt.optpnt_type = 'R'
   AND TRUNC (opt.opttrans_date) BETWEEN TO_DATE (:p_s_date, 'DD/MM/YYYY') AND TO_DATE (:p_e_date, 'DD/MM/YYYY')
   AND NVL (dst.dstspecial_status, '0') = '0'
   AND INSTR (NVL (:p_select_dist, '@' || dst.dstsales_group || '@'), '@' || dst.dstsales_group || '@') > 0
   AND dst.dstou_code = opt.optou_code
   AND dst.dstloc_code = SUBSTR (opt.optupd_rep_code, 1, 4)
GROUP BY opt.optupd_rep_code, opt.optpoint_campaign, opt.optrefer_trans_no
ORDER BY SUBSTR (opt.optpoint_campaign, 3, 4) || SUBSTR (opt.optpoint_campaign, 1, 2), opt.optrefer_trans_no

/****************************************************************************************************************************************************/

SELECT tmp.rep_code,
       tmp.camp_mt,
       tmp.camp_a,
       tmp.camp_e,
       CASE WHEN NVL (tmp.camp_mt, ' ') <> ' ' THEN SUBSTR (tmp.camp_mt, 1, 2) || '/' || SUBSTR (tmp.camp_mt, 3, 4) END camp_mt_fm,
       CASE WHEN NVL (tmp.camp_a, ' ') <> ' ' THEN SUBSTR (tmp.camp_a, 1, 2) || '/' || SUBSTR (tmp.camp_a, 3, 4) END camp_a_fm,
       CASE WHEN NVL (tmp.camp_e, ' ') <> ' ' THEN SUBSTR (tmp.camp_e, 1, 2) || '/' || SUBSTR (tmp.camp_e, 3, 4) END camp_e_fm,
       tmp.pnt_type_mt,
       tmp.pnt_type_a,
       tmp.pnt_type_e,
       SUM (tmp.pnt_point_mt) point_mt,
       SUM (tmp.pnt_point_a) point_a,
       SUM (tmp.pnt_out_e) point_e,
       ABS (SUM (tmp.pnt_point_mt)) pnt_point_mt,
       ABS (SUM (tmp.pnt_point_a)) pnt_point_a,
       ABS (SUM (tmp.pnt_out_e)) pnt_out_e,
       DECODE (SIGN (SUM (tmp.pnt_point_mt)), -1, '-', '') sign_point_mt,
       DECODE (SIGN (SUM (tmp.pnt_point_a)), -1, '-', '') sign_point_a,
       DECODE (SIGN (SUM (tmp.pnt_out_e)), -1, '-', '') sign_point_e
  FROM (SELECT opt.optupd_rep_code rep_code,
               CASE WHEN opt.optpnt_type IN ('M', 'T') THEN opt.optpoint_campaign END camp_mt,
               CASE WHEN opt.optpnt_type = 'A' THEN opt.optpoint_campaign END camp_a,
               CASE WHEN opt.optpnt_type = 'E' THEN opt.optpoint_campaign END camp_e,
               CASE WHEN opt.optpnt_type IN ('M', 'T') THEN 'MT' END pnt_type_mt,
               CASE WHEN opt.optpnt_type = 'A' THEN 'A' END pnt_type_a,
               CASE WHEN opt.optpnt_type = 'E' THEN 'E' END pnt_type_e,
               CASE WHEN opt.optpnt_type IN ('M', 'T') THEN (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0)) END pnt_point_mt,
               CASE WHEN opt.optpnt_type = 'A' THEN (NVL (opt.optact_point_in, 0) - NVL (opt.optact_point_out, 0)) END pnt_point_a,
               CASE WHEN opt.optpnt_type = 'E' THEN (NVL (opt.optact_point_out, 0)) END pnt_out_e
          FROM db_sales_location dst,
               om_transaction_pnt opt
         WHERE opt.optou_code = :s_ou_code
           AND opt.optpoint_prog_type = 'B'
           AND opt.optupd_rep_code = :rep_code
           AND opt.optpnt_type IN ('M', 'T', 'A', 'E')
           AND TRUNC (opt.opttrans_date) BETWEEN TO_DATE (:p_s_date, 'DD/MM/YYYY') AND TO_DATE (:p_e_date, 'DD/MM/YYYY')
           AND NVL (dst.dstspecial_status, '0') = '0'
           AND INSTR (NVL (:p_select_dist, '@' || dst.dstsales_group || '@'), '@' || dst.dstsales_group || '@') > 0
           AND dst.dstou_code = opt.optou_code
           AND dst.dstloc_code = SUBSTR (opt.optupd_rep_code, 1, 4)) tmp
GROUP BY tmp.rep_code, tmp.camp_mt, tmp.camp_a, tmp.camp_e, tmp.pnt_type_mt, tmp.pnt_type_a, tmp.pnt_type_e
ORDER BY SUBSTR (tmp.camp_mt, 1, 2) || '/' || SUBSTR (tmp.camp_mt, 3, 4), SUBSTR (tmp.camp_a, 1, 2) || '/' || SUBSTR (tmp.camp_a, 3, 4), SUBSTR (tmp.camp_e, 1, 2) || '/' || SUBSTR (tmp.camp_e, 3, 4)

/****************************************************************************************************************************************************/

/****************************************************************************************************************************************************/

select * from db_sales_location where dstloc_code = '8601'
