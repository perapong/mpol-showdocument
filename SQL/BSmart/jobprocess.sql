--select * from bev$_utjob_sdteam
select *
from su_helpdesk_hdr
where cfhassign_to = 'PERAPONG'
--and cfhstatus <> 4
--and CFHFOL_NO >= 'BW13001750'
  /*
  and not exists (select 1 from su_helpdesk_dtl d
                   where cfdfol_no = cfhfol_no and cfdorg_by = 'PERAPONG'
                     and cfdou_code = '000' and cfddet_status = 4)
  and not exists (select 1 from su_helpdesk_dtl d
                   where cfdfol_no = cfhfol_no and cfdorg_by = 'PERAPONG'
                     and cfdou_code = '000' and cfdfol_seq = 2)
  */
order by cfhfol_no DESC




select *
from su_helpdesk_dtl d
where cfdorg_by = 'PERAPONG'
  and cfdou_code = '000'
  and cfdfol_no = 'BW13000163'
  and cfddet_status = 4


--update su_helpdesk_hdr set cfhtopic = nullwhere cfhassign_to = 'PERAPONG'
--update su_helpdesk_hdr set cfhdue_date = cfhclose_date where cfhassign_to = 'PERAPONG' 
--and cfhclose_date is not null
  update su_helpdesk_hdr set cfhclose_date = cfhdue_date , cfhupd_date = sysdate
  where cfhassign_to = 'PERAPONG' and cfhstatus = 4 and cfhclose_date is null and cfhdue_date is not null
  
  
select * from su_running where srnrun_seq = 3068 and srnou_code = '000' and srnrun_of_year = 2013
select max(cfhfol_no) from su_helpdesk_hdr



/* insert transaction header */
--insert into su_helpdesk_hdr h
SELECT '000' cfhou_code, 'BW1300'|| to_char(1628+job_id) cfhfol_no, null cfhrep_code, null cfhmobile_no, to_date(date_s|| ' 17:30:00','dd/mm/rrrr hh24:mi:ss') cfhinform_date,
       'D001' cfhcat_code, 'D020' cfhsub_cat_code, 4 cfhstatus, 2 cfhpriority,
       'OTHERS' cfhprogname, null cfharea, '01' cfhosref, null cfhipaddress, user_req cfhtopic, substr(jobdesc,1,300) cfhdesc,
       'PERAPONG' cfhassign_to, null cfhattach, to_date(date_e|| ' 17:30:00','dd/mm/rrrr hh24:mi:ss') cfhdue_date, to_date(date_e|| ' 17:30:00','dd/mm/rrrr hh24:mi:ss') cfhclose_date, 'PERAPONG' cfhcre_by,
       to_date(date_s|| ' 17:30:00','dd/mm/rrrr hh24:mi:ss') cfhcre_date, 'BWSURT23' cfhprog_id, 'PERAPONG' cfhupd_by, to_date(date_e|| ' 17:30:00','dd/mm/rrrr hh24:mi:ss') cfhupd_date
--select *
  FROM perapong.sd_jobcontrol2
--where job_id between 496 and 545
--where job_id between 546 and 604


/* insert transaction close status */
--insert into su_helpdesk_dtl d
SELECT '000' cfdou_code, cfhfol_no cfdfol_no, 3 cfdfol_seq, cfhclose_date cfdorg_date, 'PERAPONG' cfdorg_by,
       'Finished' cfdorg_desc, 4 cfddet_status, 'PERAPONG' cfdfol_by, null cfdfol_acc_date,
       null cfdfol_resp_date, null cfdfol_desc, 
       'PERAPONG' cfdcre_by, cfhupd_date cfdcre_date, 'BWSURT23' cfdprog_id, 'PERAPONG' cfdupd_by, cfhupd_date cfdupd_date
from su_helpdesk_hdr
where cfhassign_to = 'PERAPONG'
--and cfhfol_no <= 'BW13002642'
  and cfhstatus = 4
  and not exists (select 1 from su_helpdesk_dtl d
                   where cfdfol_no = cfhfol_no and cfdorg_by = 'PERAPONG'
                     and cfdou_code = '000' and cfddet_status = 4)
 -- and exists (select 1 from su_helpdesk_dtl d
 --                  where cfdfol_no = cfhfol_no and cfdorg_by = 'PERAPONG'
 --                    and cfdou_code = '000' and cfdfol_seq = 2)
order by cfhfol_no DESC


select * 
from su_helpdesk_hdr
where cfhassign_to = 'PERAPONG'
  and cfhfol_no like 'BW1300266%'
  
  
  

