declare 
cursor rec is
    select reprep_seq from zp_tmp_back 
    where status = 'Y'
      and rownum < 2000;

BEGIN
    For Trec In Rec Loop
        Begin
            update om_Transaction_Pnt set optremark = 'คะแนนพิเศษสำหรับปลอบใจกรณีสินค้า Short'
            where optou_code = '000'
              and optpoint_campaign = '182012'
              and optbrand_code = '2'
              and optrep_seq = Trec.reprep_seq
              and optcre_by = 'PERAPONG'
              and optupd_by = 'PERAPONG'
              and optprog_id = 'SCRIPT'
              ;
        End;
        
        Begin
            update zp_tmp_back set status = '2' where reprep_seq = Trec.reprep_seq and status = 'Y';
        End;
        
        COMMIT;
    End Loop;
END;

/*
--    select count(*) from zp_tmp_back where status = 'Y'

select * from om_Transaction_Pnt 
            where optou_code = '000'
              and optremark like 'ค%'
              and optpoint_campaign = '182012'
              and optbrand_code = '2'
              and optrep_seq in (select reprep_seq from zp_tmp_back)
              and optcre_by = 'PERAPONG'
              and optupd_by = 'PERAPONG'
              and optprog_id = 'SCRIPT'
*/
