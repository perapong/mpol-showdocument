-- case iv = 0 and wh <> 0 --


insert into wh_trans_loc (wtlou_code, wtlwh_code, wtltrans_type_code, wtltrans_sub_type,
       wtltrans_no, wtlfinished_code, wtlmajor_code, wtlminor_code,
       wtlloc_type, wtlloc_date, wtlord_seq, wtlunit_per_pack,
       wtlqty_pack, wtlqty_unit, wtlttl_unit, wtldamage_unit,
       wtladj_type, wtlbef_qty_pack, wtlbef_qty_unit, wtlbef_ttl_unit,
       wtllot_no, wtlexpired_date, wtlso_no, wtlcubic, wtlbarcode,
       wtlreason_group, wtlreason_code, wtlcre_by, wtlcre_date,
       wtlprog_id, wtlupd_by, wtlupd_date, wtlcost_unit
  )
SELECT '000' wtlou_code, '10041' wtlwh_code, '16' wtltrans_type_code, '160' wtltrans_sub_type,
      
        '14050047' wtltrans_no, 
      
        z.fs_code wtlfinished_code, 
        major wtlmajor_code, minor wtlminor_code,
        loc_type wtlloc_type, 
        locdate wtlloc_date, 
        row_number() OVER (PARTITION by wh_code ORDER BY wh_code ) wtlord_seq, 
        unit_per_pack wtlunit_per_pack,
        abs(wh_qty_pack) wtlqty_pack, 
        abs(wh_qty_unit) wtlqty_unit, 
        abs(wh_ttl_unit) wtlttl_unit, null wtldamage_unit,
        decode (sign(wh_ttl_unit),1,'+','-') wtladj_type,  null wtlbef_qty_pack,  null wtlbef_qty_unit,  null wtlbef_ttl_unit,
        null wtllot_no,  null wtlexpired_date,  null  wtlso_no,  null wtlcubic, null  wtlbarcode,
        null wtlreason_group, null  wtlreason_code,
        'PERAPONG' wtlcre_by,to_date('18/05/2014 11:21:24','dd/mm/rrrr hh24:mi:ss') wtlcre_date,
        'BWWHDT24' wtlprog_id, 
        'PERAPONG' wtlupd_by, to_date('18/05/2014 11:21:24','dd/mm/rrrr hh24:mi:ss') wtlupd_date, null wtlcost_unit
 from zp_adj_whtrans z


insert into wh_trans_dtl (wtdou_code, wtdwh_code, wtdtrans_type_code, wtdtrans_sub_type,
       wtdtrans_no, wtdfinished_code, wtdord_seq, wtdbarcode,
       wtdunit_per_pack, wtdqty_pack, wtdqty_unit, wtdttl_unit,
       wtdreason_group, wtdreason_code, wtdadj_type, wtdstation_code,
       wtdcre_by, wtdcre_date, wtdprog_id, wtdupd_by, wtdupd_date  )
SELECT '000' wtdou_code, '10041' wtdwh_code, '16' wtdtrans_type_code, '160' wtdtrans_sub_type,
       '14050047' wtdtrans_no, z.fs_code wtdfinished_code, 
       row_number() OVER (PARTITION by wh_code ORDER BY wh_code ) wtdord_seq, null wtdbarcode,
       unit_per_pack wtdunit_per_pack, 
       abs(wh_qty_pack) wtdqty_pack, 
       abs(wh_qty_unit) wtdqty_unit, 
       abs(wh_ttl_unit) wtdttl_unit,
       null wtdreason_group, null wtdreason_code, 
       decode (sign(wh_ttl_unit),1,'+','-') wtdadj_type, null wtdstation_code,
       'PERAPONG' wtdcre_by, to_date('18/05/2014 11:21:24','dd/mm/rrrr hh24:mi:ss')wtdcre_date, 'BWWHDT24' wtdprog_id, 
       'PERAPONG' wtdupd_by, to_date('18/05/2014 11:21:24','dd/mm/rrrr hh24:mi:ss')wtdupd_date
from (select wh_code, fs_code, unit_per_pack, 
            sum(wh_qty_pack) wh_qty_pack, sum(wh_qty_unit) wh_qty_unit, sum(wh_ttl_unit) wh_ttl_unit
            from zp_adj_whtrans z
            group by wh_code, fs_code, unit_per_pack
) z

     

     

