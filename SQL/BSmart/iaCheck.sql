select * from bw_riaddress where reg_no = '0130150118053654'

select * from bw_richk_profile where reg_no = '0454150112142017'

select * from bw_richk_logerr where reg_no = '0454150112142017'

select * from bev$_iachk_cserr where reg_no = '0454150112142017'

select * from bev$_iacs_verify where reg_no = '0454150112142017'

select * from bw_ri_csnote where reg_no = '0803150214172202'

select * from bw_rilog_renew where reg_no = '0454150112142017' 

select * from bw_def$sys where parm_key = 'DSM_ERR' and vartxt1 like '052%' 

select * from bev$_iachk_cserr where err_code = '0522'

select * from bw_richk_profile where err_code = '0522'

select distinct rec_status from bw_ri_csnote where source_from = 'CS' rec_status = 20

select * from bw_def$sys where parm_key like 'DSM%' order by seq_no;

select * from bw_ridel_repcode where dele_repcode = '8320004659'


select * from bev$_iacs_verify where loc_code = '0624' and rep_code is null


select proc_type, a.* from bev$_iacs_verify a where loc_code like '0021%'
and reg_no = '0021140827121205'
and loc_code not in (select dist_code from  bev$_skipdist)
--and cur_campaign like :criteria.ctr_camp1||'%'
and decode('BILL', 'BILL',billing_date,'SEND',trunc(send_date),ship_date) like '%'
and nvl(nsm,'%') like '%'
and replace(first_name||last_name,chr(32),null) like replace('วิจิตรา',chr(32),null)||'%'
and nvl(mobile_no,'x')  like '%'
and id_card like '%' 
and proc_type like '%'

select * from BEV$_IA_SUMMARY_BY_LOC



select * from bw_ri_csnote where reg_no in (select reg_no from bw_rirep a
where reg_no is not null
and rep_code like 'AT-REJECT%' --= '0183115627'
and validate_date > to_date('29/10/2014 16:11:00','dd/mm/rrrr hh24:mi:ss'))



