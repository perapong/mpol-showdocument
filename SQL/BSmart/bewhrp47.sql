select '000' ou_code, wh_from, wh_to, fs_code, unit_per_pack, sum(unit_out) unit_out, sum(unit_in) unit_in 
from (
        select tran_type, wh_code, nvl(whfrom,wh_code) wh_from, wh_to, fs_code, unit_per_pack
             --, decode(tran_type,'20',wh_code,whfrom) wh_out, decode(tran_type,'21',wh_code,wh_to) wh_to
             , ttl_unit*(-1) unit_out, 0 unit_in
        from bev$_whstock_card a
        where tran_type = '20' 
        and fs_code like '02881' 
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate 
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
          and wh_code between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and wh_to between nvl('10001','$') and nvl('10001',chr(250))
          and sub_type not in ('208','218')
        union all
        select tran_type, wh_code, nvl(whfrom,wh_code) wh_from, wh_to, fs_code, unit_per_pack 
             , 0 unit_out, ttl_unit unit_in
        from bev$_whstock_card a
        where tran_type = '21' 
        and fs_code like '02881' 
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate 
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
          and wh_to between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and wh_code between nvl('10001','$') and nvl('10001',chr(250))
          and sub_type not in ('208','218')
) aa 
group by wh_from, wh_to, fs_code, unit_per_pack
order by wh_from, wh_to, fs_code, unit_per_pack  

select '000' ou_code, wh_from, wh_to, fs_code, unit_per_pack, sum(unit_out) unit_out, sum(unit_in) unit_in 
from (
        select tran_type, wh_code, nvl(whfrom,wh_code) wh_from, wh_to, fs_code, unit_per_pack
             --, decode(tran_type,'20',wh_code,whfrom) wh_out, decode(tran_type,'21',wh_code,wh_to) wh_to
             , ttl_unit*(-1) unit_out, 0 unit_in
        from bev$_whstock_card a
        where tran_type = '20' 
        and fs_code like '02881' 
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate 
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
          and wh_code between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and wh_to between nvl('10001','$') and nvl('10001',chr(250))
          and sub_type not in ('208','218')
        union all
        select tran_type, wh_code, nvl(whfrom,wh_code) wh_from, wh_to, fs_code, unit_per_pack 
             , 0 unit_out, ttl_unit unit_in
        from bev$_whstock_card a
        where tran_type = '21' 
        and fs_code like '02881' 
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate 
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
          and wh_to between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and wh_code between nvl('10001','$') and nvl('10001',chr(250))
          and sub_type not in ('208','218')
) aa 
group by wh_from, wh_to, fs_code, unit_per_pack
order by wh_from, wh_to, fs_code, unit_per_pack  

/************************************************************************************************************************************/

select unit_per_pack, decode(tran_type,'20',ttl_unit*(-1),0) unit_out, decode(tran_type,'21',ttl_unit,0) unit_in, a.* from bev$_whstock_card a
where (tran_type = '20' or tran_type = '21')
  and tran_date between to_date('23/07/2013','dd/mm/rrrr') and to_date('23/07/2013','dd/mm/rrrr') 
--and whfrom between nvl(:P_WH_FROM_S,'$') and nvl(:P_WH_FROM_E,chr(250))
--and wh_to between nvl(:P_WH_TO_S,'$') and nvl(:P_WH_TO_E,chr(250))
  and sub_type not in ('208','218','209','219')
  and fs_code = '61698'  --01136
  and wh_code in ('BWC2','10001')
  and wh_to in ('BWC2','10001')
  
  
/*
select '000' ou_code, --tran_type,wh_code,  
wh_from, wh_to, fs_code, unit_per_pack, sum(unit_out) unit_out, sum(unit_in) unit_in 
from (
        select tran_type, wh_code, decode(tran_type,'21',wh_to,whfrom) wh_from, decode(tran_type,'21',whfrom,wh_to) wh_to, fs_code, unit_per_pack 
             --, decode(tran_type,'20',ttl_unit*(-1),0) unit_out, decode(tran_type,'21',ttl_unit,0) unit_in
             , ttl_unit*(-1) unit_out, 0 unit_in
        from bev$_whstock_card a
        where tran_type = '20'
          and sub_type not in ('208','218')
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate and fs_code like '01136' -- '01435%'
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
        --and whfrom between nvl(:P_WH_FROM_S,'$') and nvl(:P_WH_FROM_E,chr(250))
        --and wh_to between nvl(:P_WH_TO_S,'$') and nvl(:P_WH_TO_E,chr(250))
          and wh_to between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and whfrom between nvl('10001','$') and nvl('10001',chr(250))
        union
        select tran_type, wh_code, decode(tran_type,'21',wh_to,whfrom) wh_from, decode(tran_type,'21',whfrom,wh_to) wh_to, fs_code, unit_per_pack 
             , 0 unit_out, ttl_unit unit_in
        from bev$_whstock_card a
        where tran_type = '21'
          and sub_type not in ('208','218')
          and tran_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate and fs_code like '01136' -- '01435%'
        --and tran_date between to_date(:P_DOC_DATE_S,'dd/mm/rrrr') and to_date(:P_DOC_DATE_E,'dd/mm/rrrr')
        --and wh_to between nvl(:P_WH_FROM_S,'$') and nvl(:P_WH_FROM_E,chr(250))
        --and whfrom between nvl(:P_WH_TO_S,'$') and nvl(:P_WH_TO_E,chr(250))
          and whfrom between nvl('BWC2','$') and nvl('BWC2',chr(250))
          and wh_to between nvl('10001','$') and nvl('10001',chr(250))
) aa 
group by --tran_type, wh_code, 
wh_from, wh_to, fs_code, unit_per_pack
order by wh_from, wh_to, fs_code, unit_per_pack

*/


select  wthtrans_type_code, wthwh_code, wthtransfer_to_wh, wthtransfer_from_wh, 
h.*,d.*
from wh_trans_hdr h, wh_trans_dtl d
where wthou_code = '000'
  --and wthtrans_no in ('13BWI0000019315','13070882')
  and h.wthou_code = d.wtdou_code
  and h.wthwh_code = d.wtdwh_code
  and h.wthtrans_type_code = d.wtdtrans_type_code
  and h.wthtrans_sub_type = d.wtdtrans_sub_type
  and h.wthtrans_no = d.wtdtrans_no
  and h.wthtrans_type_code in ('20','21')
  and d.wtdfinished_code in ('02881','01136')
  and h.wthwh_code in ('BWC2','10001')
  and h.wthtransfer_to_wh in ('BWC2','10001')
  and h.wthtrans_date between to_date('01/07/2013','dd/mm/rrrr') and sysdate
  





select wthtransfer_from_wh,wthtransfer_to_wh, h.* --,d.*
from wh_trans_hdr h--, wh_trans_dtl d
where wthou_code = '000'
  and wthtrans_no in ('13BWI0000019315','13070882')
  
  
select * from wh_trans_loc where wtlou_code = '000' and wtltrans_no in ('13BWI0000019315','13070882')
and wtlfinished_code in ('02881','01136')


select * from bev$_mailplan where loc_code = '8105'
