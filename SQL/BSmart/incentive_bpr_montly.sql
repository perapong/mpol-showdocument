insert into sa_point_mntly_ys
spsofmonth
spslastdate
.
.
spscre_date
spsupd_date

select * from sa_point_mntly_ys               where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15' and spslastdate = to_date('31/01/2015','dd/mm/rrrr') 



-------------------------------------------------------------------------------------------------


--update bw_exec_process set proc_date = to_date('31/12/2014','dd/mm/rrrr'), proc_run_date = to_date('31/12/2014 09:00:00','dd/mm/rrrr hh24:mi:ss') where proc_name='Update_Point_Montly' 

select * 
/*to_char(trunc(trunc(sysdate, 'mm') - 1, 'mm'),'dd/mm/rrrr'),
to_char(trunc(sysdate, 'mm') - 1,'dd/mm/rrrr'),
to_char(trunc(sysdate, 'mm') - 1,'mm/rrrr'),
trim(proc_status) */
from bw_exec_process 
where proc_name='Update_Point_Montly' 
and PROC_STATUS = '1'
and proc_date=(SELECT trunc(sysdate, 'mm') - 1 FROM dual); 


select * from sa_criteria_lvl_hdr   where  sclou_code    = '000' and  sclprogref_id = 'BWOMRP73'

Job$_P_RUN_BPR_M 

195 -> 65
insert into sa_point_mntly_ys
select * from sa_point_mntly_ys               where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15' and spslastdate = to_date('31/01/2015','dd/mm/rrrr') 
select * from sa_point_yearly_ys              where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15' and spslastdate = to_date('31/01/2015','dd/mm/rrrr')
select * from sa_point_mntly_ys@toProd purge  where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/103/14' and spslastdate = to_date('30/11/2014','dd/mm/rrrr');
select * from sa_point_yearly_ys@toProd purge where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/103/14' and spslastdate = to_date('30/11/2014','dd/mm/rrrr');




declare     
    enddate     date;     
    nProcSts    number;     
    sErrMsg     varchar2(200); 
begin     
      
/*    bwprod.pkgbw_update_bpr2.Update_Point_Montly('000','30/11/2014','MTD','MONTHEND','BWOMRP73',73,nProcSts,sErrMsg);     */
    bwprod.pkgbw_update_bpr2.Update_Point_Montly('000','31/12/2014','YTD','MONTHEND','BWOMRP73',73,nProcSts,sErrMsg);     

    commit; 
end;
    begin
        delete from sa_point_mntly_ys@toProd purge
        where spslastdate=to_date('31/01/2015','dd/mm/rrrr')
          and spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15';
        insert into sa_point_mntly_ys@toProd
        select * from bwprod.sa_point_mntly_ys
        where spslastdate=to_date('31/01/2015','dd/mm/rrrr')
          and spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/101/15';
        commit;
    end;
    
    begin

        delete from sa_point_yearly_ys@toProd purge
        where spslastdate=to_date('31/12/2014','dd/mm/rrrr')
          and spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/103/14';              
        insert into sa_point_yearly_ys@toProd
        select * from bwprod.sa_point_yearly_ys
        where spslastdate=to_date('31/12/2014','dd/mm/rrrr')
          and spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = '73/103/14';
        commit;
    end;
end;

declare 
    enddate     date;
    nProcSts    number;
    sErrMsg     varchar2(200);    

    begin
/*        begin
            enddate:='';
            SELECT trunc(sysdate, 'mm') - 1
            INTO enddate
            FROM dual;        
           -- dbms_output.put_line(enddate);
            
            update bwprod.bw_exec_process a set proc_status='1'
            where a.proc_name='Update_Point_Montly' and proc_date=enddate and proc_status='0';        
            commit;
            
            bwprod.pkgbw_update_bpr 2.Update_Point_Montly('000',to_char(enddate,'dd/mm/rrrr'),'MTD','MONTHEND','BWOMRP73',73,nProcSts,sErrMsg);
            bwprod.pkgbw_update_bpr 2.Update_Point_Montly('000',to_char(enddate,'dd/mm/rrrr'),'YTD','MONTHEND','BWOMRP73',73,nProcSts,sErrMsg);
            
            update bwprod.bw_exec_process a set proc_status='2'
            where a.proc_name='Update_Point_Montly' and proc_date=enddate and proc_status='1';        
            commit;

        end;
*/
        begin
        /*
            delete from bw_exec_process@toProd purge
            where proc_name='Update_Point_Montly' and proc_date=enddate;            
            insert into bw_exec_process@toProd
            select * from bwprod.bw_exec_process
            where proc_name='Update_Point_Montly' and proc_date=enddate;            
            commit;
*/
                delete from sa_point_mntly_ys@toProd purge
                where spslastdate=to_date('31/12/2014','dd/mm/rrrr');            
                insert into sa_point_mntly_ys@toProd
                select * from bwprod.sa_point_mntly_ys
                where spslastdate=to_date('31/12/2014','dd/mm/rrrr');
                commit;

                    delete from sa_point_yearly_ys@toProd purge
                    where spslastdate=to_date('31/12/2014','dd/mm/rrrr');              
                    insert into sa_point_yearly_ys@toProd
                    select * from bwprod.sa_point_yearly_ys
                    where spslastdate=to_date('31/12/2014','dd/mm/rrrr');
                    commit;
/*
                delete from sa_point_mntly_byrep_ys@toProd purge;            
                insert into sa_point_mntly_byrep_ys@toProd
                select * from bwprod.sa_point_mntly_byrep_ys;
                commit;

                    delete from sa_point_mntly_tmp_ys@toProd purge;            
                    insert into sa_point_mntly_tmp_ys@toProd
                    select * from bwprod.sa_point_mntly_tmp_ys;
                    commit;

            delete from bw_exec_process@toProd purge;            
            insert into bw_exec_process@toProd
            select * from bwprod.bw_exec_process
            where proc_name='Update_Point_Montly' and proc_date=enddate;
            commit;
*/
        end;

    end;        
end;



declare 
    enddate     date;
    nProcSts    number;
    sErrMsg     varchar2(200);    

    begin
        begin
            enddate:='';
            SELECT trunc(sysdate, 'mm') - 1
            INTO enddate
            FROM dual;        
            
            bwprod.pkgbw_update_bpr2.Update_Point_Montly('000',to_char(enddate,'dd/mm/rrrr'),'MTD','MONTHEND','BWOMRP73',73,nProcSts,sErrMsg);
            commit;

        end;
end;


