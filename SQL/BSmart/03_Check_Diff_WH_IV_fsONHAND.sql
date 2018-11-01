
select wh.wh_code ,
       (select whwwh_desc from wh_warehouse where whwou_code ='000' and  whwwh_code = nvl(wh.wh_code ,iv.wh_code)) wh_name,
       nvl(whfs_code,ivfs_code) finished_code,
       pkgom_master.get_finished_desc('TH',nvl(whfs_code,ivfs_code)) finished_name,

       wh_bal_unit, iv.wh_code iv_whcode , iv_bal_unit, (abs(nvl(iv_bal_unit,0)) - abs(nvl(wh_bal_unit,0))) diff_unit
from ( select wh_code, fs_code whfs_code, sum(ttl_unit) wh_bal_unit
from bev$_whstock_card
where ou_code = '000'
  and wh_code = '20004'
  and tran_date between to_date('01/05/2014','dd/mm/rrrr') and to_date('31/05/2014','dd/mm/rrrr')
group by wh_code , fs_code ) wh  full join 

(select wh_code, finished_code ivfs_code, sum(dx.qty_unit) iv_bal_unit
from bev$_ivstock_card dx
where ou_code = '000'
  and wh_code = '20004'
  and tran_date between to_date('01/05/2014','dd/mm/rrrr') and to_date('31/05/2014','dd/mm/rrrr') 
group by wh_code,finished_code ) iv on   iv.wh_code = wh.wh_code and wh.whfs_code = iv.ivfs_code

order by wh_code nulls first , diff_unit 

