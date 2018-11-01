begin
    pkgbw_dsmsmart.geta400repcode ;
end;

declare
 cursor rec is
select rx.reg_no, loc_code, first_name , last_name,  cx.err_code
from bw_rirep rx , bw_richk_profile cx
where trunc(send_date) >= to_date('01/07/2012','dd/mm/rrrr') 
 and rx.reg_no = cx.reg_no
 and SUBSTR(nvl(rx.rep_code,'XX'),1,2) IN ('AS','XX')
 and cx.err_code  in ('0803','0101') ;
 vTmp  VARCHAR2(10);
begin
 
 
  For Trec In Rec Loop
    Begin 
     dbms_output.put_line(Trec.loc_code||' '||Trec.first_name||' '||Trec.last_name);
    vTmp := pkgbw_iaverify.gen_errdupname( Trec.reg_no , Trec.err_code); 
  
    Exception  when Others Then Begin   dbms_output.put_line('error '||Trec.reg_no||' '||Trec.first_name||' '||Trec.last_name);  End;
    End;
  End Loop;

  commit;
End;
 
---
---
---
DECLARE
  cursor rec2 is
    select rx.* ,
           Case When rx.fource_status='088X' Then '0880'
                When instr(rx.Last_name,'*')>0 Then '088M' 
                Else fource_status End fource_code
            
  FROM bev$_iachk_errship rx  
   WHERE RX.rec_status IN ('CS-APPROVED','DP_FINISHED') 
      and NVL(RX.rep_code,'XX') IN ('XX','AS400-REJ');
      
    begin
      for cx in Rec2 loop
         begin
            update bw_rirep
              set rep_Code ='AUTO', fource_status = cx.fource_code
            where reg_no = cx.reg_no ;
         end;
      End loop;
       commit;
    end;
---
---
---  
declare
  cursor rec3 is
  select distinct rx.reg_no, rx.loc_code, rx.rep_code,rx.msl_name ,
       Case When rx.fource_status='088X' Then '0880'
            When instr(rx.msl_name,'*')>0 Then '088M' 
            Else fource_status End fource_code
            
   FROM bev$_iachk_cserr rx  
   WHERE RX.print_status IN ('CS-APPROVED','DP_FINISHED') 
       and NVL(RX.rep_code,'XX') IN ('XX','AS400-REJ');
       
    begin
      for cx in Rec3 loop
         begin
            update bw_rirep
              set rep_Code ='AUTO', fource_status = cx.fource_code
            where reg_no = cx.reg_no ;
         end;
      End loop;
       commit;
    end;

