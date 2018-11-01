    If to_number(to_char(sysdate,'hh24miss')) between 70000 and 180000 Then --- Start-End process (07:00:00 - 18:00:00)
        begin
            select varnum1 --into vFlag 
            from bw_def$sys where parm_key = 'IA_FLAG_RUN_JOB';
            exception when no_data_found then vFlag := 0;
        end;

        If nvl(vFlag,0) = 0 Then

            begin
                update bw_def$sys set varnum1 = 1, vardate1 = sysdate where parm_key = 'IA_FLAG_RUN_JOB';
                commit;
            end;

           -- begin
           --     stp_iagen_dumy_repcode;
           -- end;
            begin
                update bw_rirep set appt_campaign = pkgdb_desc.getcurrent_campaign where appt_campaign in ('002013','012013');
            end;
            begin
                update bw_rirep set validate_date = upd_date where reg_batchno is not null and validate_date is null and nvl(validate_check,'0') not in ('7','9');
            end;

            begin
                delete from bw_riaddress a
                where addr_type = 1
                and a.line1 is null
                and exists (select 1 from bw_riaddress t
                            where t.addr_type = 1 and t.reg_no = a.reg_no and t.line1 is not null and t.latitude is not null and t.longitude is not null)
                and exists (select 1 from bw_rirep r where r.loc_code is not null and r.reg_no = a.reg_no
                            and substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
                           );
            end;

Declare
cursor rec is
  SELECT rx.loc_code, R1.reg_no , r1.rep_code , print_status
    FROM bev$_iachk_cserr rx , bw_rirep r1
   WHERE RX.print_status IN ('CS-APPROVED','DP_FINISHED')
     and rx.reg_no = r1.reg_no  ;

vTmp  VARCHAR2(10);
vFlag NUMBER;

BEGIN
           for Trec In Rec Loop
                 Begin
                   Update bw_rirep
                     set rep_code ='AUTO'
                   Where reg_no = Trec.reg_no
                   ;
                 end;
            End Loop ;

            commit;
END; -- Procedure


            begin
                pkgbw_iaverify.mainprocedure;
            end;


            begin
                pkgbw_dsm_bsmart.transfertobsmart;
            end;

            begin
                update bw_def$sys set varnum1 = 0, vardate2 = sysdate where parm_key = 'IA_FLAG_RUN_JOB';
                commit;
            end;

