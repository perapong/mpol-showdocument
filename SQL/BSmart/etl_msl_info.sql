select count(*), max(cre_date), max(upd_date), max(rep_seq) from BWPROD.BEMV_ETL_MSL_INFO_M
where rep_seq > 9000000;

select repAPPT_STATUS, count(*) cnt from ms_representative ms
where repou_code = '000'
group by repAPPT_STATUS;

select max(REP_SEQ) from mslmst;

select a.*, (select max(REP_SEQ) from mslmst) maxrep from etl_log a where Log_Date = DATE_FORMAT(NOW(),'%Y%m%d') order by log_date desc;
20	20151208	05:49:02	9048053
12	20151130	05:42:18	9025279
 9	20151127	05:47:10	9018961
 8	20151126	05:47:34	9015953
 7  20151125	05:47:31  9012713 
;

create table zp_BEMV_ETL_MSL_INFO as
select * from BWPROD.BEMV_ETL_MSL_INFO; 

select * from BWPROD.BEMV_ETL_MSL_INFO_M;

select * from bw_def$sys where parm_key like '%ETL%';

update bw_def$sys set vardate1 = to_date('13/11/2015','dd/mm/rrrr'), vardate2 = to_date('14/11/2015','dd/mm/rrrr'), varnum1 = 1, varnum2 = 100 where parm_key = 'ETL_MSL_INFO';   
    
declare
    mview_name varchar2(20);
begin
    update bw_def$sys set vardate1 = to_date('22/09/2015','dd/mm/rrrr'), vardate2 = to_date('23/09/2015','dd/mm/rrrr'), varnum1 = 1, varnum2 = 10000 where parm_key = 'ETL_MSL_INFO';   
    commit;
    
    mview_name := 'BEMV_ETL_MSL_INFO';
    DBMS_SNAPSHOT.REFRESH(mview_name); 

end;

begin
    BWPROD.STP_ETL_MSL_MVIEW('BEMV_ETL_MSL_INFO_M', 'ETL_MSL_INFO', to_date('01/01/2016','dd/mm/rrrr'), to_date('01/11/2028','dd/mm/rrrr'), 1, 99000000);
end;  

bwprod.MB_REP_INFO_HISTORY


select count(*) from BEMV_ETL_MSL_INFO_M;

begin
    BWPROD.STP_ETL_MSL_MVIEW('BEMV_ETL_MSL_INFO', 'ETL_MSL_INFO', to_date('22/09/2015','dd/mm/rrrr'), to_date('23/09/2015','dd/mm/rrrr'), 1, 100);
end;

create or replace PROCEDURE STP_ETL_MSL_MVIEW (Parm_MView VARCHAR2, Parm_Key VARCHAR2, Parm_Date1 DATE, Parm_Date2 DATE, Parm_Num1 INTEGER, Parm_Num2 INTEGER) is
begin
    update bw_def$sys set vardate1 = to_date('22/09/2015','dd/mm/rrrr'), vardate2 = to_date('23/09/2015','dd/mm/rrrr'), varnum1 = Parm_Num1, varnum2 = Parm_Num2 where parm_key = 'ETL_MSL_INFO';   
    commit;
    
    DBMS_SNAPSHOT.REFRESH(Parm_MView); 
end;


select ms.reprep_seq rep_seq
     , ms.reprep_code rep_code
     , ms.reprep_code_old rep_code_old
     , ms.reploc_code dist
     , ms.reprep_running mslno
     , ms.repcheck_digi chkdgt
     , ms.reprep_status status
     , ms.repdirect_sales_status directsale_status
     , decode(upper(substr(nvl(ms.repdirect_sales_status,'D'),1,1)),'G','GC1',null) goldclub
     , nvl(mi.reiar_balance,0) ar_balance
     , nvl(mi.reipoint_balance,0) bpr_balance
     , ms.repcre_date cre_date
     , to_char(ms.repcre_date,'hh24:mi:ss') cre_time
     , ms.repupd_date upd_date
     , to_char(ms.repupd_date,'hh24:mi:ss') upd_time 
from bwprod.ms_representative ms
   , bwprod.ms_rep_info mi
   , bwprod.bw_def$sys df
where ms.repou_code = '000'
  and ms.reprep_seq between varnum1 and varnum2
  and ms.repappt_status not in ('RE', 'DE')
  and mi.reiou_code = ms.repou_code
  and mi.reirep_seq = ms.reprep_seq
  and parm_key = 'ETL_MSL_INFO'
  and ms.reprep_code = '0170015148'
  ;


    --update bw_def$sys set vardate1 = to_date('22/09/2015','dd/mm/rrrr'), vardate2 = to_date('23/09/2015','dd/mm/rrrr'), varnum1 = 1, varnum2 = 10000 where parm_key = 'ETL_MSL_INFO';   
select * from bw_def$sys where parm_key like '%ETL%'


/******************************************************************************************************************************************************************/

CREATE MATERIALIZED VIEW BEMV_ETL_MSL_INFO 
NOCACHE 
USING INDEX 
REFRESH 
START WITH TO_DATE('29-Sep-2015 05:00:00','DD-MON-YYYY HH24:MI:SS') NEXT SYSDATE + 1 
FORCE 
USING DEFAULT ROLLBACK SEGMENT 
DISABLE QUERY REWRITE AS 
select ms.reprep_seq rep_seq
     , ms.reprep_code rep_code
     , ms.reprep_code_old rep_code_old
     , ms.reploc_code dist
     , ms.reprep_running mslno
     , ms.repcheck_digi chkdgt
     , ms.reprep_status status
     , ms.repe_mail e_mail
     , ms.repdirect_sales_status directsale_status
     , decode(upper(substr(nvl(ms.repdirect_sales_status,'D'),1,1)),'G','GC1',null) goldclub
     , nvl(mi.reiar_balance,0) ar_balance
     , nvl(mi.reipoint_balance,0) bpr_balance
     , ms.repcre_date cre_date
     , to_char(ms.repcre_date,'hh24:mi:ss') cre_time
     , ms.repupd_date upd_date
     , to_char(ms.repupd_date,'hh24:mi:ss') upd_time 
from (select distinct rep_seq from bwprod.MB_REP_INFO_HISTORY mh, bwprod.bw_def$sys df where upd_date between df.vardate1 and df.vardate2 and df.parm_key = 'ETL_MSL_INFO' 
/*trunc(upd_date) = trunc(sysdate-1) /*to_date('24/09/2015','dd/mm/rrrr')*/
union select * bwprod.ms_representative ms 
) mh 
   , bwprod.ms_representative ms
   , bwprod.ms_rep_info mi
where ms.repou_code = '000'
  and ms.reprep_seq = mh.rep_seq
  and mi.reiou_code = ms.repou_code
  and mi.reirep_seq = ms.reprep_seq;
  
/******************************************************************************************************************************************************************/  
  
CREATE MATERIALIZED VIEW BEMV_ETL_MSL_INFO_M
NOCACHE 
USING INDEX 
REFRESH 
START WITH TO_DATE('29-Sep-2015 05:00:00','DD-MON-YYYY HH24:MI:SS') 
FORCE 
USING DEFAULT ROLLBACK SEGMENT 
DISABLE QUERY REWRITE AS 
select ms.reprep_seq rep_seq
     , ms.reprep_code rep_code
     , ms.reprep_code_old rep_code_old
     , ms.reprep_name rep_name
     , ms.repmobile_no mobile_no
     , ms.reploc_code dist
     , ms.reprep_running mslno
     , ms.repcheck_digi chkdgt
     , ms.reprep_status rep_status
     , ms.repappt_status appt_status
     , ms.repe_mail e_mail
     , ms.repdirect_sales_status directsale_status
     , decode(upper(substr(nvl(ms.repdirect_sales_status,'D'),1,1)),'G','GC1',null) goldclub
     , nvl(mi.reiar_balance,0) ar_balance
     , nvl(mi.reipoint_balance,0) bpr_balance
     , ms.repcre_date cre_date
     , to_char(ms.repcre_date,'hh24:mi:ss') cre_time
     , ms.repupd_date upd_date
     , to_char(ms.repupd_date,'hh24:mi:ss') upd_time 
from bwprod.ms_representative ms
   , bwprod.ms_rep_info mi
   , bwprod.bw_def$sys df
where ms.repou_code = '000'
  and ms.reprep_seq between varnum1 and varnum2
  and ms.repappt_status not in ('RE', 'DE')
  and mi.reiou_code = ms.repou_code
  and mi.reirep_seq = ms.reprep_seq
  and parm_key = 'ETL_MSL_INFO';
  
/******************************************************************************************************************************************************************/  
                                                         
CREATE MATERIALIZED VIEW BEMV_ETL_MSL_INFO 
NOCACHE 
USING INDEX 
REFRESH 
START WITH TO_DATE('29-Sep-2015 05:00:00','DD-MON-YYYY HH24:MI:SS') NEXT SYSDATE + 1 
FORCE 
USING DEFAULT ROLLBACK SEGMENT 
DISABLE QUERY REWRITE AS 
select ms.reprep_seq rep_seq
     , ms.reprep_code rep_code
     , ms.reprep_code_old rep_code_old
     , ms.reprep_name rep_name
     , ms.repmobile_no mobile_no
     , ms.reploc_code dist
     , ms.reprep_running mslno
     , ms.repcheck_digi chkdgt
     , ms.reprep_status rep_status
     , ms.repappt_status appt_status
     , ms.repe_mail e_mail
     , ms.repdirect_sales_status directsale_status
     , decode(upper(substr(nvl(ms.repdirect_sales_status,'D'),1,1)),'G','GC1',null) goldclub
     , nvl(mi.reiar_balance,0) ar_balance
     , nvl(mi.reipoint_balance,0) bpr_balance
     , ms.repcre_date cre_date
     , to_char(ms.repcre_date,'hh24:mi:ss') cre_time
     , ms.repupd_date upd_date
     , to_char(ms.repupd_date,'hh24:mi:ss') upd_time 
from (select distinct rep_seq from bwprod.MB_REP_INFO_HISTORY mh, bwprod.bw_def$sys df where upd_date between df.vardate1 and df.vardate2 and df.parm_key = 'ETL_MSL_INFO' /*trunc(upd_date) = trunc(sysdate-1) /*to_date('24/09/2015','dd/mm/rrrr')*/) mh 
   , bwprod.ms_representative ms
   , bwprod.ms_rep_info mi
where ms.repou_code = '000'
  and ms.reprep_seq = mh.rep_seq
  and mi.reiou_code = ms.repou_code
  and mi.reirep_seq = ms.reprep_seq;
  
  
/******************************************************************************************************************************************************************/  
    SELECT REP.REPREP_SEQ, REP.REPREP_CODE, REP.REPREP_NAME, REPDIRECT_SALES_TYPE, REPDIRECT_SALES_STATUS, REPDIRECT_SALES_CAMP, REPDIRECT_SALES_DATE, REPDIRECT_SALES_UPD_BY
    FROM   DB_MAILPLAN_SALES MPS
    ,      MS_REPRESENTATIVE REP
    WHERE  MPS.MPSOU_CODE   = '000'
    AND    TRUNC(MPS.MPSSHIPDATE) = TRUNC(SYSDATE-1)
    AND    REP.REPOU_CODE   = MPS.MPSOU_CODE
    AND    REP.REPLOC_CODE  = MPS.MPSLOC_CODE
    AND    REP.REPREP_TYPE  IN ('00','05','07','10') 
    AND    REP.REPAPPT_STATUS NOT IN ('DE','RE')
    AND    REP.REPLOC_CODE  != '0002'
    AND    NOT EXISTS ( SELECT  NULL
                        FROM   MS_REP_GOLDCLUB GC1
                        WHERE  GC1.REPOU_CODE   = '000'
                        AND    (TRUNC(GC1.DP_REGISTER_DATE) = TRUNC(SYSDATE-1) OR TRUNC(GC1.DP_CANCEL_DATE) = TRUNC(SYSDATE-1))
                        AND    GC1.REPOU_CODE = REP.REPOU_CODE
                        AND    GC1.REPREP_SEQ = REP.REPREP_SEQ
                      )
    UNION ALL
    -- Gold Club Update
    SELECT  REP.REPREP_SEQ, REP.REPREP_CODE, REP.REPREP_NAME, REPDIRECT_SALES_TYPE, REPDIRECT_SALES_STATUS, REPDIRECT_SALES_CAMP, REPDIRECT_SALES_DATE, REPDIRECT_SALES_UPD_BY
    FROM   MS_REP_GOLDCLUB GC1
    ,      MS_REPRESENTATIVE REP
    WHERE  GC1.REPOU_CODE   = '000'
    AND    (TRUNC(GC1.DP_REGISTER_DATE) = TRUNC(SYSDATE-1) OR TRUNC(GC1.DP_CANCEL_DATE) = TRUNC(SYSDATE-1))
    AND    REP.REPOU_CODE   = GC1.REPOU_CODE
    AND    REP.REPREP_SEQ   = GC1.REPREP_SEQ
    
    
    
select * from bwprod.BEMV_ETL_MSL_INFO_M


begin
    bwprod.STP_ETL_MSL_MVIEW('BEMV_ETL_MSL_INFO_M', 'ETL_MSL_INFO', to_date('22/09/2015','dd/mm/rrrr'), to_date('23/09/2015','dd/mm/rrrr'), 8000001, 9000000);
end;

select max(rep_seq) from bwprod.BEMV_ETL_MSL_INFO_M


begin
    update bw_def$sys set vardate1 = to_date('22/09/2015','dd/mm/rrrr'), vardate2 = to_date('23/09/2015','dd/mm/rrrr'), varnum1 = 10001, varnum2 = 20000 where parm_key = 'ETL_MSL_INFO';   
    commit;
    
begin
    DBMS_SNAPSHOT.REFRESH('BWPROD.BEMV_ETL_MSL_INFO_M'); 
end;

begin
    DBMS_SNAPSHOT.REFRESH('BWPROD.BEMV_ETL_MSL_INFO'); 
end;

select vardate1, vardate2, a.* from bw_def$sys a where parm_key like 'ETL_MSL_INFO'

update bw_def$sys set vardate1 = to_date('26/10/2015','dd/mm/rrrr'), vardate2 = to_date('30/10/2015','dd/mm/rrrr'), varnum1 = 1, varnum2 = 100 where parm_key = 'ETL_MSL_INFO';   

begin
    DBMS_SNAPSHOT.REFRESH('BWPROD.BEMV_ETL_MSL_INFO_M'); 
end;

select count(*), max(cre_date), max(upd_date), max(rep_seq) from BWPROD.BEMV_ETL_MSL_INFO

begin
    bwprod.STP_ETL_MSL_MVIEW('BEMV_ETL_MSL_INFO', 'ETL_MSL_INFO', to_date('12/10/2015','dd/mm/rrrr'), to_date('13/10/2015','dd/mm/rrrr'), 1, 110);
end;

create table perapong.p_mstmsl as
select * from bwprod.BEMV_ETL_MSL_INFO   
39070 = 6/10
44164 = 7/10
45169 = 8/10
53231	= 11/10/2015 
02 ¾.Â.  2015	02 ¾.Â.  2015	50146	8925986
03 ¾.Â.  2015	03 ¾.Â.  2015	26195	8929852
05 ¾.Â.  2015	05 ¾.Â.  2015	46998	8937190
08 ¾.Â.  2015	08 ¾.Â.  2015	10640	8943568

select max(cre_date), max(upd_date), count(*), max(rep_seq) from bwprod.BEMV_ETL_MSL_INFO



/*


Insert into bw_def$sys (PARM_KEY,SEQ_NO,PROG_ID,TXTMEMO,VARTXT1,VARTXT2,VARTXT3,VARTXT4,VARTXT5,VARTXT6,VARTXT7,VARTXT8,VARTXT9,VARTXT10,VARTXT11,VARTXT12,VARTXT13,VARTXT14,VARTXT15,MEMO,VARNUM1,VARNUM2,VARNUM3,VARNUM4,VARNUM5,VARNUM6,VARNUM7,VARNUM8,VARNUM9,VARNUM10,VARDATE1,VARDATE2,VARDATE3,VARDATE4,VARDATE5,EFFECTIVE_DATE) 
values ('ETL_MSL_INFO',1,'ETL','ETL Data of Msl to MySQL',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
                                                         ,null
                                                         ,null,null,null,null,null,null,null,null,null,null
                                                         ,to_date('21/09/2015','dd/mm/rrrr'),to_date('22/09/2015','dd/mm/rrrr'),null,null,null
                                                         ,null);


*/



select (select reprep_status from MS_REPRESENTATIVE a
where a.repou_code = '000'
  and a.reprep_seq = t.rep_seq) st, t.status, t.*
from mslmst_2 t;


--149504


update mslmst_2 t
set status = (select reprep_status from MS_REPRESENTATIVE a
where a.repou_code = '000'
  and a.reprep_seq = t.rep_seq);
  
  
  
update mslmst_2 t
set statustemp = (select repappt_status from MS_REPRESENTATIVE a
where a.repou_code = '000'
  and a.reprep_seq = t.rep_seq);
  
  
  
select * from mslmst_2 where rep_seq = 8845267;



select reprep_seq REP_SEQ,
reprep_code REP_CODE,
reprep_code_old REP_CODE_OLD,
reprep_name REP_NAME,
repmobile_no MOBILE_NO,
substr(reprep_code,1,4) DIST,
to_number(substr(reprep_code,5,5)) MSLNO,
substr(reprep_code,10,1) CHKDGT,
reprep_status REP_STATUS,
repappt_status APPT_STATUS,
repe_mail E_MAIL,
'D1' DIRECTSALE_STATUS,
null GOLDCLUB,
0 ARBALANCE,
0 BPRBALANCE,
null CRE_DATE,
null CRE_TIME,
null UPD_DATE,
null UPD_TIME
from ms_representative 
where repou_code = '000'
  and reprep_code = '0403176379'
;
  
