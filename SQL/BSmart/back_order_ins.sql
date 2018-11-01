begin zp_pkg_test.ins_batch_backorder('000','0113100002','PIMOLPHAN'); commit; end;

declare
    vBatchNo VARCHAR2 := '0113100002';
    vUserId  VARCHAR2 := 'PIMOLPHAN';
    
    Cursor rec is
        SELECT  hx.ou_code bckou_code,
                hx.EFF_CAMP bckback_ord_campaign,
                dx.REP_SEQ  bckrep_seq,
                0   bckback_seq,
                dx.rep_code bckrep_code,
                dx.bill_camp bckbill_campaign,
                dx.bill_code bckbill_code,
                dx.bck_units  bckback_unit,
                hx.bck_group bckback_group,
                sysdate   bckorder_date,
                '0' bckbackorder_status,
                dx.rep_seq  bckupdate_rep_seq,
                dx.rep_code bckupdate_rep_code,
                '0' bckfree_status,
                'MANUAL'  bckback_type,
                null bcktrans_year,
                null bcktrans_group,
                null bcktrans_no,
                'PIMOLPHAN' bckcre_by,
                sysdate  bckcre_date,
                'SC'||hx.DOC_NO  bckprog_id,
                'PIMOLPHAN' bckupd_by,
                sysdate  bckupd_date
          FROM bw_backorder_hdr hx,bw_backorder_dtl dx
          where hx.OU_CODE = dx.OU_CODE
          and hx.DOC_TYPE  = dx.DOC_TYPE
          and hx.DOC_NO    = dx.DOC_NO
          and hx.ou_code   = '000'
          and hx.doc_type  = '01'
          and hx.doc_no    = '0113100002' ;

    nSeq  number;
    nCnt  number;
Begin
  For Trx In rec Loop
        Begin
           select nvl( max(bckback_seq),0) LastSeq
              Into nSeq
            from om_backorder
            where bckou_code = Trx.bckou_code
              and  bckback_ord_campaign = Trx.bckback_ord_campaign
              and  bckrep_seq = Trx.bckrep_seq;
        End;

        Trx.bckback_seq := nvl(nSeq,0)+1;
      Begin
        insert into  om_backorder (bckou_code,bckback_ord_campaign, bckrep_seq,bckback_seq,
                        bckrep_code, bckbill_campaign, bckbill_code,bckback_unit,bckback_group,bckorder_date,bckbackorder_status,bckupdate_rep_seq,
                        bckupdate_rep_code,bckfree_status,bckback_type,
                        bcktrans_year,bcktrans_group,bcktrans_no,
                        bckcre_by,bckcre_date,bckprog_id,bckupd_by, bckupd_date )
               Values  (Trx.bckou_code, Trx.bckback_ord_campaign, Trx.bckrep_seq, Trx.bckback_seq,
                        Trx.bckrep_code, Trx.bckbill_campaign, Trx.bckbill_code, Trx.bckback_unit, Trx.bckback_group, Trx.bckorder_date,Trx.bckbackorder_status,
                        Trx.bckupdate_rep_seq,Trx.bckupdate_rep_code,Trx.bckfree_status,Trx.bckback_type, 
                        Trx.bcktrans_year, Trx.bcktrans_group, Trx.bcktrans_no, 
                        Trx.bckcre_by, Trx.bckcre_date, Trx.bckprog_id, Trx.bckupd_by, Trx.bckupd_date ) ;
        Exception When dup_val_on_index Then dbms_output.put_line('Dupplicate : '||Trx.bckrep_seq||' '||Trx.bckback_seq) ;
      End;
  End Loop;
  commit();
End;
