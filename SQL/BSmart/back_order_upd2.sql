SELECT --pkgom_master.get_finished_desc('TH','86131') dd, 
pkgom_master.get_bilbill_desc('000','052013','86131') FROM dual a


create table zp_tmp_backorder3 as
select h.ohdrep_seq, h.ohdyear, h.ohdtrans_group, h.ohdtrans_date, d.* 
from om_transaction_hdr h, om_transaction_dtl d
where ohdou_code = '000'
and ohdyear = 13 and ohdtrans_group = 11 
and ohdtrans_date between to_date('01/03/2013','dd/mm/rrrr') and to_date('04/03/2013','dd/mm/rrrr')
--and ohdrep_seq = 1025017
and h.ohdou_code = d.odtou_code 
and h.ohdyear = d.odtyear
and h.ohdtrans_group = d.odttrans_group
and h.ohdtrans_no = d.odttrans_no
and d.odtref_bill_linseq = 9998

select * from om_transaction_dtl where odttrans_no = '1101244115'

select (select bckbackorder_status from om_backorder where bckou_code = a.odtou_code and bckback_ord_campaign = '052013' and bckrep_seq = ohdrep_seq and bckbill_code = odtbill_code and bckbackorder_status = 0) r
, a.* from zp_tmp_backorder2 a 
where ohdrep_seq = --5921866  --
--1025017
157472
--where odtbill_code = '01023'


select *
from om_backorder 
where bckou_code = '000' 
and bckback_ord_campaign in ('032013', '052013')
and bckrep_seq = 1025017 
--and bckbill_code = odtbill_code and bckbackorder_status = 0




declare
    cursor rec is
    select --(select bckbackorder_status from om_backorder where bckou_code = a.odtou_code and bckback_ord_campaign = '052013' and bckrep_seq = ohdrep_seq and bckbill_code = odtbill_code and bckbackorder_status = 0) r,
        a.* from zp_tmp_backorder3 a 
        --where ohdrep_seq = 1025017
        ;
BEGIN
    For Trec In Rec Loop
        Begin 
            update om_backorder
               set bckbackorder_status = 1
                 , bcknewtrans_year = 13
                 , bcknewtrans_group = trec.odttrans_group
                 , bcknewtrans_no = trec.odttrans_no
                 , bcknewtrans_date = trec.ohdtrans_date
                 , bckprog_id = 'MANUAL'
                 , bckupd_by = 'PERAPONG'
                 , bckupd_date = sysdate
             where bckou_code = Trec.odtou_code
               and bckback_ord_campaign = '052013'
               and bckrep_seq = Trec.ohdrep_seq
             --and bckback_seq = Trec.bckback_seq
               and bckbill_code = Trec.odtbill_code
               and bckbackorder_status = 0
            ; 
          
            Exception when no_data_found Then Begin null; End;
        End;
    End Loop;
  
END;

select * from om_backorder where bckprog_id = 'MANUAL'
                 and bckupd_by = 'PERAPONG' and bckupd_by = 'PERAPONG'
                 and trunc(bckupd_date) = trunc(sysdate)










