Select district, reprep_code, nvl(sum(ar_receipt_amt), 0) - nvl(sum(ar_reverse_amt), 0) ar_receipt,
                       nvl(sum(bpr_receipt_amt), 0) - nvl(sum(bpr_reverse_amt), 0) bpr_receipt,
                       nvl(sum(bd_collect_amt), 0) - nvl(sum(bd_reverse_amt), 0) bd_collect,
                       nvl(sum(jmt_collect_amt), 0) - nvl(sum(jmt_reverse_amt), 0) jmt_collect,
                       nvl(sum(bdvat_collect_amt), 0) - nvl(sum(bdvat_reverse_amt), 0) bdvat_collect,
                       nvl(sum(jmtvat_collect_amt), 0) - nvl(sum(jmtvat_reverse_amt), 0) jmtvat_collect
from (
        select  /*+parallel (rch, 8)*/aahou_code ou_code, aahdistrict_code district, reprep_code, trunc(aahapply_date) trans_date,
                                   round(sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt), 0)), 2) ar_receipt_amt,
                                   nvl(round(sum((case when aahbd_tran_flag = '1' and rci.rchcre_by = 'BPR-REDEEM' then nvl(aadapply_amt, 0) - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                            when aahbd_tran_flag = '2' then  0
                                        end)), 2),0) bpr_receipt_amt,
                                    0 ar_reverse_amt,
                                    0 bpr_reverse_amt,
                                    -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
                                    sum((case when aahbd_tran_flag = '2' then (case when tshcollector is null then aadapply_amt
                                                                       else decode(pkgdayend_dailysales.chk_outsource_collector(tshcollector), 1, aadapply_amt, 0) end)
                                    else 0 end))   bd_collect_amt,
                                    -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
                                    nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is not null and
                                                                    nvl(pkgdayend_dailysales.chk_outsource_collector(tshcollector), 0) = 0) -- collect by jmt
                                                     then nvl(aadapply_amt, 0)
                                                    end),0) jmt_collect_amt,
                                     0 bd_reverse_amt,
                                     0 jmt_reverse_amt,
                                     nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is null or                       -- collect by dsm
                                                                    pkgdayend_dailysales.chk_outsource_collector(tshcollector) = 1) -- collect by company lawyer
                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                    end), 0) bdvat_collect_amt,
                                    nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is not null and
                                                                    nvl(pkgdayend_dailysales.chk_outsource_collector(tshcollector), 0) = 0) -- collect by jmt
                                                     then decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt)
                                                    end), 0) jmtvat_collect_amt,
                                    0 bdvat_reverse_amt,
                                    0 jmtvat_reverse_amt
                          from ar_apply_dtl, ar_apply_hdr, su_param_dtl,
                                  ar_transactions_hdr,
                                  ms_representative,
                                   (
                                     select rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                              sum(rcipayment_amt) rcipayment_amt, sum(rcireceipt_vat) rcireceipt_vat
                                       from ar_receipt_invoices_dtl, ar_receipts_hdr, su_param_dtl, ar_apply_hdr
                                       where aahou_code       = '000'
                                           and aahdistrict_code = '1526'
                                           and aahapply_date >= trunc(to_date('24/01/2013','dd/mm/rrrr'))
                                           and aahapply_date <= trunc(to_date('06/02/2013','dd/mm/rrrr')) + 0.99999
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
                                           group by rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by
                                           ) rci
                     where aahou_code = '000'
                         and aahdistrict_code = '1526'
                         and aahapply_date >= trunc(to_date('24/01/2013','dd/mm/rrrr'))
                         and aahapply_date <= trunc(to_date('06/02/2013','dd/mm/rrrr')) + 0.99999
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
                         and reprep_type   not in ('99', '09')
                         and repou_code    = aahou_code
                         and reprep_seq     = aahupd_rep_seq
                     group by aahou_code, aahdistrict_code, reprep_code, trunc(aahapply_date)
                     --aahupd_rep_code, aahapply_no
                      union all
                      select  rcv.ou_code, district, reprep_code, trans_date, ar_receipt_amt, bpr_receipt_amt, ar_reverse_amt,
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
                                                                     else decode(pkgdayend_dailysales.chk_outsource_collector(tshcollector), 1, aadapply_amt, 0) end)
                                      else 0 end)) bd_reverse_amt,
                            sum((case when aahbd_tran_flag = 2 then (case when tshcollector is null then aadapply_amt
                                                                     else decode(pkgdayend_dailysales.chk_outsource_collector(tshcollector), 1, 0, 0, aadapply_amt) end)
                                      else 0 end)) jmt_reverse_amt,
                            0 bdvat_collect_amt,
                            0 jmtvat_collect_amt,
                            nvl(  sum( case when aahbd_tran_flag = '2' and ( tshcollector is null or                       -- collect by dsm
                                                                    pkgdayend_dailysales.chk_outsource_collector(tshcollector) = 1) -- collect by company lawyer
                                                     then nvl(rcireceipt_vat, 0)
                                                    end), 0) bdvat_reverse_amt,
                                     nvl(  sum( case when aahbd_tran_flag= '2' and ( tshcollector is not null and
                                                                    nvl(pkgdayend_dailysales.chk_outsource_collector(tshcollector), '0') = '0') -- collect by jmt
                                                     then nvl(rcireceipt_vat, 0)
                                                    end), 0) jmtvat_reverse_amt
                    from   su_param_dtl pad, ar_transactions_hdr hdr, ms_representative,
                               ar_apply_hdr aah, ar_apply_dtl aad,
                           (select aahou_code rvhou_code, aahapply_type rvhreverse_type, aahapply_no rvhreverse_no,
                                        rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                        sum(rcipayment_amt) rcipayment_amt,
                                        sum(rcireceipt_vat) rcireceipt_vat
                            from ar_receipt_invoices_dtl, ar_apply_hdr, su_param_dtl, ar_receipts_hdr--, ar_reverse_hdr
                            where aahou_code     = '000'
                            and aahdistrict_code = '1526'
                            and aahapply_date >= trunc(to_date('24/01/2013','dd/mm/rrrr'))
                            and aahapply_date <= trunc(to_date('06/02/2013','dd/mm/rrrr')) + 0.99999
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
                    and aahdistrict_code = '1526'
                    and aahapply_date >= trunc(to_date('24/01/2013','dd/mm/rrrr'))
                    and aahapply_date <= trunc(to_date('06/02/2013','dd/mm/rrrr')) + 0.99999
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
                    and tshou_code = rci.rvhou_code
                    and tshyear        = rci.rciyear
                    and tshtrans_type = rci.rcitrans_type
                    and tshtrans_no   = rci.rciinvoice_no
                    and tshperiod       = rci.rciperiod
                    and reprep_type not in ('99', '09')
                    and repou_code  = aahou_code
                    and reprep_seq   = aahupd_rep_seq
                    group by aahou_code, aahdistrict_code, reprep_code, trunc(aahapply_date), aahref_type, aahref_no
                    ) rcv,
                                      ( select dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq,
                                                sum(dclreceipt_before_vat) dclreceipt_before_vat,
                                                sum(dclreceipt_vat)  dclreceipt_vat,
                                                sum(dclreceipt_amt) dclreceipt_amt,
                                                sum(dclnon_vat) dclnon_vat
                                        from ar_bd_collect dcl
                                      where dclou_code   =  '000'
                                      group by dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq) bdc
                    where rcv.ou_code              = bdc.dclou_code(+)
                       and  rcv.aahref_type        = bdc.dclreceipt_type(+)
                       and  rcv.aahref_no          = bdc.dclreceipt_no(+)
                      )
                group by district, reprep_code;
