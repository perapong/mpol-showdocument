
insert into wh_trans_dtl ( wtdou_code, wtdwh_code, wtdtrans_type_code, wtdtrans_sub_type,
       wtdtrans_no, wtdfinished_code, wtdord_seq, wtdbarcode,
       wtdunit_per_pack, wtdqty_pack, wtdqty_unit, wtdttl_unit,
       wtdreason_group, wtdreason_code, wtdadj_type, wtdstation_code,
       wtdcre_by, wtdcre_date, wtdprog_id, wtdupd_by, wtdupd_date,
       wtdrcv_qty_pack, wtdrcv_qty_unit, wtdrcv_ttl_unit,
       wtdreverse_status, wtdpoqty_unit, wtdcost_unit
 )

SELECT '000' wtdou_code, 'BWC2' wtdwh_code, '21' wtdtrans_type_code, '210' wtdtrans_sub_type,
       '13100007' wtdtrans_no, z.fs_code wtdfinished_code, rownum+1 wtdord_seq, 
       null wtdbarcode,
       (select d.pdtqty_per_pack
        from   db_product_dtl d 
        where d.pdtfinished_code = z.fs_code
        ) wtdunit_per_pack, 
        
       trunc( z.qty/(select d.pdtqty_per_pack
        from   db_product_dtl d 
        where d.pdtfinished_code = z.fs_code
        )) wtdqty_pack, 
        
         mod( z.qty,(select d.pdtqty_per_pack
        from   db_product_dtl d 
        where d.pdtfinished_code = z.fs_code
        )) wtdqty_unit, 
        
        z.qty wtdttl_unit,
        '21' wtdreason_group, '219' wtdreason_code, null wtdadj_type, null wtdstation_code,
      'SUNUNTA' wtdcre_by, to_date('4/10/2013 11:21:24','dd/mm/rrrr hh24:mi:ss') wtdcre_date, 
      'BWWHDT24' wtdprog_id, 'SUNUNTA' wtdupd_by, to_date('4/10/2013 11:21:24','dd/mm/rrrr hh24:mi:ss')  wtdupd_date,
       null wtdrcv_qty_pack, null wtdrcv_qty_unit, null wtdrcv_ttl_unit,
       '0' wtdreverse_status, null wtdpoqty_unit, null wtdcost_unit
 from (
select z1.fs_code, sum(z1.qty) qty
  FROM zk_inv_data  z1
  group by z1.fs_code
  order by z1.fs_code) z

     
