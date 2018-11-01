declare
    pi_ou_code            ar_apply_hdr.aahou_code%type;
    pi_loc_code           ar_apply_hdr.aahdistrict_code%type;
    pi_campaign           db_campaign.cpgcampaign_code%type;
    pi_start_date         ar_apply_hdr.aahapply_date%type;
    pi_endship_date       ar_apply_hdr.aahapply_date%type;
    pi_brand              ar_apply_dtl.aadbrand_code%type;
    pi_user_id            sa_daily_byloc_hdr.sddcre_by%type;
    pi_prog_id            sa_daily_byloc_hdr.sddprog_id%type;
    pi_jobno              su_jobs_regis.jbrjob_no%type;
    pi_type               varchar2(2);
    po_ar_receipt         sa_daily_byloc_hdr.sddar_receipt%type;
    po_bpr_receipt        sa_daily_byloc_hdr.sddar_receipt%type;
    po_ar_adjust          sa_daily_byloc_hdr.sddar_adjust%type;
    po_bpr_adjust         sa_daily_byloc_hdr.sddar_adjust%type;
    po_ar_advance         sa_daily_byloc_hdr.sddar_advance%type;
    po_bpr_advance        sa_daily_byloc_hdr.sddar_advance%type;
    po_bd_collect         sa_daily_byloc_hdr.sddbd_collect%type;
    po_jmt_collect        sa_daily_byloc_hdr.sddjmt_collect%type;
    po_bd_vat_collect     sa_daily_byloc_hdr.sddbd_collect_vat%type;
    po_jmt_vat_collect    sa_daily_byloc_hdr.sddjmt_collect_vat%type;
    po_bd_adjust          sa_daily_byloc_hdr.sddbd_adjust%type;
    po_bd_return          sa_daily_byloc_hdr.sddbd_return_sale%type;
begin
    pi_ou_code         :=   '000';
    pi_loc_code        :=   '0606';
    pi_campaign        :=   '222013';
    pi_start_date      :=   to_date('12/10/2013','dd/mm/rrrr');
    pi_endship_date    :=   to_date('25/10/2013','dd/mm/rrrr');
    pi_brand           :=   1;
    pi_user_id         :=   'PERAPONG';
    pi_prog_id         :=   'SCRIPT';
    pi_jobno           :=   '';
    pi_type            :=   'N';
    
    begin delete from perapong.sa_daily_byloc_hdr; end;
    
    begin
        pkgdayend_dailySales.get_ar_receipt ( pi_ou_code,--pi_ou_code,
                                              pi_loc_code,--d.district,
                                              pi_campaign,--d.distc_campaign,
                                              pi_start_date,--st_date_camp,
                                              pi_endship_date,--v_endship_date, --pi_endship_date,
                                              '%',
                                              pi_user_id, 
                                              pi_prog_id, 
                                              pi_jobno, 
                                              'N',
                                              po_ar_receipt,
                                              po_bpr_receipt,
                                              po_ar_adjust,
                                              po_bpr_adjust,
                                              po_ar_advance,
                                              po_bpr_advance,
                                              po_bd_collect,
                                              po_jmt_collect,
                                              po_bd_vat_collect,
                                              po_jmt_vat_collect,
                                              po_bd_adjust,
                                              po_bd_return);
                                              
    
    end;  
    
    begin
        insert into perapong.sa_daily_byloc_hdr (sddou_code, sddcampaign, sddloc_code, 
                                        sddar_receipt, sddbpr_receipt, sddar_adjust, 
                                        sddar_advance, sddbd_collect, sddjmt_collect,
                                        sddbd_collect_vat, sddjmt_collect_vat, sddbd_adjust, sddbd_return_sale)
        values (  pi_ou_code,
                  pi_campaign,
                  pi_loc_code,
                  
                  po_ar_receipt,
                  po_bpr_receipt,
                  po_ar_adjust,
                  
                  --po_bpr_adjust,
                  po_ar_advance,
                  --po_bpr_advance,
                  po_bd_collect,
                  po_jmt_collect,
                  
                  po_bd_vat_collect,
                  po_jmt_vat_collect,
                  po_bd_adjust,
                  po_bd_return);
    end;                                        
end;


--create table perapong.sa_daily_byloc_hdr as select * from sa_daily_byloc_hdr where rownum < 1

--select * from bev$_mailplan where loc_code = '0606' and mplcampaign = '222013'

--select * from perapong.sa_daily_byloc_hdr

select * from sa_daily_byloc_hdr where sddou_code = '000' and sddcampaign = '222013' and sddloc_code = '0606' 

select sddbd_collect + sddjmt_collect - sddbd_adjust from perapong.sa_daily_byloc_hdr



----   find BD ADJUST   ------------------------------------------------------------------------------------------------------------------------------------
----   find BD ADJUST   ------------------------------------------------------------------------------------------------------------------------------------

select * /* sum(decode(tshtrans_type,  pad1.padcha3,  nvl(tshdue_amt, 0) , pad1.padcha1, -1*nvl(tshdue_amt,0)
                                                          ,  pad3.padcha3,  nvl(tshdue_amt, 0)
                                                          ,  -1* nvl(tshdue_amt, 0)  )) amt*/
                   from ar_transactions_hdr tsh, su_param_dtl pad1, su_param_dtl pad2, su_param_dtl pad3, db_mailplan_sales mps
                  where tshou_code        = '000'
                    and tshdistrict_code  = '0606'
                    and not exists (    select 'X'
                                                from db_sales_location
                                              where dstou_code  =  '000'
                                                  and dstloc_code =  tshdistrict_code
                                                  and nvl(dstspecial_status, '0') = '1')
                    and tshbd_tran_flag = '2' -- only bad debt ---
                    and tshar_type        = '2' -- only mistine --
                    and tshdoc_status <> '9'
                    and 1 = (case tshtrans_type when pad2.padcha1 then (case when tshar_status <> 'BD' then 1 else 0 end)
                                  else 1 end)
                    and tshtrans_type in (pad1.padcha1, pad1.padcha3, pad2.padcha1,
                                                    pad3.padcha1, pad3.padcha2, pad3.padcha3, pad3.padcha4)
                    and pad1.padparam_id   = 499
                    and pad1.padentry_code = '2' --- Transfer from BD
                    and pad2.padparam_id   = 499
                    and pad2.padentry_code = '25' -- Adjust Mistine
                    and pad3.padparam_id   = 499
                    and pad3.padentry_code = '60' --- Delete Mistine
                    and mps.mpscampaign   =  '222013'
                    and mps.mpsloc_code    =   tshdistrict_code
                    and mps.mpsou_code     =   tshou_code
                    and trunc(tshdoc_date)   > trunc(mps.mpsprevship)
                    and trunc(tshdoc_date)  < trunc(mps.mpsshipdate)
                    
                    
----   find BD COLLECTION  & JMT COLLECTION   --------------------------------------------------------------------------------------------------------------
----   find BD COLLECTION  & JMT COLLECTION   --------------------------------------------------------------------------------------------------------------
                    
select ou_code, district, camp, reprep_code, trans_date,
                    sum(ar_receipt_amt) ar_receipt_amt,    sum(bpr_receipt_amt) bpr_receipt_amt,
                    sum(ar_reverse_amt) ar_reverse_amt,  sum(bpr_reverse_amt) bpr_reverse_amt,
                    sum(bd_collect_amt) bd_collect_amt,     sum(jmt_collect_amt) jmt_collect_amt,
                    sum(bd_reverse_amt) bd_reverse_amt, sum(jmt_reverse_amt) jmt_reverse_amt,
                    sum(bdvat_collect_amt) bdvat_collect_amt,     sum(jmtvat_collect_amt) jmtvat_collect_amt,
                    sum(bdvat_reverse_amt) bdvat_reverse_amt,  sum(jmtvat_reverse_amt) jmtvat_reverse_amt,
                    sum(rein_amt) rein_bd
           from (
                           select ou_code, district, '222013' camp, reprep_code, trunc(trans_date) trans_date,
                                    sum(ar_receipt_amt) ar_receipt_amt,         sum(bpr_receipt_amt)  bpr_receipt_amt,
                                    sum(ar_reverse_amt) ar_reverse_amt,       sum(bpr_reverse_amt) bpr_reverse_amt,
                                    sum(bd_collect_amt) bd_collect_amt,          sum(jmt_collect_amt) jmt_collect_amt,
                                    sum(bd_reverse_amt) bd_reverse_amt,      sum(jmt_reverse_amt) jmt_reverse_amt,
                                    sum(bdvat_collect_amt) bdvat_collect_amt,    sum(jmtvat_collect_amt) jmtvat_collect_amt,
                                    sum(bdvat_reverse_amt) bdvat_reverse_amt, sum(jmtvat_reverse_amt) jmtvat_reverse_amt,
                                    null rein_amt
                           from  (
                                                   select  /*+parallel (rch, 8)*/aahou_code ou_code, aahdistrict_code district, reprep_code, trunc(aahapply_date) trans_date,
                                                   round(sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt), 0)), 2) ar_receipt_amt,
                                                   nvl(round(sum((case when aahbd_tran_flag = '1' and rci.rchcre_by = 'BPR-REDEEM' then nvl(aadapply_amt, 0) - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                            when aahbd_tran_flag = '2' then  0
                                                        end)), 2),0) bpr_receipt_amt,
                                                    0 ar_reverse_amt,
                                                    0 bpr_reverse_amt,
                                                    -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
                                                    sum((case when aahbd_tran_flag = '2' then (case when tshcollector is null then aadapply_amt
                                                                                       else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, aadapply_amt, 0) end)
                                                    else 0 end))   bd_collect_amt,
                                                    -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
                                                    nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is not null and
                                                                                    nvl(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 0) = 0) -- collect by jmt
                                                                     then nvl(aadapply_amt, 0)
                                                                    end),0) jmt_collect_amt,
                                                     0 bd_reverse_amt,
                                                     0 jmt_reverse_amt,
                                                     nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is null or                       -- collect by dsm
                                                                                    pkgdayend_dailySales.chk_outsource_collector(tshcollector) = 1) -- collect by company lawyer
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) bdvat_collect_amt,
                                                    nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is not null and
                                                                                    nvl(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 0) = 0) -- collect by jmt
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) jmtvat_collect_amt,
                                                    0 bdvat_reverse_amt,
                                                    0 jmtvat_reverse_amt
                                          from ar_apply_dtl, ar_apply_hdr, su_param_dtl,
                                                  ar_transactions_hdr,
                                                  ms_representative,
                                                  db_mailplan_sales mp,
                                                   (
                                                     select rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                                                sum(rcipayment_amt) rcipayment_amt, sum(rcireceipt_vat) rcireceipt_vat
                                                         from ar_receipt_invoices_dtl rci, ar_receipts_hdr, su_param_dtl, ar_apply_hdr, db_mailplan_sales mp
                                                       where aahou_code       = '000'
                                                           and aahdistrict_code = '0606'
                                                           and mp.mpscampaign = '222013'
                                                           and aahapply_date >= trunc(mp.mpsprevship )
                                                           and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                                           and padparam_id   = 405
                                                           and padcha1          = '2'
                                                           and padcha2          = 'RC'
                                                           and padentry_code = rchreceipt_type
                                                           and rchou_code       = rciou_code
                                                           and rchreceipt_type = rcireceipt_type
                                                           and rchreceipt_no   = rcireceipt_no
                                                           and rchou_code     = aahou_code
                                                           and rchreceipt_type = aahapply_type
                                                           and rchreceipt_no    = aahapply_no
                                                           and mp.mpsou_code = aahou_code
                                                           and mp.mpsloc_code = aahdistrict_code
                                                           group by rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by
                                                           ) rci
                                     where aahou_code       = '000'
                                         and aahdistrict_code = '0606'
                                         and mp.mpscampaign = '222013'
                                         and aahapply_date >= trunc(mp.mpsprevship )
                                         and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                         and aahar_type = '2' --mistine only
                                         and aahbd_tran_flag in (1, 2)
                                         and aahapply_type = padentry_code -- receipt
                                         and padparam_id = 405
                                         and padcha2 = 'RC'
                                         and aahou_code = aadou_code
                                         and aahapply_type = aadapply_type
                                         and aahapply_no = aadapply_no
                                         and rci.rciou_code = aadou_code
                                         and rci.rcireceipt_type = aadapply_type
                                         and rci.rcireceipt_no = aadapply_no
                                         and rci.rciyear = aadyear
                                         and rci.rcitrans_type = aadtrans_type
                                         and rci.rciinvoice_no = aadtrans_no
                                         and rci.rciperiod = aadperiod
                                         -- check refer. invoice --
                                         and tshou_code = rci.rciou_code
                                         and tshyear = rci.rciyear
                                         and tshtrans_type = rci.rcitrans_type
                                         and tshtrans_no   = rci.rciinvoice_no
                                         and tshperiod      = rci.rciperiod
                                         and reprep_type   not in ('99', '99') -- v_dummy_bank)
                                         and repou_code    = aahou_code
                                         and reprep_seq     = aahupd_rep_seq
                                         and mp.mpsou_code = aahou_code
                                         and mp.mpsloc_code = aahdistrict_code
                                     group by aahou_code, aahdistrict_code, trunc(aahapply_date), reprep_code
                                     --aahupd_rep_code, aahapply_no
                                      union all
                                      select    rcv.ou_code, district, reprep_code, trans_date, ar_receipt_amt, bpr_receipt_amt, ar_reverse_amt,
                                                  bpr_reverse_amt,  bd_collect_amt, jmt_collect_amt, bd_reverse_amt, jmt_reverse_amt,
                                                  bdvat_collect_amt,  jmtvat_collect_amt, bdvat_reverse_amt,
                                                  jmtvat_reverse_amt
                                      from
                                      (
                                       select /*+parallel (aah, 8)*/aahou_code ou_code, aahdistrict_code district, reprep_code, trunc(aahapply_date) trans_date, aahref_type, aahref_no,
                                            0 ar_receipt_amt,
                                            0 bpr_receipt_amt,
                                            round(sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt), 0)), 2) ar_reverse_amt,
                                            round(sum((case when aahbd_tran_flag = '1' and rci.rchcre_by = 'BPR-REDEEM' then nvl(aadapply_amt, 0) - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                            when aahbd_tran_flag = '2' then  0
                                                       end)), 2) bpr_reverse_amt,
                                            0 bd_collect_amt,
                                            0 jmt_collect_amt,
                                            sum((case when aahbd_tran_flag = 2 then (case when tshcollector is null then aadapply_amt
                                                                                     else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, aadapply_amt, 0) end)
                                                      else 0 end)) bd_reverse_amt,
                                            sum((case when aahbd_tran_flag = 2 then (case when tshcollector is not null then aadapply_amt
                                                                                     else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, 0, 0, aadapply_amt) end)
                                                      else 0 end)) jmt_reverse_amt,
                                            0 bdvat_collect_amt,
                                            0 jmtvat_collect_amt,
                                             nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is null or                       -- collect by dsm
                                                                                    pkgdayend_dailySales.chk_outsource_collector(tshcollector) = 1) -- collect by company lawyer
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) bdvat_reverse_amt,
                                                     nvl(  sum( case when aahbd_tran_flag= '2' and ( tshcollector is not null and
                                                                              nvl(pkgdayend_dailySales.chk_outsource_collector(tshcollector), '0') = '0') -- collect by jmt
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) jmtvat_reverse_amt
                                    from   su_param_dtl pad, ar_transactions_hdr hdr, ms_representative,
                                              ar_apply_hdr aah, ar_apply_dtl aad, db_mailplan_sales mp,
                                           (select aahou_code rvhou_code, aahapply_type rvhreverse_type, aahapply_no rvhreverse_no,
                                                        rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                                        sum(rcipayment_amt) rcipayment_amt,
                                                        sum(rcireceipt_vat) rcireceipt_vat
                                            from ar_receipt_invoices_dtl, ar_apply_hdr, su_param_dtl, ar_receipts_hdr, db_mailplan_sales mp
                                            where aahou_code     = '000'
                                            and aahdistrict_code   = '0606'
                                            and mp.mpscampaign = '222013'
                                            and aahapply_date >= trunc(mp.mpsprevship)
                                            and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                            and padparam_id = 405
                                            and padcha1 = '2'
                                            and padcha2 = 'RC'
                                            and padcha4 = aahapply_type
                                            and rchou_code = aahou_code
                                            and rchreceipt_type = aahref_type
                                            and rchreceipt_no = aahref_no
                                            and rchou_code = rciou_code
                                            and rchreceipt_type = rcireceipt_type
                                            and rchreceipt_no = rcireceipt_no
                                            group by aahou_code, aahapply_type, aahapply_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by) rci
                                    where aahou_code     = '000'
                                    and aahdistrict_code   = '0606'
                                    and mp.mpscampaign = '222013'
                                    and aahapply_date >= trunc(mp.mpsprevship)
                                    and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                    and aahar_type = '2' -- only mistine
                                    and aahbd_tran_flag in ('1', '2')
                                    and padparam_id = 405
                                    and padcha2 = 'RC'
                                    and aahapply_type = padcha4
                                    and aahou_code = aadou_code
                                    and aahapply_type = aadapply_type
                                    and aahapply_no = aadapply_no
                                    and rci.rvhou_code = aadou_code
                                    and rci.rvhreverse_type = aadapply_type
                                    and rci.rvhreverse_no = aadapply_no
                                    and rci.rciyear = aadyear
                                    and rci.rcitrans_type = aadtrans_type
                                    and rci.rciinvoice_no = aadtrans_no
                                    and rci.rciperiod = aadperiod
                                     -- check refer. invoice --
                                    and tshou_code   = rci.rvhou_code
                                    and tshyear         = rci.rciyear
                                    and tshtrans_type = rci.rcitrans_type
                                    and tshtrans_no   = rci.rciinvoice_no
                                    and tshperiod       = rci.rciperiod
                                    and reprep_type not in ('99', '99' )--v_dummy_bank)
                                    and repou_code  = aahou_code
                                    and reprep_seq   = aahupd_rep_seq
                                    and mp.mpsou_code = aahou_code
                                     and mp.mpsloc_code = aahdistrict_code
                                    group by aahou_code, aahdistrict_code , reprep_code, trunc(aahapply_date), aahref_type, aahref_no
                                    ) rcv,
                                                      ( select dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq,
                                                                sum(dclreceipt_before_vat) dclreceipt_before_vat,
                                                                sum(dclreceipt_vat)  dclreceipt_vat,
                                                                sum(dclreceipt_amt) dclreceipt_amt,
                                                                sum(dclnon_vat) dclnon_vat
                                                        from ar_bd_collect dcl
                                                      where dclou_code   =  '000'
                                                      group by dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq) bdc
                                    where rcv.ou_code            = bdc.dclou_code(+)
                                       and  rcv.aahref_type       = bdc.dclreceipt_type(+)
                                       and  rcv.aahref_no         = bdc.dclreceipt_no(+)
                                   )
                         group by ou_code, district, reprep_code, trunc(trans_date)
                         union all
                         ------------ ******** Customer Reinstatement ************ ----------
                         select  tshou_code, tshdistrict_code, '222013' camp,  tshref_rep_code, trunc(tshdoc_date),
                                    null ar_receipt_amt,         null bpr_receipt_amt,
                                    null ar_reverse_amt,        null bpr_reverse_amt,
                                    null bd_collect_amt,         null jmt_collect_amt,
                                    null bd_reverse_amt,       null jmt_reverse_amt,
                                    null bdvat_collect_amt,    null jmtvat_collect_amt,
                                    null bdvat_reverse_amt,  null jmtvat_reverse_amt,
                                   sum(decode(tshtrans_type,  pad1.padcha3,  nvl(tshdue_amt, 0) , pad1.padcha1, -1*nvl(tshdue_amt,0)
                                                                  ,  pad3.padcha3,  nvl(tshdue_amt, 0)
                                                                  ,  -1* nvl(tshdue_amt, 0)  )) rein_amt
                           from ar_transactions_hdr tsh, su_param_dtl pad1, su_param_dtl pad2, su_param_dtl pad3, db_mailplan_sales mps
                         where tshou_code        = '000'
                            and  tshdistrict_code  = '0606'
                            and  not exists (    select 'X'
                                                        from db_sales_location
                                                      where dstou_code  =  '000'
                                                          and dstloc_code =  tshdistrict_code
                                                          and nvl(dstspecial_status, '0') = '1')
                            and tshbd_tran_flag = '2' -- only bad debt ---
                            and tshar_type        = '2' -- only mistine --
                            and tshdoc_status <> '9'
                            and 1 = (case tshtrans_type when pad2.padcha1 then (case when tshar_status <> 'BD' then 1 else 0 end)
                                          else 1 end)
                            and tshtrans_type in (pad1.padcha1, pad1.padcha3, pad2.padcha1,
                                                            pad3.padcha1, pad3.padcha2, pad3.padcha3, pad3.padcha4)
                            and pad1.padparam_id   = 499
                            and pad1.padentry_code = '2' --- Transfer from BD
                            and pad2.padparam_id   = 499
                            and pad2.padentry_code = '25' -- Adjust Mistine
                            and pad3.padparam_id   = 499
                            and pad3.padentry_code = '60' --- Delete Mistine
                            and mps.mpscampaign   =  '222013'
                            and mps.mpsloc_code    =   tshdistrict_code
                            and mps.mpsou_code     =   tshou_code
                            and trunc(tshdoc_date)   > trunc(mps.mpsprevship)
                            and trunc(tshdoc_date)  < trunc(mps.mpsshipdate)
                        group by tshou_code, tshdistrict_code, tshref_rep_code, trunc(tshdoc_date)
                         )
            group by ou_code, district, camp, reprep_code, trans_date;
            
            
----   find BD REVERSE & JMT REVERSE   ---------------------------------------------------------------------------------------------------------------------
----   find BD REVERSE & JMT REVERSE   ---------------------------------------------------------------------------------------------------------------------
                                
select /*+parallel (aah, 8)*/aahou_code ou_code, aahdistrict_code district, reprep_code, trunc(aahapply_date) trans_date, aahref_type, aahref_no,
                                            0 ar_receipt_amt,
                                            0 bpr_receipt_amt,
                                            round(sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt), 0)), 2) ar_reverse_amt,
                                            round(sum((case when aahbd_tran_flag = '1' and rci.rchcre_by = 'BPR-REDEEM' then nvl(aadapply_amt, 0) - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                            when aahbd_tran_flag = '2' then  0
                                                       end)), 2) bpr_reverse_amt,
                                            0 bd_collect_amt,
                                            0 jmt_collect_amt,
                                            sum((case when aahbd_tran_flag = 2 then (case when tshcollector is null then aadapply_amt
                                                                                     else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, aadapply_amt, 0) end)
                                                      else 0 end)) bd_reverse_amt,
                                            sum((case when aahbd_tran_flag = 2 then (case when tshcollector is not null then aadapply_amt
                                                                                     else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, 0, 0, aadapply_amt) end)
                                                      else 0 end)) jmt_reverse_amt,
                                            0 bdvat_collect_amt,
                                            0 jmtvat_collect_amt,
                                             nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is null or                       -- collect by dsm
                                                                                    pkgdayend_dailySales.chk_outsource_collector(tshcollector) = 1) -- collect by company lawyer
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) bdvat_reverse_amt,
                                                     nvl(  sum( case when aahbd_tran_flag= '2' and ( tshcollector is not null and
                                                                              nvl(pkgdayend_dailySales.chk_outsource_collector(tshcollector), '0') = '0') -- collect by jmt
                                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                                    end), 0) jmtvat_reverse_amt
                                    from   su_param_dtl pad, ar_transactions_hdr hdr, ms_representative,
                                              ar_apply_hdr aah, ar_apply_dtl aad, db_mailplan_sales mp,
                                           (select aahou_code rvhou_code, aahapply_type rvhreverse_type, aahapply_no rvhreverse_no,
                                                        rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                                        sum(rcipayment_amt) rcipayment_amt,
                                                        sum(rcireceipt_vat) rcireceipt_vat
                                            from ar_receipt_invoices_dtl, ar_apply_hdr, su_param_dtl, ar_receipts_hdr, db_mailplan_sales mp
                                            where aahou_code     = '000'
                                            and aahdistrict_code   = '0606'
                                            and mp.mpscampaign = '222013'
                                            and aahapply_date >= trunc(mp.mpsprevship)
                                            and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                            and padparam_id = 405
                                            and padcha1 = '2'
                                            and padcha2 = 'RC'
                                            and padcha4 = aahapply_type
                                            and rchou_code = aahou_code
                                            and rchreceipt_type = aahref_type
                                            and rchreceipt_no = aahref_no
                                            and rchou_code = rciou_code
                                            and rchreceipt_type = rcireceipt_type
                                            and rchreceipt_no = rcireceipt_no
                                            group by aahou_code, aahapply_type, aahapply_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by) rci
                                    where aahou_code     = '000'
                                    and aahdistrict_code   = '0606'
                                    and mp.mpscampaign = '222013'
                                    and aahapply_date >= trunc(mp.mpsprevship)
                                    and aahapply_date <= trunc(mp.mpsshipdate) + 0.99999
                                    and aahar_type = '2' -- only mistine
                                    and aahbd_tran_flag in ('1', '2')
                                    and padparam_id = 405
                                    and padcha2 = 'RC'
                                    and aahapply_type = padcha4
                                    and aahou_code = aadou_code
                                    and aahapply_type = aadapply_type
                                    and aahapply_no = aadapply_no
                                    and rci.rvhou_code = aadou_code
                                    and rci.rvhreverse_type = aadapply_type
                                    and rci.rvhreverse_no = aadapply_no
                                    and rci.rciyear = aadyear
                                    and rci.rcitrans_type = aadtrans_type
                                    and rci.rciinvoice_no = aadtrans_no
                                    and rci.rciperiod = aadperiod
                                     -- check refer. invoice --
                                    and tshou_code   = rci.rvhou_code
                                    and tshyear         = rci.rciyear
                                    and tshtrans_type = rci.rcitrans_type
                                    and tshtrans_no   = rci.rciinvoice_no
                                    and tshperiod       = rci.rciperiod
                                    and reprep_type not in ('99', '99' )--v_dummy_bank)
                                    and repou_code  = aahou_code
                                    and reprep_seq   = aahupd_rep_seq
                                    and mp.mpsou_code = aahou_code
                                     and mp.mpsloc_code = aahdistrict_code
                                    group by aahou_code, aahdistrict_code , reprep_code, trunc(aahapply_date), aahref_type, aahref_no







