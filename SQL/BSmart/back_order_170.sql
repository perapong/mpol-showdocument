--create table zp_tmp_b43 as
--delete from zp_tmp_b43
--insert into zp_tmp_b43
select aaa.*--, (select ohdrep_seq from bwprod.om_transaction_hdr h where h.ohdtrans_no = aaa.odttrans_no and h.ohdou_code = aaa.odtou_code and h.ohdyear = 12 and h.ohdtrans_group = aaa.odttrans_group and h.ohdtrans_no = aaa.odttrans_no)
--, (select ohdrep_code from bwprod.om_transaction_hdr h where h.ohdtrans_no = aaa.odttrans_no and h.ohdou_code = aaa.odtou_code and h.ohdyear = 12 and h.ohdtrans_group = aaa.odttrans_group and h.ohdtrans_no = aaa.odttrans_no)
from (


select aa.*, freeunit - nvl(backunit,0) - nvl(saleunit,0) free
from (
--------------------------------

select a.*, trunc(a.price/170) freeunit,
(select bckback_unit from om_backorder where bcktrans_no = a.odttrans_no and bckbill_code = '29075' and bckbackorder_status = 0) backunit ,
(select sum(nvl(odttrans_ttlunit,0) - nvl(odtshort_ttlunit,0)) from  bwprod.om_transaction_hdr hh, bwprod.om_transaction_dtl d
                                                        where hh.ohdou_code = '000'
                                                          and hh.ohdyear = 12
                                                          and hh.ohdtrans_group in (11,12)
                                                          and trunc(hh.ohdtrans_date) between to_date('12/09/2012','dd/mm/rrrr') and to_date('25/09/2012','dd/mm/rrrr')
                                                          and hh.ohdcancel_date is null
                                                          and hh.ohdou_code = d.odtou_code
                                                          and hh.ohdyear = d.odtyear
                                                          and hh.ohdtrans_group = d.odttrans_group
                                                          and hh.ohdtrans_no = d.odttrans_no
                                                          and d.odtbill_code in ('29075')
                                                          and hh.ohdtrans_no = a.odttrans_no) saleunit
from zp_tmp_b42 a
where a.loc_code not in (select dist_code from bev$_skipdist)
--------------------------------
) aa

) aaa
where free > 0
order by 4


update zp_tmp_b42 aaa
set loc_code = (select ohdloc_code from bwprod.om_transaction_hdr h where h.ohdtrans_no = aaa.odttrans_no and h.ohdou_code = aaa.odtou_code and h.ohdyear = 12 and h.ohdtrans_group = aaa.odttrans_group and h.ohdtrans_no = aaa.odttrans_no)
,    rep_seq = (select ohdrep_seq from bwprod.om_transaction_hdr h where h.ohdtrans_no = aaa.odttrans_no and h.ohdou_code = aaa.odtou_code and h.ohdyear = 12 and h.ohdtrans_group = aaa.odttrans_group and h.ohdtrans_no = aaa.odttrans_no)
,   rep_code = (select ohdrep_code from bwprod.om_transaction_hdr h where h.ohdtrans_no = aaa.odttrans_no and h.ohdou_code = aaa.odtou_code and h.ohdyear = 12 and h.ohdtrans_group = aaa.odttrans_group and h.ohdtrans_no = aaa.odttrans_no)

update zp_tmp_b42 a set rep_name = (select reprep_name from ms_representative r where reprep_seq = a.rep_seq)


select a.* from (select rep_code, rep_name, sum(free) free from zp_tmp_b43 group by rep_code, rep_name) a



select * from zp_tmp_b43 where rep_code = '0638071595'

/*

delete from zp_tmp_b42
--insert into zp_tmp_b42
select dd.*
, null loc_code, null rep_seq, null rep_code, null rep_name 
from zp_tmp_b3 dd 
where exists (select 1 from bwprod.om_transaction_dtl t where dd.odtou_code = t.odtou_code
    and dd.odtyear = t.odtyear
    and dd.odttrans_group = t.odttrans_group
    and dd.odttrans_no = t.odttrans_no
--    and t.odtbill_code in ('29079','29083','29131','29129')
    and t.odtbill_code in ('29079','29083')
    and t.odtshort_ttlunit is not null  )


*/
