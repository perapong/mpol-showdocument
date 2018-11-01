select a.*, b.appt_cur_date, b.appt_old_date, (select count(*) from bw_rirep t 
             where substr(nvl(rep_code,'null'),1,1) in ('1','2','3','4','5','6','7','8','9','0') 
             and loc_code not in ('0999') and trunc(t.appt_date) = trunc(a.send_date)
             ) total_appt
from BEV$_IA_SUMMARY a left outer join BEV$_IA_SUM_APPT_DATE b on a.send_date = b.appt_date
order by a.send_date

--/*   --------------------------------------------------------------   */

--create or replace force view BEV$_IA_SUMMARY as 
select send_date, sum(total) total, sum(success) success, sum(auto) auto, sum(send) send, sum(pending) pending, sum(bs_reject) bs_reject, sum(as_reject) as_reject, sum(cs_reject) cs_reject
, sum(as400) as400_appt, sum(bsmart) bsmart_appt
, (select count(*) from bw_rirep t 
    where substr(nvl(rep_code,'null'),1,1) in ('1','2','3','4','5','6','7','8','9','0') 
      and loc_code not in ('0999') and trunc(t.appt_date) = trunc(a.send_date) ) 
from (
            select v.* 
                 , case when (loc_code > '0999') then success else 0 end bsmart
                 , case when (loc_code < '0999') then success else 0 end as400
            from bev$_ia_sum_dist v
            where send_date > to_date('31/05/2012','dd/mm/rrrr')
    ) vvv
group by send_date

--/*   --------------------------------------------------------------   */

--create or replace force view BEV$_IA_SUM_APPT_DATE as 
select appt_date, sum(appt_cur_date) appt_cur_date, sum(appt_old_date) appt_old_date from (
select trunc(appt_date) appt_date
     , case when trunc(appt_date) =  trunc(send_date) then 1 else 0 end appt_cur_date
     , case when trunc(appt_date) <> trunc(send_date) then 1 else 0 end appt_old_date
from bw_rirep
where loc_code not in ('0999')
and trunc(send_date) > to_date('31/05/2012','dd/mm/rrrr')
and substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0')
) group by appt_date
order by 1

--/*   --------------------------------------------------------------   */

--create or replace force view BEV$_IA_SUM_DIST as
select a.dstloc_code loc_code, send_date, total, success, auto, send, pending, bs_reject, as_reject, cs_reject
from bw_riloc a left outer join
  ( select loc_code, send_date, count(*) total, sum(success) success, sum(auto) auto, sum(send) send, sum(pend) pending, sum(bsrej) bs_reject, sum(asrej) as_reject, sum(csrej) cs_reject
    from (  select loc_code
                 , send_date
                 , case when status = 'success' then 1 else 0 end success
                 , case when status = 'auto' then 1 else 0 end auto
                 , case when status = 'send' then 1 else 0 end send
                 , case when status = 'pend' then 1 else 0 end pend
                 , case when status = 'bsrej' then 1 else 0 end bsrej
                 , case when status = 'asrej' then 1 else 0 end asrej
                 , case when status = 'csrej' then 1 else 0 end csrej
            from (  select loc_code
                         , trunc(send_date) send_date
                         , case when substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0') then 'success' 
                                when rep_code = 'AUTO' then 'auto'
                                when rep_code = 'SEND' then 'send'
                                when rep_code = 'PENDING' then 'pend'
                                when rep_code is null  then 'bsrej'
                                when rep_code = 'AS400-REJ' then 'asrej'
                                when rep_code = 'CS-REJECT' then 'csrej' end status
                    from bw_rirep
                    where loc_code not in ('0999')
                 ) bbb
         ) bb 
    group by loc_code, send_date
  ) b on a.dstloc_code = b.loc_code
where a.dstloc_type = 'S'
  and substr(a.dstloc_code,1,1) not in ('8','9')
order by a.dstloc_code


/*
create view BEV$_IA_SUMMARY as 
select send_date, count(*) total, sum(success) success, sum(invalid) invalid, sum(auto) auto, sum(send) send, sum(as400) as400, sum(csrej) csrej
from (
select trunc(send_date) send_date
     , case when substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0') then 1 else 0 end success
     , case when rep_code is null  then 1 else 0 end invalid 
     , case when rep_code = 'AUTO' then 1 else 0 end auto
     , case when rep_code = 'SEND' then 1 else 0 end send
     , case when rep_code = 'AS400-REJ' then 1 else 0 end as400
     , case when rep_code = 'CS-REJECT' then 1 else 0 end csrej
from bw_rirep
where loc_code not in ('0999')
and trunc(send_date) > to_date('31/05/2012','dd/mm/rrrr')
)
group by send_date
order by 1
*/
/*
select count(*) tot_count, 1, 'total' sum_type from bw_rirep 
where trunc(cre_date) = trunc(sysdate) and loc_code <> 't001'
union
select count(*) tot_count, 2, 'invalid' sum_type from bw_rirep 
where trunc(cre_date) = trunc(sysdate) and loc_code <> 't001'
and rep_code is null
union
select count(*) tot_count, 3, 'success' sum_type from bw_rirep a
where trunc(cre_date) = trunc(sysdate)
and loc_code <> 't001'
and substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0')
union
select count(*) tot_count, 4, 'send' sum_type from bw_rirep a
where trunc(cre_date) = trunc(sysdate) and loc_code <> 't001'
and rep_code = 'SEND'
union
select count(*) tot_count, 5, 'auto' sum_type from bw_rirep a
where trunc(cre_date) = trunc(sysdate) and loc_code <> 't001'
and rep_code = 'AUTO'
union
select count(*) tot_count, 6, 'as400' sum_type from bw_rirep a
where trunc(cre_date) = trunc(sysdate) and loc_code <> 't001'
and rep_code = 'AS400-REJ'
order by 2
*/