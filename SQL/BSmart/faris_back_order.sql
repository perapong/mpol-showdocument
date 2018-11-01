/*OM_ORDER_HOLD_LOG_DTL.BHOOU_CODE=OM_ORDER_QRY.BIHOU_CODE AND
OM_ORDER_HOLD_LOG_DTL.BHOSALES_CAMPAIGN=OM_ORDER_QRY.BIHSALES_CAMPAIGN AND
OM_ORDER_HOLD_LOG_DTL.BHOREP_SEQ=OM_ORDER_QRY.BIHREP_SEQ AND
OM_ORDER_HOLD_LOG_DTL.BHOBILL_SEQ=OM_ORDER_QRY.BIHBILL_SEQ

*/

-- 1 --
--------------------------------------------------------------------------------------------------------------------------------------

-- 2 --  ?????????????????????????????????????
--create table perapong.zp_tmp_tran_01 as    --edit
select ohdou_code, ohdyear, ohdtrans_group, ohdtrans_no, ohdtrans_type, ohdtrans_date, ohdtrans_campaign, ohdord_campaign
     , ohdloc_code, ohdrep_seq, ohdrep_code, ohdrep_name, ohdrep_telno, 0 unit, 0 price 
from om_transaction_hdr h
where h.ohdou_code = '000' 
    and h.ohdyear = 14
    and h.ohdtrans_group in (11,12)
    and trunc(h.ohdtrans_date) between to_date('01/01/2014','dd/mm/rrrr') and to_date('15/01/2014','dd/mm/rrrr')    -- edit
    and h.ohdtrans_campaign = '012014'                                                                              -- edit
    and h.ohdloc_code not in ('049','0904','0970','0999','9994','9996','9997','9998','9999')  --(select dist_code from bev$_skipdist)
    and h.ohdrep_code not like '8%'
    and h.ohdcancel_date is null
    
--select count(*) from perapong.zp_tmp_tran_10
--------------------------------------------------------------------------------------------------------------------------------------

-- 3 --  ??????????????????? Faris ???????????????
--delete from  perapong.zp_tmp_tran_df
--insert into  perapong.zp_tmp_tran_df
select ohdrep_seq, ohdrep_code, ohdrep_name
     , ohdtrans_campaign, ohdord_campaign
from perapong.zp_tmp_tran_01 h, bwprod.om_transaction_dtl d         --edit
where h.ohdou_code = d.odtou_code 
      and h.ohdyear = d.odtyear
      and h.ohdtrans_group = d.odttrans_group
      and h.ohdtrans_no = d.odttrans_no
      and d.odtbill_brand = 3
      and d.odttrans_bef_discount > 0


--------------------------------------------------------------------------------------------------------------------------------------

-- 4 --  ?????????????????????????????? Faris ?????????????
--delete from  perapong.zp_tmp_backorder_free
--insert into  perapong.zp_tmp_backorder_free
select --' ' ohdtrans_no, null ohdtrans_date,
ohdrep_seq, ohdrep_code, ohdrep_name
from perapong.zp_tmp_tran_df a 
where ohdtrans_campaign = '012014'
and not exists (select 1 from bwprod.om_transaction_hdr h, bwprod.om_transaction_dtl d
                where h.ohdou_code = d.odtou_code 
                     and h.ohdyear = d.odtyear
                     and h.ohdtrans_group = d.odttrans_group
                     and h.ohdtrans_no = d.odttrans_no
                     and trunc(h.ohdtrans_date) between to_date('15/01/2014','dd/mm/rrrr') and sysdate
                     and d.odtbill_brand = 3
                     and d.odttrans_bef_discount > 0
                     and h.ohdrep_seq = a.ohdrep_seq
                )
--------------------------------------------------------------------------------------------------------------------------------------
                
select count(*) from perapong.zp_tmp_backorder_free
--------------------------------------------------------------------------------------------------------------------------------------

-- 5 --  ???????????????? Back Order
declare
cursor rec is 
SELECT  distinct
        '000' bckou_code,
        '042014' bckback_ord_campaign,      --edit
        '042014' bckbill_campaign,          --edit
        ohdrep_seq bckrep_seq,              
        ohdrep_code bckrep_code,
        ohdrep_seq bckupdate_rep_seq,       
        ohdrep_code bckupdate_rep_code,     
        '00362' bckbill_code,               --edit
        1 bckback_seq,                      
        1 bckback_unit,                     --edit
        4 bckback_group,                    --edit
        sysdate bckorder_date,
        0 bckbackorder_status,
        '0' bckfree_status,
        'SCRIPT' bckprog_id,
        'MANUAL' bckback_type,
        SYSDATE bcknewtrans_date,
        'DP0001' bckcre_by,
        SYSDATE  bckcre_date,
        'DP0001' bckupd_by,
        SYSDATE bckupd_date
  FROM  (select distinct ohdrep_seq, ohdrep_code from perapong.zp_tmp_backorder_free) a;
  
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
     commit;
  End;
------------------------------------------------------------------------------------------------------------------------------------------------

select count(*) from (select distinct ohdrep_seq, ohdrep_code from perapong.zp_tmp_backorder_free)
select count(*) from perapong.zp_tmp_backorder_free
select count(*) from om_backorder where bckou_code = '000' and bckback_ord_campaign = '042014' and bckbill_code = '00362'
