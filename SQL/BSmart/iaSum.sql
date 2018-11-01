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