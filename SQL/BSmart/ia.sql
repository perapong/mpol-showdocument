/*
            update bw_rirep set marital_status = 0
            where loc_code is not null and rep_code is null and marital_status is null;
        end;

        begin
            update bw_rirep set first_name = trim(first_name), last_name = trim(last_name)
            where loc_code is not null and rep_code is null;
        end;

        begin
            update bw_rirep set validate_date = upd_date where validate_date is null and nvl(validate_check,'0') not in ('7','9');

select * from bw_rirep where rep_code = 'CS-REJECT' and validate_check <> 7
--update bw_rirep set validate_check = 7 where rep_code = 'CS-REJECT' and validate_check <> 7

stf_iastatus(reg_no) = 'PENDING'

select * from bw_rirep 
--update bw_rirep set validate_date = upd_date
where substr(nvl(rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
and validate_date is null and reg_batchno is not null and rep_code is null
and exists (select 1 from bw_richk_profile t where t.reg_no = bw_rirep.reg_no)

select * from bw_rirep 
--update bw_rirep set marital_status = 0
where loc_code is not null and rep_code is null and marital_status is null

select * from om_transaction_hdr 
--update om_transaction_hdr set ohdrep_telno = (select repmobile_no from ms_representative where reprep_seq = ohdrep_seq)
where ohdou_code = '000' and trunc(ohdtrans_date) > trunc(sysdate-1) and ohdrep_telno is null and ohdtrans_no like '11%'


select (select min(err_code) from bw_richk_profile t where t.reg_no = a.reg_no) chk_err,
stf_iastatus(reg_no), a.* 
from bev$_iachk_cserr a
where stf_iastatus(reg_no) = ('ON-PROCESS')
and err_code is null
--and reg_no = '0609120810115328'

select distinct ''''||r.loc_code||''',' 
from bw_rirep r , bev$_mailplan m
where r.loc_code = m.loc_code
--and r.loc_code = '0226'
and m.shipdate = trunc(sysdate)
order by 1


select r.repappt_campaign, i.* 
from bw_rirep i , ms_representative r
where trunc(i.appt_date) = trunc(sysdate)
and i.appt_campaign != r.repappt_campaign
and r.repou_code = '000'
and r.reprep_code = i.rep_code



select r.loc_code, r.rep_code, r.first_name, r.last_name, r.appt_campaign
from bw_rirep r , bev$_mailplan m
where r.loc_code = m.loc_code
and appt_date > to_date(trunc(sysdate)||' 12:00:00','dd/mm/rrrr hh24:mi:ss')
and m.shipdate = trunc(sysdate)


SELECT smumenu_id, smufunction_id, smumenu_lname, smumenu_ename,
       smumenu_short, smumenu_level, smuparent_id, smumenu_seg1,
       smumenu_seg2, smumenu_seg3, smumenu_seg4, smumenu_seg5,
       smumenu_seg6, smumenu_seg7, smumenu_att1, smumenu_att2,
       smumenu_att3, smucre_by, smucre_date, smuprog_id, smuupd_by,
       smuupd_date,
       level-1, smumenu_level, lpad(' ',2*(level-1)) || to_char(smumenu_id) s, smumenu_lname
  FROM su_menu
  start with smuparent_id is null
  connect by prior smumenu_id = smuparent_id




select * from bw_riaddress where reg_no = '0133120718154309'
select * from db_province p where p.prvprovince_code is not null and prvinactive_status = 0 order by 3
select * from db_amphur a where a.ampprovince_code = '12' and a.ampinactive_status = '0' order by 3
select * from db_tumbon t where t.tbnamphur_code = '1208' and t.tbninactive_status = '0' order by 3
*/



/*  as400 lookup

select x.rep_code, x.reg_no, x.fource_status--, hx.*
from bw_rirep x --, iamslmst@eh2as  hx
where x.rep_code ='SEND'
--and x.reg_no = hx.regno(+)
and x.reg_no in ('0153120717171345',
'0126120718091256')
--and hx.regno is null
and x.reg_no in (   select reg_no
                    from bev$_iachk_errship
                    where fource_status = '0880'
                    and rep_code = 'AS400-REJ'
                    and last_name like '%*'  )

--update iamslmst@eh2as set ctlsts = '0880' where mslno = 0 and regno in ('0008120707144705')
--update iamslmst@eh2as set ctlsts = '0888', mslno = 2188, chkdgt = 1 where regno in ( '0736120706165354')



--insert into bw_user_access 
SELECT ou_code, topic_group, 'NATCHAPONG_S' user_id, seq_no, loc_type, loc_code,
       remark, default_flag, 'PERAPONG' cre_by, sysdate cre_date, null upd_by, null upd_date,
       prog_id
  FROM bw_user_access
  where user_id = 'PERAPONG'
  --and loc_code = '026'---seq_no =>> 1, default_flag=>>>'Y'
*/

--เปลี่ยนรอบ 
select *  
from bw_rirep a , bev$_mailplan mp 
where substr(nvl(rep_code,'null'),1,1) in ('1','2','3','4','5','6','7','8','9','0') 
and appt_date > to_date('27/07/2012 12:00:00','dd/mm/rrrr hh24:mi:ss') 
--and appt_date < to_date('26/07/2012 17:00:00','dd/mm/rrrr hh24:mi:ss') 
and mp.loc_code = a.loc_code 
and shipdate = to_date('27/07/2012','dd/mm/rrrr') 
order by 1

/*
create table zp_temp2 as
select * from bw_rirep 
--update bw_rirep set validate_check = 'P'
where upd_date between to_date('08/08/2012 16:20:42','dd/mm/rrrr hh24:mi:ss') and to_date('08/08/2012 16:40:42','dd/mm/rrrr hh24:mi:ss')
and validate_date between to_date('08/08/2012 16:20:42','dd/mm/rrrr hh24:mi:ss') and to_date('08/08/2012 16:40:42','dd/mm/rrrr hh24:mi:ss')
and substr(nvl(rep_code,'null'),1,1) in ('1','2','3','4','5','6','7','8','9','0') 
--8/08/2012 16:25:57
*/



select * from bw_rirep r where substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
and trunc(r.send_date) >= to_date('21/08/2012','dd/mm/rrrr')
and appt_campaign like '0%'

--select * from bev$_utsession_lock


select * from bw_riwelfare where reg_no = '0644121217213054'
select * from bw_ripicture where reg_no = '0644121217213054'

