declare
cursor rec is 
SELECT  distinct
        '000' bckou_code,
        '142013' bckback_ord_campaign,      --edit
        '142013' bckbill_campaign,          --edit
        rep_seq bckrep_seq,                 --edit
        rep_code bckrep_code,               --edit
        rep_seq bckupdate_rep_seq,          --edit
        rep_code bckupdate_rep_code,        --edit
        '40488' bckbill_code,               --edit
        1 bckback_seq,
        bck_units bckback_unit,                     --edit
        4 bckback_group,                    --edit
        trunc(sysdate) bckorder_date,       --edit
        0 bckbackorder_status,
        '0' bckfree_status,
        'MANUAL' bckback_type,
        'MAN11713' bckprog_id,
        SYSDATE bcknewtrans_date,
        'PERAPONG' bckcre_by,               --edit
        SYSDATE  bckcre_date,
        'PERAPONG' bckupd_by,               --edit
        SYSDATE bckupd_date
  --FROM  (select optrep_seq rep_seq, reprep_code rep_code from zt_komkrij_9Da    ) a;         --edit
/*    FROM (  select optrep_seq rep_seq, reprep_code rep_code from perapong.zp_9D t
            where not exists (select 1 from zt_komkrij_9Da b where t.reprep_code = b.reprep_code)) */
    FROM (select pkgms_master.getRepseq_Byrepcode('000',ohdrep_code) rep_seq, ohdrep_code rep_code, odttrans_unit bck_units from zp_tmp
where odttrans_unit <> 0)
    a;
  
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

select b.*, pkgms_master.getRepname_Byseq('000',bckrep_seq) from om_backorder b where bckprog_id = 'MAN11713'

declare
cursor rec is 
    SELECT bckou_code, bckback_ord_campaign, bckrep_seq, bckback_seq, bckrep_code 
    from om_backorder a
    where bckou_code = '000'
      and bckbill_code = '29075'
      and bckbackorder_status = '0';         
  
  nSeq NUMBER;
  vbckback_seq NUMBER;
  
  begin
     for Trc In Rec Loop
     
        Begin
           select  Max(bckback_seq) Seq 
              Into nSeq
             from om_backorder
              where bckou_code           = Trc.bckou_code
               and  bckback_ord_campaign = '242012' --Trc.bckback_ord_campaign
               and  bckrep_seq           = Trc.bckrep_seq;
        End ;
          
        vbckback_seq  := nvl(nSeq,0)+1;
          
        Begin
            update om_backorder set bckback_ord_campaign = '242012', bckbill_campaign = '242012', bckorder_campaign = '242012', bckbill_code = '29080', bckback_seq = vbckback_seq
            where bckou_code = Trc.bckou_code
              and bckback_ord_campaign = Trc.bckback_ord_campaign
              and bckrep_seq = Trc.bckrep_seq
              and bckback_seq = Trc.bckback_seq
              and bckrep_code = Trc.bckrep_code
              and bckbill_code = '29075'
              and bckbackorder_status = '0';
        End;
        
        COMMIT;
     End Loop;
     
  End;

/*
select * from zp_tmp_bluedia a order by rep_code
--where a.rep_code = '0784024821'


/*

--drop table zp_tmp_backorder;
--create table drop table zp_tmp_backorder
select *
from (
    select h.ohdrep_code rep_code, h.ohdrep_seq rep_seq, sum(d.odttrans_bef_discount) price
    from om_transaction_hdr h, om_transaction_dtl d
    where h.ohdou_code = '000'
        and h.ohdou_code = odtou_code
        and h.ohdyear = odtyear
        and h.ohdtrans_group = odttrans_group
        and h.ohdtrans_no = odttrans_no
        and h.ohdord_campaign = '172012'
        and d.odtbill_brand = '2'
        --and h.OHDREP_CODE = '0784024821'
        --and h.ohdtrans_no = '1100452673'
    group by h.ohdrep_code, h.ohdrep_seq
) a
where a.price >= 1500
and not exists (select 1 from db_member_dtl t where t.mmdou_code = '000' and a.rep_seq = t.mmdrep_seq and t.mmdclub_code = 'BLUEC')
*/

/*********************************************************************************************************************************************
Fixed Data Lost

declare
cursor rec is 
SELECT  distinct
        '000' bckou_code,
        '052013' bckback_ord_campaign,      --edit
        '052013' bckbill_campaign,          --edit
        ohdrep_seq bckrep_seq,                 --edit
        ohdrep_code bckrep_code,               --edit
        ohdrep_seq bckupdate_rep_seq,          --edit
        ohdrep_code bckupdate_rep_code,        --edit
        odtbill_code bckbill_code,               --edit
        1 bckback_seq,
        odttrans_unit bckback_unit,                     --edit
        3 bckback_group,                    --edit
        trunc(sysdate) bckorder_date,       --edit
        0 bckbackorder_status,
        '0' bckfree_status,
        ohdyear bcktrans_year, 
        ohdtrans_group bcktrans_group, 
        ohdtrans_no bcktrans_no, 
        'MANUAL' bckback_type,
        'SCRIPT' bckprog_id,
        SYSDATE bcknewtrans_date,
        'PERAPONG' bckcre_by,               --edit
        SYSDATE  bckcre_date,
        'SHORT04' bckupd_by,               --edit
        SYSDATE bckupd_date
  FROM  (select * 
         from om_transaction_hdr h, om_transaction_dtl d
         where h.ohdou_code = d.odtou_code 
            and h.ohdyear = d.odtyear
            and h.ohdtrans_group = d.odttrans_group
            and h.ohdtrans_no = d.odttrans_no
            and ohdou_code = '000'
            and ohdyear = 13
            and ohdtrans_group = 11
        --    and h.ohdtrans_no = '1101243925'
            and h.ohdtrans_date between to_date('01/03/2013','dd/mm/rrrr') and to_date('04/03/2013','dd/mm/rrrr')
        --    and odttrans_message is not null
            and odttrans_reason = '04'
            and not exists (select 1 from om_backorder where bckou_code = '000' and bckback_ord_campaign = '052013' and bckrep_seq = ohdrep_seq and bckbill_code = odtbill_code and bcktrans_no = ohdtrans_no) 
        --    order by odttrans_reason
            ) a;         --edit
  
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
                                      bckcre_date,bckprog_id, bckupd_by,bckupd_date, bcktrans_year, bcktrans_group, bcktrans_no) 
                          values (Trc.bckou_code,Trc.bckback_ord_campaign, Trc.bckrep_seq, Trc.bckback_seq, Trc.bckrep_code, Trc.bckbill_campaign, 
                                  Trc.bckbill_code, Trc.bckback_unit, Trc.bckback_group, Trc.bckorder_date,
                                  Trc.bckbackorder_status, Trc.bckupdate_rep_seq, Trc.bckupdate_rep_code, 
                                  Trc.bckfree_status, Trc.bckback_type, Trc.bcknewtrans_date,
                                  Trc.bckcre_by, Trc.bckcre_date,Trc.bckprog_id, Trc.bckupd_by,Trc.bckupd_date, Trc.bcktrans_year, Trc.bcktrans_group, Trc.bcktrans_no);
                        
        
        End;
     End Loop;
     
  End;
  
  
select * from om_backorder where bckupd_by = 'SHORT04'
update om_backorder set bckorder_campaign = (select ohdtrans_campaign from om_transaction_hdr where ohdyear = 13 and ohdtrans_no = bcktrans_no) where bckupd_by = 'SHORT04' and bckorder_campaign is null
update om_backorder set bckorder_date = (select ohdtrans_date from om_transaction_hdr where ohdyear = 13 and ohdtrans_no = bcktrans_no) where bckupd_by = 'SHORT04' 

**********************************************************************************************************
*/










--select * from om_backorder where bckrep_code = '0158093670'



