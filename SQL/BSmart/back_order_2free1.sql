--delete zp_tmp_backorder_free
--insert into zp_tmp_backorder_free
select h.ohdtrans_no, h.ohdtrans_date, h.ohdrep_seq, h.ohdrep_code, h.ohdrep_name, sum(d.odttrans_ttlunit) ttlunit, sum(d.odtshort_ttlunit) srtunit, h.ohdloc_code loc_code
from bwprod.om_transaction_hdr h, bwprod.om_transaction_dtl d
where h.ohdou_code = '000'
  and h.ohdyear = 12
  and h.ohdtrans_group in (11,12)
  and trunc(h.ohdtrans_date) between to_date('10/09/2012','dd/mm/rrrr') and to_date('25/09/2012','dd/mm/rrrr')
  and h.ohdcancel_date is null
  and h.ohdou_code = d.odtou_code
  and h.ohdyear = d.odtyear
  and h.ohdtrans_group = d.odttrans_group
  and h.ohdtrans_no = d.odttrans_no
  and d.odtbill_code in ('27695','27697','27699') --27700
--  and d.odtbill_code in ('30063','30065','30067') --30069
--  and nvl(d.odtshort_ttlunit,0) > 0
--  and h.ohdord_campaign in ('122012','132012','142012','152012','162012','172012')
--  and h.ohdrep_code = '0999004310'
--  and h.ohdtrans_no = '1100965386'
--  and d.odtbrand_code = 3
group by h.ohdtrans_no, h.ohdtrans_date, h.ohdrep_seq, h.ohdrep_code, h.ohdrep_name, h.ohdloc_code

--select * from zp_tmp_backorder_free 
select h.*, trunc(ttlunit/2) - nvl((select odttrans_ttlunit from  bwprod.om_transaction_hdr hh, bwprod.om_transaction_dtl d
                            where hh.ohdou_code = '000'
                              and hh.ohdyear = 12
                              and hh.ohdtrans_group in (11,12)
                              and trunc(hh.ohdtrans_date) between to_date('10/09/2012','dd/mm/rrrr') and to_date('25/09/2012','dd/mm/rrrr')
                              and hh.ohdcancel_date is null
                              and hh.ohdou_code = d.odtou_code
                              and hh.ohdyear = d.odtyear
                              and hh.ohdtrans_group = d.odttrans_group
                              and hh.ohdtrans_no = d.odttrans_no
                              and d.odtbill_code in ('27700')
                              and hh.ohdtrans_no = h.ohdtrans_no),0) freeunit
from bwprod.zp_tmp_backorder_free h
where loc_code not in (select dist_code from bev$_skipdist) 
  and ttlunit >= 2
  and srtunit > 0
--  and ohdrep_code <> '0589042323'
order by ohdrep_seq
 
--run back_order.sql    
--------------------------------------------------------------------------------------------------------

/*
declare
cursor rec is 
SELECT  distinct
        '000' bckou_code,
        '212012' bckback_ord_campaign,      --pol
        '212012' bckbill_campaign,          --pol
        ohdrep_seq bckrep_seq,              --pol
        ohdrep_code bckrep_code,            --pol
        ohdrep_seq bckupdate_rep_seq,       --pol
        ohdrep_code bckupdate_rep_code,     --pol
        '27700' bckbill_code,               --pol
        1 bckback_seq,
        freeunit bckback_unit,              --pol
        4 bckback_group,                    --pol
        sysdate bckorder_date,
        0 bckbackorder_status,
        '0' bckfree_status,
        'MANUAL' bckback_type,
        'SCRIPT' bckprog_id,
        SYSDATE bcknewtrans_date,
        'PERAPONG' bckcre_by,
        SYSDATE  bckcre_date,
        'PERAPONG' bckupd_by,
        SYSDATE bckupd_date
  FROM  (select * from (select h.*, trunc(ttlunit/2) - nvl((select odttrans_ttlunit from  bwprod.om_transaction_hdr hh, bwprod.om_transaction_dtl d
                                                            where hh.ohdou_code = '000'
                                                              and hh.ohdyear = 12
                                                              and hh.ohdtrans_group in (11,12)
                                                              and trunc(hh.ohdtrans_date) between to_date('10/09/2012','dd/mm/rrrr') and to_date('25/09/2012','dd/mm/rrrr')
                                                              and hh.ohdcancel_date is null
                                                              and hh.ohdou_code = d.odtou_code
                                                              and hh.ohdyear = d.odtyear
                                                              and hh.ohdtrans_group = d.odttrans_group
                                                              and hh.ohdtrans_no = d.odttrans_no
                                                              and d.odtbill_code in ('27700')
                                                              and hh.ohdtrans_no = h.ohdtrans_no),0) freeunit
                        from bwprod.zp_tmp_backorder_free h
                        where loc_code not in (select dist_code from bev$_skipdist) 
                          and ttlunit = 2
                          and srtunit > 0
                       )
         where freeunit > 0
        ) a;
  
  nSeq NUMBER;
  
  begin
     for Trc In Rec Loop
     
        Begin
           select  Max(bckback_seq) Seq 
              Into nSeq
             from om_backorder
              where bckou_code           = Trc.bckou_code
               and  bckback_ord_campaign = Trc.bckback_ord_campaign
               and  bckrep_seq           = Trc.bckrep_seq;
        End ;
          
        Trc.bckback_seq  := nvl(nSeq,0)+1;
          
        Begin
            INSERT INTO om_backorder( bckou_code, bckback_ord_campaign, bckrep_seq, bckback_seq, bckrep_code, bckbill_campaign, bckbill_code, bckback_unit, bckback_group, bckorder_date,
                                      bckbackorder_status, bckupdate_rep_seq, bckupdate_rep_code, bckfree_status, bckback_type, bcknewtrans_date, bckcre_by, 
                                      bckcre_date,bckprog_id, bckupd_by,bckupd_date) 
                          values (Trc.bckou_code,Trc.bckback_ord_campaign, Trc.bckrep_seq, Trc.bckback_seq, Trc.bckrep_code, Trc.bckbill_campaign, 
                                  Trc.bckbill_code, Trc.bckback_unit, Trc.bckback_group, Trc.bckorder_date,
                                  Trc.bckbackorder_status, Trc.bckupdate_rep_seq, Trc.bckupdate_rep_code, 
                                  Trc.bckfree_status, Trc.bckback_type, Trc.bcknewtrans_date,
                                  Trc.bckcre_by, Trc.bckcre_date,Trc.bckprog_id, Trc.bckupd_by,Trc.bckupd_date);
                        
        
        End;
     End Loop;
     
  End;
*/


        select trunc(b.bckorder_date) doc_date, bckrep_code rep_code, (select reprep_name  from ms_representative t where t.reprep_seq = b.bckrep_seq) rep_name
             , bckbill_code bill_code, bckback_unit back_unit
        from om_backorder b
        where b.bckou_code = '000'
          and trunc(b.bckorder_date) between to_date('10/10/2012','dd/mm/rrrr') and to_date('10/10/2012','dd/mm/rrrr')
          and b.bckbill_code = '27700'
          and b.bckupd_by = 'PERAPONG'
          and b.bckbackorder_status = 0
          
          
          
        delete from  om_backorder b
        where b.bckou_code = '000'
          and trunc(b.bckorder_date) between to_date('10/10/2012','dd/mm/rrrr') and to_date('10/10/2012','dd/mm/rrrr')
          and b.bckbill_code = '27700'
          and b.bckupd_by = 'PERAPONG'
          and b.bckbackorder_status = 0

