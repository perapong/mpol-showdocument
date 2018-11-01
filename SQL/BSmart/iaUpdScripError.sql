--insert into bw_riupd_script
select sysdate LAUNCH_DATE, '*' LOC_DESTINATION, 'insert into param (param_id,param_name,entry_code,entry_desc) values (''999'',''DSM_ERR'','''||vartxt1||''','''||vartxt10||''')' EXEC_SCRIPT
, 1 INACTIVE, sysdate CRE_DATE, 'admin' CRE_BY, null UPD_DATE, null UPD_BY
--,a.* 
from bw_def$sys a
where parm_key = 'DSM_ERR'
and vartxt1 > '0210'
order by vartxt1

--0210