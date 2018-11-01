select validate_check,reg_no, rep_code, appt_campaign, pkgbw_dsmsmart.GetReturnText(reg_no) return_text, to_char(upd_date,'rrrrmmdd') upd_date
, first_name, last_name, appt_date
from bw_rirep where loc_code = '0399' 
and validate_check in ('1','9') 
--and first_name like 'Ê%'
--and reg_no in ('0999120610150707','0999120607160757','0999120608105838')
order by appt_campaign desc

/*
select validate_check, a.* from bw_rirep a 
--update bw_rirep set validate_check = '9'
where substr(rep_code,1,1) in ('1','2','3','4','5','6','7','8','9','0')
and validate_check not in ('1','9')
*/