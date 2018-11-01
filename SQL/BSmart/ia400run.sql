declare
    cursor rec is
    select rx.reg_no, loc_code, first_name , last_name,  cx.err_code
    from bw_rirep rx , bw_richk_profile cx
    where rx.reg_no = cx.reg_no
      and rx.rep_code is null
      and trunc(send_date) >= sysdate - 5 
--     and trunc(send_date) >= to_date('13/08/2012','dd/mm/rrrr') 
--     and trunc(send_date) between to_date('13/08/2012','dd/mm/rrrr') and to_date('14/08/2012','dd/mm/rrrr') 
--     and SUBSTR(nvl(rx.rep_code,'XX'),1,2) IN ('AS','XX')
     and cx.err_code  in ('0803','0101') 
    ;
 
    vTmp  VARCHAR2(10);
BEGIN
   
    stp_iajob_process;

    For Trec In Rec Loop
        Begin 
            dbms_output.put_line(Trec.loc_code||' '||Trec.first_name||' '||Trec.last_name);
            vTmp := pkgbw_iaverify.gen_errdupname( Trec.reg_no , Trec.err_code); 
          
            Exception  when Others Then Begin   dbms_output.put_line('error '||Trec.reg_no||' '||Trec.first_name||' '||Trec.last_name);  End;
        End;
    End Loop;
  
END;
