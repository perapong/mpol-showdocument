select --stf_iastatus(reg_no) status, --pkgbw_dsm_bsmart.get_apptcamp( loc_code,'162012','162012'),
--(select min(mp.shipdate) from bev$_mailplan mp where mp.loc_code = a.loc_code and trunc(send_date) <= mp.shipdate) ship_date,
--(select r.repappt_campaign from ms_representative r where r.repou_code = '000' and r.reprep_code = a.rep_code) approve_camp,
--pkgbw_dsm_bsmart.ChkApptCamp('000', loc_code, Send_DATE,appt_campaign) est_camp, pkgbw_dsm_bsmart.getLoc_Campaign('000', loc_code,sysdate) cur_camp,
--pkgbw_misc.getxdivcode(loc_code) divcode,
--to_char(validate_date,'dd/mm/rrrr hh24:mi:ss'),
a.* from bw_rirep a --bckprod.
where reg_no is not null
--and loc_code = '0159'
--and reg_no in ('0159180926000928','0159180926001836','0159180926001527','0159180926002346','0159180926002959','0159180926003742','0159180926003350','0159180926004123','0159180926004455','0159180926005225','0159180926004827','0159180926005732','0159180926010716','0159180926011028')
--and appt_campaign = '142018'
--and exists (select 1 from bw_riwelfare w where a.reg_no = w.reg_no)
--and stf_iastatus(reg_no) = 'ON-PROCESS'
--and validate_date is null
--and substr(nvl(rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0') 
--and rep_code = '0199174180'
--and appt_campaign = '032018'
--and first_name like '?%'
--and last_name like '?%'
--and id_card = '3220100188853'
--and dele_repcode = '0664013536'
  and trunc(cre_date) >= trunc(sysdate)-2
--and (send_date) between to_date('22/06/2016 17:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('06/07/2016 17:00:00','dd/mm/rrrr hh24:mi:ss')
--and stf_iastatus(reg_no) = 'ON-PROCESS' -- ('PENDING','SEND_DP') --DIV_REPLY'
--and '001' = pkgbw_misc.getxdivcode(substr(dele_repcode,1,4))
--and not exists (select * from bw_ri_csnote t where t.reg_no = a.reg_no)
--and cre_by = 'IASRV'
--and rownum < 90
order by cre_date desc;


select * from bwprod.bw_ri_backlist where bcklst_key like '%IA_VERSION%';
--select * from bw_ridel_repcode where dele_repcode = '0664013536'
--select * from bw_def$sys where parm_key = 'IA_FLAG_RUN_JOB'
--begin bwprod.stp_iajob_process; end;
--begin pkgbw_iaverify.mainprocedure; end;
--begin pkgbw_dsm_bsmart.transfertobsmart; end;
--update bw_def$sys set varnum1 = 0, vardate2 = sysdate where parm_key = 'IA_FLAG_RUN_JOB';
--
/*
update bw_rirep set validate_check = null, validate_code = null, validate_date= null, reg_batchno= null where reg_no = '0073140829003857';
delete bw_richk_profile where reg_no = '0073140829003857';
delete bw_richk_logerr where reg_no = '0073140829003857';

update bw_rirep 
set rep_code = '' , VALIDATE_CODE = 'TRUE', VALIDATE_CHECK = '1'
where reg_no = '0723150418094046'
*/

--------------------   INSERT ADDRESS ROW   --------------------   INSERT ADDRESS ROW   --------------------   INSERT ADDRESS ROW   --------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
/*
insert into bwprod.bw_riaddress (reg_no, addr_type, seq_no, country, type_address, cre_by, cre_date)
select reg_no, 1, 1, 66, '00', cre_by, cre_date from bwprod.bw_rirep where reg_no = '0016150504183701';

insert into bwprod.bw_riaddress (reg_no, addr_type, seq_no, country, type_address, cre_by, cre_date)
select reg_no, 2, 2, 66, '00', cre_by, cre_date from bwprod.bw_rirep where reg_no = '0016150504183701';
*/

select trunc(cre_date), count(*), sum(case when length(Rep_Code) = 10 then 1 else 0 end) as success, sum(case when length(Rep_Code) < 10 then 1 else 0 end) as unsuccess
from bw_rirep 
where trunc(cre_date) between To_Date('29/06/18', 'DD/MM/YY') and trunc(sysdate)
  and cre_by = 'IASRV'
  and loc_code not like '09%'
group by trunc(cre_date)
order by trunc(cre_date)  
;

--------------------     DELETE REP CODE    --------------------     DELETE REP CODE    --------------------     DELETE REP CODE    --------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
/*
declare
    cursor rec is
        select * from bwprod.bw_ridel_repcode a
        where exists (select 1 from ms_representative ms where ms.repou_code = '000' and ms.reprep_code = a.dele_repcode and ms.repappt_status <> 'DE')
          and trunc(cre_date) between to_date('26/12/2013','dd/mm/rrrr') and sysdate
        ;
BEGIN
    For Trec In Rec Loop
        Begin 
            pkgms_deleterep.delete_main('000', Trec.dele_repcode, 'IA-DELETE', 'PERAPONG' );
        End;
    End Loop;
    commit;
END;


declare
    cursor rec is
        select *
        from bw_rirep a 
        where reg_no is not null
          and fource_status = 'NO60'
          and exists (select * from ms_representative where repou_code = '000' and reprep_code = dele_repcode and repappt_status = 'RE')
          and appt_date >= to_date('21/01/2014','dd/mm/rrrr')
        ;
BEGIN
    For Trec In Rec Loop
        Begin 
            pkgms_deleterep.delete_main('000', Trec.dele_repcode, 'IA-DELETE', 'NO60' );
        End;
    End Loop;
    commit;
END;


        Begin 
            pkgms_deleterep.delete_main('000', '0713122315', 'IA-DELETE', 'PERAPONG' );
        End;

*/
--------------------     IA APPLICATION     --------------------     IA APPLICATION     --------------------     IA APPLICATION     --------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
/*
select * from ms_msl_property where rep_code in ('0411105094','0411103016') --,'00461079400046100750')

select * from log_db_sales_location where ldstloc_code = '0411'

select * from bwprod.DB_SALES_MGRLOG where mgr_empid = 'PF110376'
http://10.0.0.8/www.betterway/ia/ora/runUpdIAApplication.php
*/

select * from bw_riaddress where reg_no = '8585180829163329';


select * from bw_riloc_area
where loc_code = '0163';

Insert into bw_riloc_area (OU_CODE,LOC_CODE,LINEX_TXT,OPTLINE,TUMBON,AMPHUR,PROVINCE,INACTIVE,CRE_BY,CRE_DATE,UPD_BY,UPD_DATE,SEQNO,LOC_MERGE,LOC_MASTER) 
values ('000','0163',null,'N','*','*','28','N','SCRIPT',sysdate,null,null,1,'N','0105');

update bw_riloc_area set province = '76'
 --loc_master = '0139'
where loc_code = '3556';

select * from db_sales_location where dstou_code = '000' and dstloc_type = 'S' and dstloc_name like '%สมุทรปราการ%' order by dstloc_code;


select * from bw_riaddress where reg_no = '0041180703055605';



select trunc(cre_date) dat, count(distinct loc_code)
     , sum(case when nvl(rep_code,'CS-REJECT') = 'CS-REJECT' or rep_code = 'AT-REJECT' then 0 else 1 end) success
     , sum(case when nvl(rep_code,'CS-REJECT') = 'CS-REJECT' or rep_code = 'AT-REJECT' then 1 else 0 end) unsuccess
     , count(*)
from bw_rirep a --bckprod.
where reg_no is not null
--and appt_campaign = '142018'
--and exists (select 1 from bw_riwelfare w where a.reg_no = w.reg_no)
--and stf_iastatus(reg_no) = 'ON-PROCESS'
--and validate_date is null
--and substr(nvl(rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0') 
--and loc_code = '0698'
  and cre_by = 'IASRV'
  and trunc(cre_date) >= to_date('15/08/2018','dd/mm/rrrr')
group by trunc(cre_date)
order by trunc(cre_date) desc;



select * from db_sales_location
where dstou_code = '000'
  and dstloc_code = '8211'
;

select *
from Db_Dsm_Iacontact
where ou_code = '000'
  and loc_code = '0624'
;

--update Db_Dsm_Iacontact set doc_status = 2
where ou_code = '000'
  and loc_code = '0624'
  and doc_no = '2008180029'
;



select pkgdb_desc.GETCURRENT_CAMP_DATE(  ), Get_WorkDate(CurrCamp,TRirec.loc_code,TRirec.send_date), a.*
from bw_rirep a
where (work_date is null 
   or CUR_CAMPAIGN is null)
  and Loc_Code = '0411'
  and Reg_No = '0411180827170350'
;

CurrCamp :=  pkgdb_desc.GETCURRENT_CAMP_DATE(  );
dWorkDate :=  Get_WorkDate(CurrCamp,TRirec.loc_code,TRirec.send_date);

bw_rirep 
where (work_date is null 
   or CUR_CAMPAIGN is null)
  and Loc_Code = '0411'
  and Reg_No = '0411180827170350'
;



select pkgdb_desc.getCampaign_ByDate('000', cre_date) c
     , pkgbw_iaverify.Get_WorkDate(Cur_Campaign,Loc_Code, Send_Date) w
     , a.*
from bw_rirep a
where (Cur_Campaign is null or Work_Date is null)
;



update bw_rirep a
set Cur_Campaign = pkgdb_desc.getCampaign_ByDate('000', cre_date)
where (Cur_Campaign is null or Work_Date is null)
;

update bw_rirep a
set Work_Date = pkgbw_iaverify.Get_WorkDate(Cur_Campaign,Loc_Code, Send_Date)
where (Cur_Campaign is null or Work_Date is null)
;


update bw_rirep set Appt_Campaign = '222018'
where reg_no in ('0180181016102635','0180181015105238')
;
 
 
SELECT reg_no, rep_seq, rep_code, rep_status,  
       rec_status, err_code,VARTXT1 ,VARTXT10          
FROM bw_richk_profile  , BW_DEF$SYS
WHERE REG_NO IN ('0228180827130552') --(SELECT REG_NO  FROM BW_RIREP WHERE  TRUNC(SEND_DATE) = TRUNC(SYSDATE) AND REP_CODE IS NULL )
  AND PARM_KEY LIKE 'DSM_ERR%'
  AND VARTXT1 = ERR_CODE
;


select *
from bw_riloc_area
where loc_code = '0536'
;



select *
from BWPROD.BW_RICHK_PROFILE 
where err_code = '0213'
;

select * from DB_SALES_MGRLOG
where loc_code = '0725'
;

Insert into DB_SALES_MGRLOG (OU_CODE,LOC_CODE,LOG_DATE,MGR_EMPID,MGR_NAME,TABLET_UUID,TABLET_SN,INACTIVE,CRE_BY,CRE_DATE,PROG_ID,UPD_BY,UPD_DATE) 
values ('000','0725',to_date('27/07/2016 00:00:00','DD/MM/RRRR HH24:MI:SS'),'PI127048','?????? ?????',null,'R52H51801BR','0',null,null,null,null,null);


select *
from log_db_sales_location 
where ldstou_code = '000'
  and ldstloc_code = '0725'
  ;