--select pkgdb_desc.getprev_campaign('000',pkgdb_desc.getcurrent_campaign(),1) from dual
--update bw_exec_process set proc_date = to_date('16/12/2014','dd/mm/rrrr'), proc_run_date = to_date('16/12/2014 09:00:00','dd/mm/rrrr hh24:mi:ss') where proc_name='Update_Point_Campaignly' 

select * 
/*to_char(trunc(trunc(sysdate, 'mm') - 1, 'mm'),'dd/mm/rrrr'),
to_char(trunc(sysdate, 'mm') - 1,'dd/mm/rrrr'),
to_char(trunc(sysdate, 'mm') - 1,'mm/rrrr'),
trim(proc_status) */
from bw_exec_process 
where proc_name='Update_Point_Campaignly' 
--25/02/2014 04/2014 ok..
--11/03/2014 05/2014 ok..
--25/03/2014 06/2014 ok..
--08/04/2014 07/2014 ok..
--22/04/2014 08/2014 ok..
--06/05/2014 09/2014 ok..
--20/05/2014 10/2014 ok..
--03/06/2014 11/2014 ok..
--17/06/2014 12/2014 ok..
--01/07/2014 13/2014 ok..
--15/07/2014 14/2014 ok..
--29/07/2014 15/2014 ok..
--12/08/2014 16/2014 ok..
--26/08/2014 17/2014 ok..
--09/09/2014 18/2014 ok..
--23/09/2014 19/2014 ok..
--07/10/2014 20/2014 ok..
--21/10/2014 21/2014 ok..
--04/11/2014 22/2014 ok..
--18/11/2014 23/2014 ok..
--02/12/2014 24/2014 ok..
--16/12/2014 25/2014 ok..
--30/12/2014 26/2014 ok..

--13/01/2015 01/2015 ok..
--27/01/2015 02/2015 ok..
--10/02/2015 03/2015 ok..
--24/02/2015 04/2015 ok



declare 
    enddate     date;
    nProcSts    number;
    sErrMsg     varchar2(200);
begin
    begin
        enddate:='';
        SELECT a.PROC_DATE 
        INTO enddate
        FROM BW_EXEC_PROCESS a where a.PROC_NAME = 'Update_Point_Campaignly' and PROC_STATUS = '1';     
        
        bwprod.pkgbw_update_bpr2.Prepare_Rep_byDate  ('000',to_date('11/02/2014', 'dd/mm/yyyy'),to_date('25/02/2014', 'dd/mm/yyyy'), null, null, null);    

        bwprod.pkgbw_update_bpr2.Update_Point_Campaignly('000',to_char(enddate,'dd/mm/rrrr'),'CTD','CAMPAIGNEND','BWOMRP73',73,nProcSts,sErrMsg);
--        bwprod.pkgbw_update_bpr2.Update_Point_Campaignly('000',to_char(enddate,'dd/mm/rrrr'),'YTD','CAMPAIGNEND','BWOMRP73',73,nProcSts,sErrMsg);
    end;
    begin
        delete from sa_point_cmply_mk@toProd purge
        where spslastdate=enddate;            
        insert into sa_point_cmply_mk@toProd
        select * from bwprod.sa_point_cmply_mk
        where spslastdate=enddate;
        commit;
    end;
    begin
        delete from sa_point_yearly_mk@toProd purge
        where spslastdate=enddate;            
        insert into sa_point_yearly_mk@toProd
        select * from bwprod.sa_point_yearly_mk
        where spslastdate=enddate;
        commit;
    end;
end;


declare 
    enddate     date;
    nProcSts    number;
    sErrMsg     varchar2(200);
begin
    begin
        enddate:='';
        SELECT a.PROC_DATE 
        --INTO enddate
        FROM BW_EXEC_PROCESS a where a.PROC_NAME = 'Update_Point_Campaignly' and PROC_STATUS = '1';         
    end;
    begin
        delete from sa_point_cmply_mk@toProd purge
        where spslastdate=enddate;            
        insert into sa_point_cmply_mk@toProd
        select * from bwprod.sa_point_cmply_mk
        where spslastdate=enddate;
        commit;

        delete from sa_point_yearly_mk@toProd purge
        where spslastdate=enddate;            
        insert into sa_point_yearly_mk@toProd
        select * from bwprod.sa_point_yearly_mk
        where spslastdate=enddate;
        commit;
        /*
        delete from sa_point_cmply_byrep_mk@toProd purge;            
        insert into sa_point_cmply_byrep_mk@toProd
        select * from bwprod.sa_point_cmply_byrep_mk;
        commit;

        delete from sa_point_cmply_tmp_mk@toProd purge;            
        insert into sa_point_cmply_tmp_mk@toProd
        select * from bwprod.sa_point_cmply_tmp_mk;
        commit;*/
    end;
end;
        
66  
22      
select * from sa_point_cmply_mk a where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spslastdate = to_date('24/02/2015','dd/mm/rrrr')
select * from sa_point_yearly_mk where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spslastdate = to_date('24/02/2015','dd/mm/rrrr')
select * from sa_point_cmply_mk@toProd  where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spslastdate = to_date('24/02/2015','dd/mm/rrrr')
select * from sa_point_yearly_mk@toProd where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spslastdate = to_date('24/02/2015','dd/mm/rrrr')



select * from sa_point_cmply_mk@toProd  where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spsseqlevel = 0 and spsdstgroup = 11 order by spslastdate

select * from 
--sa_point_cmply_mk@toProd  
sa_point_yearly_mk@toProd 
where spsou_code = '000' and spsprogref = 'BWOMRP73' and spscode = 'BEOMRP92' and spslastdate = to_date('27/03/2014','dd/mm/rrrr')








