    procedure get_ar_receipt     ( pi_ou_code            in ar_apply_hdr.aahou_code%type,
                                               pi_loc_code           in ar_apply_hdr.aahdistrict_code%type,
                                               pi_campaign         in  db_campaign.cpgcampaign_code%type,
                                               pi_start_date         in ar_apply_hdr.aahapply_date%type,
                                               pi_endship_date    in ar_apply_hdr.aahapply_date%type,
                                               pi_brand               in ar_apply_dtl.aadbrand_code%type,
                                               pi_user_id            in  sa_daily_byloc_hdr.sddcre_by%type,
                                               pi_prog_id            in  sa_daily_byloc_hdr.sddprog_id%type,
                                               pi_jobno               in su_jobs_regis.jbrjob_no%type,
                                               pi_type                 in varchar2 default 'N', --- N New Receipt with generate Receipt by Rep., U Update without generate Receipt by Rep.
                                               po_ar_receipt         out sa_daily_byloc_hdr.sddar_receipt%type,
                                               po_bpr_receipt       out sa_daily_byloc_hdr.sddar_receipt%type,
                                               po_ar_adjust          out sa_daily_byloc_hdr.sddar_adjust%type,
                                               po_bpr_adjust        out sa_daily_byloc_hdr.sddar_adjust%type,
                                               po_ar_advance       out  sa_daily_byloc_hdr.sddar_advance%type,
                                               po_bpr_advance     out  sa_daily_byloc_hdr.sddar_advance%type,
                                               po_bd_collect        out sa_daily_byloc_hdr.sddbd_collect%type,
                                               po_jmt_collect       out sa_daily_byloc_hdr.sddjmt_collect%type,
                                               po_bd_vat_collect  out sa_daily_byloc_hdr.sddbd_collect_vat%type,
                                               po_jmt_vat_collect out sa_daily_byloc_hdr.sddjmt_collect_vat%type,
                                               po_bd_adjust         out sa_daily_byloc_hdr.sddbd_adjust%type,
                                               po_bd_return         out sa_daily_byloc_hdr.sddbd_return_sale%type ) is

    v_adv_ar          sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_adv_bpr        sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_adv_bd          sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_adv_bd_vat   sa_daily_byloc_hdr.sddar_receipt%type := 0;

    v_aadpb_ar    sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_aadpb_bpr  sa_daily_byloc_hdr.sddar_receipt%type := 0;

    v_aadpb_bd sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_aadpb_bd_vat sa_daily_byloc_hdr.sddar_receipt%type := 0;

    v_adv_brand ar_apply_dtl.aadbrand_code%type := pkgar_master.getpadcha1_param ('11');
    v_rein1           ar_transactions_hdr.tshtrans_type%type;
    v_rein2           ar_transactions_hdr.tshtrans_type%type;

    v_dn_bd        sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_dn_bdvat  sa_daily_byloc_hdr.sddar_receipt%type := 0;

    v_rein_bd        sa_daily_byloc_hdr.sddar_receipt%type := 0;
    v_rein_bdvat   sa_daily_byloc_hdr.sddar_receipt%type := 0;

    po_error_message varchar2(200);

    begin
        -- get fefault rein transaction type
       begin
            select  padcha1, padcha3
               into  v_rein1,   v_rein2
              from  su_param_dtl
             where padparam_id   = 499
                and  padentry_code = '2';
        exception when no_data_found then v_rein1 := '@'; v_rein2 := '$';
        end;

        if pi_brand = '%' then
            If nvl(pi_type, 'N') = 'N' Then
               prepare_ar_receipt (pi_ou_code,
                                             pi_loc_code,
                                             pi_campaign,
                                             pi_user_id,
                                             pi_prog_id,
                                             pi_jobno);
            End If;

            Begin
              select nvl(sum(ar_receipt_amt), 0) - nvl(sum(ar_reverse_amt), 0) ar_receipt,
                       nvl(sum(bpr_receipt_amt), 0) - nvl(sum(bpr_reverse_amt), 0) bpr_receipt,
                       nvl(sum(bd_collect_amt), 0) - nvl(sum(bd_reverse_amt), 0) bd_collect,
                       nvl(sum(jmt_collect_amt), 0) - nvl(sum(jmt_reverse_amt), 0) jmt_collect,
                       nvl(sum(bdvat_collect_amt), 0) - nvl(sum(bdvat_reverse_amt), 0) bdvat_collect,
                       nvl(sum(jmtvat_collect_amt), 0) - nvl(sum(jmtvat_reverse_amt), 0) jmtvat_collect
                  into po_ar_receipt, po_bpr_receipt, po_bd_collect, po_jmt_collect, po_bd_vat_collect, po_jmt_vat_collect
                from  om_trans_paymt
              where ou_code   = pi_ou_code
                  and district     = pi_loc_code
                  and camp       = pi_campaign;
           exception when no_data_found then po_ar_receipt := 0; po_bd_collect := 0; po_jmt_collect := 0; po_bd_vat_collect := 0;
                                      when others then po_ar_receipt := 0; po_bd_collect := 0; po_jmt_collect := 0; po_bd_vat_collect := 0;
                                                                po_error_message    := 'Get Payment : '||substr(sqlerrm, 1, 120);
                                                                pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                                        'ERR',
                                                                                                        po_error_message,
                                                                                                        'Update C7',
                                                                                                        sysdate,
                                                                                                        sysdate,
                                                                                                        to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code,
                                                                                                        pi_jobno,
                                                                                                        pi_user_id,
                                                                                                        pi_prog_id);
           End;

           --- 25/04/2011 Adjust from Data Migration ---
           -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
           begin
                  select nvl(sum(decode(tshbd_tran_flag, '1', nvl(tshdue_amt, 0) /*- nvl(tshvat_amt, 0)*/, 0)), 0) adj_ar,
                           nvl(sum(decode(tshbd_tran_flag, '1', decode(rchcre_by, 'BPR-REDEEM', nvl(tshdue_amt, 0),0), 0)), 0) adj_ar,
                           nvl(sum(decode(tshbd_tran_flag, '2', nvl(tshdue_amt, 0) /*- nvl(tshvat_amt, 0)*/, 0)), 0) adj_bd,
                           nvl(sum(decode(tshbd_tran_flag, '2', nvl(tshvat_amt, 0), 0)), 0) adj_bd_vat
                    into v_aadpb_ar, v_aadpb_bpr, v_aadpb_bd, v_aadpb_bd_vat
                  from ar_transactions_hdr, su_param_dtl, ms_representative, ar_receipts_hdr
                where tshou_code       = pi_ou_code
                    and tshdistrict_code = pi_loc_code
                    and tshdoc_date    >= pi_start_date
                    and tshdoc_date    <= pi_endship_date
                    and tshdoc_status  <> '9'
                    and tshtrans_type    = padcha1
                    and padparam_id     = 499
                    and padentry_code   = '61'
                    and reprep_type not in ('99', v_dummy_bank)
                    and repou_code = tshou_code
                    and reprep_seq = tshupd_rep_seq
                    and tshou_code = rchou_code
                    and tshref_type = rchreceipt_type
                    and tshref_no   = rchreceipt_no;
           exception when no_data_found then  v_aadpb_ar := 0; v_aadpb_bpr := 0; v_aadpb_bd := 0; v_aadpb_bd_vat := 0;
                          when others then   v_aadpb_ar := 0; v_aadpb_bpr := 0; v_aadpb_bd := 0; v_aadpb_bd_vat := 0;
                                                      po_error_message    := 'Get Adjust : '||substr(sqlerrm, 1, 120);
                                                      --dbms_output.put_line(po_error_message);
                                                      pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                            'ERR',
                                                                                            po_error_message,
                                                                                            'Update C7',
                                                                                            sysdate,
                                                                                            sysdate,
                                                                                            to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code,
                                                                                            pi_jobno,
                                                                                            pi_user_id,
                                                                                            pi_prog_id);
           end;

           --- 03/05/2011  .... CN, DN for Bad Debt will be include into BD Receipts (VAT203) ....
           begin
                   select    sum(decode(pad.padparam_id, 396,  ohdttl_amount_aftdisc  * -1  , ohdttl_amount_aftdisc ) )   bdcollect_dnbd,
                               sum(decode(pad.padparam_id, 396,  ohdvat_amount_aftdisc * -1  ,  ohdvat_amount_aftdisc  )) bdvat_dnbd
                      into    v_dn_bd, v_dn_bdvat
                    from    om_transaction_hdr ohd,su_param_dtl pad
                    where  ohd.ohdou_code   =  pi_ou_code
                    and     trunc(ohd.ohdtrans_date) >= trunc(pi_start_date)
                    and     trunc(ohd.ohdtrans_date) <= trunc(pi_endship_date) + 0.99999
                    and     substr(ohd.ohdupd_rep_code, 1, 4) = pi_loc_code
                    and     pad.padflag1            = '0'
                    and     pad.padentry_code   = ohd.ohdtrans_group
                    and     pad.padparam_id     in (396, 397)
                    and     ohd.ohdar_status     = 'BD'
                    and     nvl(ohd.ohdtrans_status, '0') <> '9';
           exception when no_data_found then v_dn_bd := 0; v_dn_bdvat := 0;
                         when others then    v_dn_bd := 0; v_dn_bdvat := 0;
                                                      po_error_message    := 'Get BD Payment : '||substr(sqlerrm, 1, 120);
                                                      --dbms_output.put_line(po_error_message);
                                                      pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                            'ERR',
                                                                                            po_error_message,
                                                                                            'Update C7',
                                                                                            sysdate,
                                                                                            sysdate,
                                                                                            to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code,
                                                                                            pi_jobno,
                                                                                            pi_user_id,
                                                                                            pi_prog_id);
           end;

           ---- get rein transaction ---
           --   02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
           begin
                select   sum(decode(tshtrans_type,  pad1.padcha3,  nvl(tshdue_amt, 0) , pad1.padcha1, -1*nvl(tshdue_amt,0)
                                                          ,  pad3.padcha3,  nvl(tshdue_amt, 0)
                                                          ,  -1* nvl(tshdue_amt, 0)  )) amt
                    into  v_rein_bd--, v_rein_bdvat
                   from ar_transactions_hdr tsh, su_param_dtl pad1, su_param_dtl pad2, su_param_dtl pad3
                 where tshou_code        = pi_ou_code
                    and  tshdistrict_code  = pi_loc_code
                    and  not exists (    select 'X'
                                                from db_sales_location
                                              where dstou_code  = pi_ou_code
                                                  and dstloc_code =  tshdistrict_code
                                                  and nvl(dstspecial_status, '0') = '1')
                    and tshdoc_date      >= trunc(pi_start_date)
                    and tshdoc_date      <= trunc(pi_endship_date) + 0.99999
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
                    and pad3.padentry_code = '60'; --- Delete Mistine
            exception when no_data_found then v_rein_bd := 0; v_rein_bdvat := 0;
                           when others then  v_rein_bd := 0; v_rein_bdvat := 0;
                                                      po_error_message    := 'Get BD Payment : '||substr(sqlerrm, 1, 120);
                                                      --dbms_output.put_line(po_error_message);
                                                      pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                            'ERR',
                                                                                            po_error_message,
                                                                                            'Update C7',
                                                                                            sysdate,
                                                                                            sysdate,
                                                                                            to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code,
                                                                                            pi_jobno,
                                                                                            pi_user_id,
                                                                                            pi_prog_id);
            end;

            po_ar_receipt        := nvl(po_ar_receipt,0);
            po_bpr_receipt      := nvl(po_bpr_receipt,0);
            po_ar_adjust         := nvl(v_aadpb_ar, 0);
            po_bpr_adjust         := nvl(v_aadpb_bpr, 0);
            po_bd_collect        := nvl(po_bd_collect,0) +  nvl(v_aadpb_bd, 0);
            po_bd_vat_collect  := nvl(po_bd_vat_collect,0) +  nvl(v_aadpb_bd_vat, 0);
            po_bd_adjust        := nvl(v_rein_bd, 0);
            po_bd_return        := nvl(v_dn_bd,   0);

        else -- by brand --> avg vat
            begin
                po_bpr_receipt := 0;
                po_bpr_adjust  := 0;
                po_jmt_vat_collect := 0;

                select   nvl(sum(ar_receipt_amt), 0) - nvl(sum(ar_reverse_amt), 0) ar_receipt,
                           nvl(sum(bd_collect_amt), 0) - nvl(sum(bd_reverse_amt), 0) bd_collect,
                           nvl(sum(jmt_collect_amt), 0) - nvl(sum(jmt_reverse_amt), 0) jmt_collect,
                           nvl(sum(bdvat_collect_amt), 0) - nvl(sum(bdvat_reverse_amt), 0) bdvat_collect
                into po_ar_receipt, po_bd_collect, po_jmt_collect, po_bd_vat_collect
                from
                     (
                         select  /*+parallel (rch, 8)*/aahou_code ou_code, aahdistrict_code district, trunc(aahapply_date) trans_date,
                                    round(sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rci.rcipayment_amt, 0), 0, 0,nvl(rci.rcireceipt_vat, 0) / nvl(rci.rcipayment_amt, 0) * aadapply_amt), 0)), 2) ar_receipt_amt,
                                    0 ar_reverse_amt,
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
                                    0 bdvat_reverse_amt
                     from   ar_apply_dtl, ar_apply_hdr, su_param_dtl,
                               ar_transactions_hdr,
                               ms_representative,
                                    (select rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by,
                                              sum(rcipayment_amt) rcipayment_amt, sum(rcireceipt_vat) rcireceipt_vat
                                       from ar_receipt_invoices_dtl, ar_receipts_hdr, su_param_dtl, ar_apply_hdr
                                      where aahou_code    = pi_ou_code
                                       and aahdistrict_code = pi_loc_code
                                       and aahapply_date >= trunc(pi_start_date)
                                       and aahapply_date <= trunc(pi_endship_date) + 0.99999
                                       and padparam_id = 405
                                       and padcha1 = '2'
                                       and padcha2 = 'RC'
                                       and padentry_code = rchreceipt_type
                                       and rchou_code = rciou_code
                                       and rchreceipt_type = rcireceipt_type
                                       and rchreceipt_no = rcireceipt_no
                                       and rchou_code = aahou_code
                                       and rchreceipt_type = aahapply_type
                                       and rchreceipt_no = aahapply_no
                                       group by rciou_code, rcireceipt_type, rcireceipt_no, rciyear, rcitrans_type, rciinvoice_no, rciperiod, rchcre_by) rci
                     where aahou_code       = pi_ou_code
                         and aahdistrict_code = pi_loc_code
                         and aahapply_date >= trunc(pi_start_date)
                         and aahapply_date <= trunc(pi_endship_date) + 0.99999
                         and aahar_type = '2' --mistine only
                         and aahbd_tran_flag in (1, 2)
                         and aadbrand_code  = pi_brand
                         and aahapply_type   = padentry_code -- receipt
                         and padparam_id     = 405
                         and padcha2            = 'RC'
                         and aahou_code       = aadou_code
                         and aahapply_type    = aadapply_type
                         and aahapply_no      = aadapply_no
                         and rci.rciou_code    = aadou_code
                         and rci.rcireceipt_type = aadapply_type
                         and rci.rcireceipt_no  = aadapply_no
                         and rci.rciyear           = aadyear
                         and rci.rcitrans_type  = aadtrans_type
                         and rci.rciinvoice_no  = aadtrans_no
                         and rci.rciperiod        = aadperiod
                         -- check refer. invoice --
                         and tshou_code = rci.rciou_code
                         and tshyear = rci.rciyear
                         and tshtrans_type = rci.rcitrans_type
                         and tshtrans_no = rci.rciinvoice_no
                         and tshperiod = rci.rciperiod
                         and reprep_type not in ('99', v_dummy_bank)
                         and repou_code = aahou_code
                         and reprep_seq = aahupd_rep_seq
                      group by aahou_code, aahdistrict_code, trunc(aahapply_date)
                      union all
                      select rcv.ou_code, rcv.district, rcv.trans_date,
                               sum(rcv.ar_recript_amt)   ar_receipt_amt,
                               sum(rcv.ar_reverse_amt) ar_reverse_amt,
                               sum(rcv.bd_collect_amt)   bd_collect_amt,
                               sum(rcv.jmt_collect_amt)  jmt_collect_amt,
                               sum(nvl(rcv.bd_reverse_amt,0) + case when pi_brand = '1' then ( nvl(dclreceipt_before_vat, 0) - nvl(rcv.bd_reverse_amt,0)) else 0 end) bd_reverse_amt,
                               sum(rcv.jmt_reverse_amt) jmt_reverse_amt,
                               sum(rcv.bdvat_collect_amt) bdvat_collect_amt,
                               sum(nvl(rcv.bdvat_reverse_amt,0) + case when pi_brand = '1' then ( nvl(dclreceipt_vat,0) - nvl(rcv.bdvat_reverse_amt,0) ) else 0 end) bdvat_reverse_amt
                      from (
                                    select  /*+parallel (rch, 8)*/rchou_code ou_code, rchdistrict district, trunc(aahapply_date) trans_date,
                                    rchreceipt_type, rchreceipt_no, aahbd_tran_flag,
                                    0 ar_recript_amt,
                                    sum(decode(aahbd_tran_flag, '1', aadapply_amt - decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt), 0)) ar_reverse_amt,
                                     0 bd_collect_amt,
                                     0 jmt_collect_amt,
                                    sum( (case when aahbd_tran_flag = 2 then (case when tshcollector is null then aadapply_amt - decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt)
                                                                               else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, aadapply_amt - decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt), 0) end)
                                              else 0 end)) bd_reverse_amt,
                                    sum((case when aahbd_tran_flag = 2 then (case when tshcollector is null then 0
                                                                               else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 0, aadapply_amt - decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt), 0) end)
                                            else 0 end)) jmt_reverse_amt,
                                     0 bdvat_collect_amt,
                                    sum((case when aahbd_tran_flag = 2 then (case when tshcollector is null then decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt)
                                                                               else decode(pkgdayend_dailySales.chk_outsource_collector(tshcollector), 1, decode(nvl(rcipayment_amt, 0), 0, 0,nvl(rcireceipt_vat, 0) / nvl(rcipayment_amt, 0) * aadapply_amt), 0) end)
                                           else 0 end)) bdvat_reverse_amt
                          from   ar_reverse_hdr rvh, su_param_dtl pad, ar_transactions_hdr hdr, ms_representative,
                                    ar_apply_hdr aah, ar_apply_dtl aad,
                                    ar_receipts_hdr rch, ar_receipt_invoices_dtl rci
                          where rvhou_code       =  pi_ou_code
                             and  rvhdistrict         =  pi_loc_code
                             and  rvhreverse_date  >= trunc(pi_start_date)
                             and  rvhreverse_date  <= trunc(pi_endship_date) + 0.99999
                             and  aahar_type       = '2' -- only mistine
                             and  aahbd_tran_flag in ('1', '2')
                             and  padparam_id    = 405
                             and  padcha2             = 'RC'
                             and  aadbrand_code  (+)= pi_brand
                             and  aahapply_type    = padcha4             -- receipt reverse ---
                              and  aahou_code       = rchou_code
                              and  aahref_type       = rchreceipt_type    -- reverse receipt
                              and  aahref_no         = rchreceipt_no      -- reverse receipt
                              and  rvhou_code        = rchou_code
                              and  rvhreceipt_type  = rchreceipt_type
                              and  rvhreceipt_no     = rchreceipt_no
                              and aahou_code       = aadou_code(+)
                              and aahapply_type    = aadapply_type(+)
                              and aahapply_no       = aadapply_no(+)
                              and rciou_code       (+)= aadou_code
                              and rcireceipt_type (+)= aadapply_type
                              and rcireceipt_no    (+)= aadapply_no
                              and rciitem_seq      (+)= aadinvoice_seq
                              -- check refer. invoice --
                              and  tshou_code     (+)= rciou_code
                              and  tshyear           (+)= rciyear
                              and  tshtrans_type  (+)= rcitrans_type
                              and  tshtrans_no     (+)= rciinvoice_no
                              and  tshperiod        (+)= rciperiod
                              and  reprep_type  not in ('99', v_dummy_bank)
                              and  repou_code        = aahou_code
                              and  reprep_seq        = aahupd_rep_seq
                             group by rchou_code , rchdistrict , trunc(aahapply_date),
                                           rchreceipt_type, rchreceipt_no, aahbd_tran_flag
                             ) rcv,
                                      ( select dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq,
                                                sum(dclreceipt_before_vat) dclreceipt_before_vat,
                                                sum(dclreceipt_vat)  dclreceipt_vat,
                                                sum(dclreceipt_amt) dclreceipt_amt,
                                                sum(dclnon_vat) dclnon_vat
                                        from ar_bd_collect dcl
                                      where dclou_code   =  pi_ou_code
                                      group by dclou_code, dclreceipt_type, dclreceipt_no, dclupd_rep_seq) bdc
                            where rcv.ou_code           = bdc.dclou_code(+)
                               and  rcv.rchreceipt_type = bdc.dclreceipt_type(+)
                               and  rcv.rchreceipt_no    = bdc.dclreceipt_no(+)
                      group by ou_code, district, trans_date
                      );

            Exception when no_data_found then po_ar_receipt := 0; po_bd_collect := 0; po_jmt_collect := 0; po_bd_vat_collect := 0;
                           when others then  po_ar_receipt := 0; po_bd_collect := 0; po_jmt_collect := 0; po_bd_vat_collect := 0;
                                                      po_error_message    := 'Get brand Payment : '||substr(sqlerrm, 1, 120);
                                                      --dbms_output.put_line(po_error_message);
                                                      pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                            'ERR',
                                                                                             po_error_message,
                                                                                            'Update C7',
                                                                                            sysdate,
                                                                                            sysdate,
                                                                                            to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code||':Brand '||pi_brand,
                                                                                            pi_jobno,
                                                                                            pi_user_id,
                                                                                            pi_prog_id);
            end;


            begin
                select nvl(sum(decode(tshbd_tran_flag, '1', nvl(tsddue_amt, 0) - decode(nvl(tshdue_amt, 0), 0, 0,nvl(tshvat_amt, 0) / nvl(tshdue_amt, 0) * tsddue_amt), 0)), 0) adj_ar,
                         nvl(sum(decode(tshbd_tran_flag, '2', nvl(tsddue_amt, 0) - decode(nvl(tshdue_amt, 0), 0, 0,nvl(tshvat_amt, 0) / nvl(tshdue_amt, 0) * tsddue_amt), 0)), 0) adj_bd,
                         nvl(sum(decode(tshbd_tran_flag, '2', decode(nvl(tshdue_amt, 0), 0, 0, nvl(tshvat_amt, 0) / nvl(tshdue_amt, 0) * tsddue_amt), 0)), 0) adj_bd_vat
                    into v_aadpb_ar, v_aadpb_bd, v_aadpb_bd_vat
                  from ar_transactions_hdr, ar_transactions_dtl, su_param_dtl, ms_representative
                 where tshou_code      = pi_ou_code
                    and tshdistrict_code = pi_loc_code
                    and tshdoc_date    >= trunc(pi_start_date)
                    and tshdoc_date    <= trunc(pi_endship_date) + 0.99999
                    and tshou_code = tsdou_code
                    and tshyear = tsdyear
                    and tshtrans_type = tsdtrans_type
                    and tshtrans_no = tsdtrans_no
                    and tshperiod = tsdperiod
                    and tsdbrand_code = pi_brand
                    and tshtrans_type   = padcha1
                    and padparam_id = 499
                    and padentry_code = '61'
                    and reprep_type not in ('99', v_dummy_bank)
                    and repou_code = tshou_code
                    and reprep_seq = tshupd_rep_seq;
            Exception when no_data_found then v_aadpb_ar := 0; v_aadpb_bd := 0; v_aadpb_bd_vat := 0;
                           when others             then v_aadpb_ar := 0; v_aadpb_bd := 0; v_aadpb_bd_vat := 0;
                                                                 po_error_message    := 'Get Adjust : '||substr(sqlerrm, 1, 120);
                                                                 --dbms_output.put_line(po_error_message);
                                                                 pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                                        'ERR',
                                                                                                         po_error_message,
                                                                                                        'Update C7',
                                                                                                        sysdate,
                                                                                                        sysdate,
                                                                                                        to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code||':Brand '||pi_brand,
                                                                                                        pi_jobno,
                                                                                                        pi_user_id,
                                                                                                        pi_prog_id);
            end;

            po_ar_receipt := nvl(po_ar_receipt,0);
            po_bpr_receipt := nvl(po_bpr_receipt,0);
            po_ar_adjust  := nvl(v_aadpb_ar, 0);
            po_bpr_adjust  := nvl(v_aadpb_bpr, 0);
            po_bd_collect := nvl(po_bd_collect,0) + nvl(v_aadpb_bd, 0);
            po_bd_vat_collect := nvl(po_bd_vat_collect,0) + nvl(v_aadpb_bd_vat, 0);

        end if;

        -- find Advance Payment --
        if pi_brand in (v_adv_brand, '%') then
            begin
                 -- 02-05-2012 K. Rames informs change BD from not include VAT --> include VAT (confirm with K.Garunchai)
                 select nvl(sum(decode(tshbd_tran_flag, '1', tshdue_amt, 0)), 0) adv_ar,
                           nvl(sum(decode(tshbd_tran_flag, '1', decode(rchcre_by, 'BPR-REDEEM', nvl(tshdue_amt,0)- nvl(tshvat_amt,0),0), 0)), 0) adv_bpr,
                           nvl(sum(decode(tshbd_tran_flag, '2', tshdue_amt, 0)), 0) adv_bd
                    into v_adv_ar, v_adv_bpr, v_adv_bd
                    from ar_transactions_hdr, su_param_dtl, ms_representative, ar_receipts_hdr
                    where tshou_code       = pi_ou_code
                        and tshdistrict_code = pi_loc_code
                        and tshdoc_date    >= trunc(pi_start_date)
                        and tshdoc_date    <= trunc(pi_endship_date) + 0.99999
                        and tshtrans_type    = padcha1
                        and padparam_id     = 499
                        and padentry_code   = '18'
                        and reprep_type       not in ('99', v_dummy_bank)
                        and repou_code       = tshou_code
                        and reprep_seq       = tshupd_rep_seq
                        and tshou_code       = rchou_code
                        and tshref_type       = rchreceipt_type
                        and tshref_no         = rchreceipt_no
                        and not exists (select 'x'
                                                from ar_apply_hdr, su_param_dtl
                                                where aahou_code = pi_ou_code
                                                and aahdistrict_code = pi_loc_code
                                                and aahapply_date >= trunc(pi_start_date)
                                                and aahapply_date <= trunc(pi_endship_date) + 0.99999
                                                and padparam_id = 405
                                                and padcha1 = '2'
                                                and padcha2 = 'RC'
                                                and padcha4 = aahapply_type
                                                and aahou_code = tshou_code
                                                and aahref_type = tshref_type
                                                and aahref_no = tshref_no);
                exception when no_data_found then v_adv_ar := 0;  v_adv_bpr := 0; v_adv_bd := 0;
                               when others             then v_adv_ar := 0;  v_adv_bpr := 0; v_adv_bd := 0;
                                                                     po_error_message    := 'Get Advance : '||substr(sqlerrm, 1, 120);
                                                                     --dbms_output.put_line(po_error_message);
                                                                     pkgsu_jobs.write_to_log (  pi_jobno,
                                                                                                            'ERR',
                                                                                                             po_error_message,
                                                                                                            'Update C7',
                                                                                                            sysdate,
                                                                                                            sysdate,
                                                                                                            to_char(pi_start_date, 'DDMMYYYY')||':'||to_char(pi_endship_date, 'DDMMYYYY')||':'||pi_loc_code||':Brand '||pi_brand,
                                                                                                            pi_jobno,
                                                                                                            pi_user_id,
                                                                                                            pi_prog_id);
            end;


            --dbms_output.put_line('receipt > '||po_bd_collect||' advance > '||v_adv_bd);
            po_ar_advance       := nvl(v_adv_ar, 0);
            po_bpr_advance     := nvl(v_adv_bpr, 0);
            po_bd_collect         := nvl(po_bd_collect, 0) + nvl(v_adv_bd, 0);
            po_bd_vat_collect   := nvl(po_bd_vat_collect,0) +  nvl(v_adv_bd_vat,0);

        end if;
    end get_ar_receipt;

