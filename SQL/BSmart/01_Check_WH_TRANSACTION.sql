select  wthwh_code,wtdtrans_type_code,wtdtrans_sub_type,wtdtrans_no
from (
 select h1.wthtrans_date,h1.wthwh_code, d1.wtdtrans_type_code, d1.wtdtrans_sub_type , d1.wtdtrans_no, d1.wtdfinished_code ,d1.wtdunit_per_pack upack_dtl,d1.wtdqty_pack, d1.wtdqty_unit, d1.wtdttl_unit,  
  d2.wtlunit_per_pack, sum(nvl(d2.wtlqty_pack,0)) qty_pack , sum(nvl(wtlqty_unit,0)) qty_unit , sum(nvl(wtlttl_unit,0)) ttl_unit 
from wh_trans_hdr h1, wh_trans_dtl d1 , wh_trans_loc d2
where d1.wtdou_code        = d2.wtlou_code(+)
 and d1.wtdwh_code         = d2.wtlwh_code(+)
 and d1.wtdtrans_type_code = d2.wtltrans_type_code(+)
 and d1.wtdtrans_sub_type  = d2.wtltrans_sub_type(+)
 and d1.wtdtrans_no        = d2.wtltrans_no(+)
 and d1.wtdfinished_code   = d2.wtlfinished_code(+)
 
 and h1.wthou_code          = d1.wtdou_code
 and h1.wthwh_code          = d1.wtdwh_code
 and h1.wthtrans_type_code  = d1.wtdtrans_type_code
 and h1.wthtrans_sub_type   = d1.wtdtrans_sub_type
 and h1.wthtrans_no         = d1.wtdtrans_no
 and h1.wthtrans_type_code !='16'
 and h1.wthwh_code          ='10008'
 and h1.wthtrans_date between to_date('01/05/2014','dd/mm/rrrr') and to_date('31/05/2014','dd/mm/rrrr')
 --and d1.wtdtrans_type_code||d1.wtdtrans_sub_type||d1.wtdtrans_no !='111112RS14007188'
 --and exists (select  'TRUE' from iv_trans_dtl where itdwh_code = '10008' and itdtrans_type_code ='11'  and itdtrans_sub_type  ='111' and itdtrans_no ='2RS14007188'  and itdfinished_code = wtdfinished_code )
 
group by h1.wthtrans_date, h1.wthwh_code, d1.wtdtrans_type_code, d1.wtdtrans_sub_type , d1.wtdtrans_no,d1.wtdfinished_code,d1.wtdunit_per_pack ,d1.wtdqty_pack, 
         d2.wtlunit_per_pack,d1.wtdqty_unit, d1.wtdttl_unit
having sum(nvl(wtlttl_unit,0)) != d1.wtdttl_unit
order by h1.wthtrans_date, wtdtrans_type_code,wtdtrans_no
) 
