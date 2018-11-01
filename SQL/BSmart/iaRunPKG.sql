BEGIN
  --pkgbw_dsmsmart.createbatcid;
  pkgbw_dsm_bsmart.transfertobsmart;
  --pkgbw_dsmsmart.geta400repcode ;
END;


select * from bw_rirep
--update bw_rirep set validate_check = '9'
where substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0')
and validate_check = '0'
--and loc_code > '0999'
--and loc_code = '6056'
order by loc_code


--select * from iamslmst@eh2as, bw_rirep where reg_no = regno and rep_code = 'SEND'

--select * from bw_rirep where rep_code = 'AUTO' and work_date is null and send_date between to_date('11/06/2012 17:30:01','dd/mm/rrrr hh24:mi:ss') and to_date('11/06/2012 23:59:59','dd/mm/rrrr hh24:mi:ss')
--update bw_rirep set work_date = case when send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') then to_date('11/06/2012','dd/mm/rrrr') else send_date end where rep_code = 'AUTO' and work_date is null and send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') 
--update bw_rirep set work_date = send_date where rep_code = 'AUTO' and work_date is null and trunc(send_date) = trunc(sysdate)
--update bw_rirep set work_date = case when send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') then to_date('11/06/2012','dd/mm/rrrr') else send_date end 
/*
select to_char(send_date,'dd/mm/rrrr hh24:mi:ss') ,
case when send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') then to_date('11/06/2012','dd/mm/rrrr') else send_date end
, a.* from bw_rirep a
where rep_code = 'AUTO' and work_date is null and fource_status = '0000'--and send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') 
order by 1
*/
--update bw_rirep set work_date = case when send_date < to_date('11/06/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') then to_date('11/06/2012','dd/mm/rrrr') else send_date end where rep_code = 'AUTO' and work_date is null and fource_status = '0000'