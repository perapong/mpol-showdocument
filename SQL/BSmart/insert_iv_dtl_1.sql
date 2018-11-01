insert into iv_trans_dtl ( itdou_code, itdwh_code, itdtrans_type_code, itdtrans_sub_type,
       itdtrans_no, itdline_seq, itdfinished_code, itdbarcode,
       itdord_seq, itdqty_unit, itdstd_cost, itdcost_per_unit,
       itdamount, itdadj_in_unit, itdadj_out_unit, itdreason_group,
       itdreason_code, itdbrand, itdsup_code, itdcarton_date,
       itdcarton_brand, itdcarton_sup_code, itdcarton_no, itdcre_by,
       itdcre_date, itdprog_id, itdupd_by, itdupd_date, itdstation_code,
       itdrcv_qty_unit, itdrcv_cost_per_unit, itdrcv_amount,
       itdreverse_status )
SELECT '000' itdou_code, 'BWC1' itdwh_code, '20' itdtrans_type_code, '200' itdtrans_sub_type,
     '13100024'  itdtrans_no, rownum + 1 itdline_seq, z.fs_code itdfinished_code, 
     null itdbarcode,
     rownum + 1  itdord_seq, z.qty itdqty_unit, 
     null itdstd_cost, null itdcost_per_unit,
     null itdamount,null  itdadj_in_unit,null  itdadj_out_unit,'21' itdreason_group,
     '219'  itdreason_code, null itdbrand,null  itdsup_code,null  itdcarton_date,
      null  itdcarton_brand, null itdcarton_sup_code,null  itdcarton_no, 'SUNUNTA' itdcre_by,
     to_date('4/10/2013 11:21:24','dd/mm/rrrr  hh24:mi:ss') itdcre_date, 'BWWHDT24' itdprog_id, 
     'SUNUNTA' itdupd_by, to_date('4/10/2013 11:21:24','dd/mm/rrrr  hh24:mi:ss') itdupd_date,null itdstation_code,
      null  itdrcv_qty_unit, null  itdrcv_cost_per_unit,null  itdrcv_amount,
      '0' itdreverse_status
 from (
select z1.fs_code, sum(z1.qty) qty
  FROM zk_inv_data  z1
  group by z1.fs_code) z




