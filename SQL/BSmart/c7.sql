--   Net Sales ใช้ Script นี้ครับ

select * from table( PKGBW_OMQUERY1.pipxOmC7NetSales('000','8338','072013'))
where rep_code = '0772038784'


-------------------------------------------------------------------------------------------------------------------------------------------------
--   Badept. ใช้ Script นี้ครับ

select * --SUM(bd_collect) s_col, sum(jmt_collect) s_jmt, SUM(bd_collect) + sum(jmt_collect) ttl 
from table( PKGBW_OMQUERY1.pipxOmC7ARReceipt('000','0772','022013')) 
where reprep_code = '0772038784'



-------------------------------------------------------------------------------------------------------------------------------------------------
select * from ar_transactions_hdr
where tshou_code = '000'
  and tshcampaign = '072013'
  and tshdistrict_code = '8636'
  and tshtrans_type in ('TOUBD','DOUBD')
  
  
  
select * from ms_count_rep
where recou_code = '000'
  and recas_of_date between to_date('27/03/2013','dd/mm/rrrr') and to_date('09/04/2013','dd/mm/rrrr')
  and recloc_code = '8636'
  
  
  
select * 
from ms_transaction
where retou_code = '000'
  and rettran_type  in ('RI', 'RE', 'DE')
  and rettran_loc_code = '8636'
