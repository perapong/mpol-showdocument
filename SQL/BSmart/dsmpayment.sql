select 'ALL' loc_code, 'ALL', count(1), sum(tot_rep), sum(tot_amount) from ar_dsm_payment_hdr
where loc_code <> '0999'
union
select loc_code, trans_status, count(1), sum(tot_rep), sum(tot_amount)
from ar_dsm_payment_hdr
where loc_code <> '0999'
  and loc_code in ('8406')
group by loc_code, trans_status
order by loc_code, trans_status

select distinct loc_code, trans_status
from ar_dsm_payment_hdr
where loc_code in ('0015' ,'0144' ,'0822' ,'0340' ,'0568','0457' ,'0139' ,'0193' ,'0155' ,'0591','8158' ,'8535' ,'8123' ,'8352' ,'8637','0101' ,'0130' ,'0164' ,'0172' ,'3835')
--and trans_status = 'CP'
  and loc_code not in ('0015' ,'0139' ,'0155' ,'0340' ,'0568' ,'0822' ,'3835' ,'8123' ,'8352' ,'8535' ,'8637')
order by loc_code;

update ar_dsm_payment_hdr set trans_status = 'AP' where trans_no = '1711004610';
update ar_dsm_payment_dtl set rep_code = '0428156517' where ou_code = '000' and trans_no = '1508042812' and rep_seq = 8461441;

 1803007319
 1803007317

select --to_char(cre_date,'dd/mm/rrrr hh24:mi:ss') d, 
h.* from ar_dsm_payment_hdr h
where ou_code = '000'
  and trans_no like '1804030103%'
--and loc_code = '0428'
--and loc_code in ('0015' ,'0144' ,'0822' ,'0340' ,'0568','0457' ,'0139' ,'0193' ,'0155' ,'0591','8158' ,'8535' ,'8123' ,'8352' ,'8637','0101' ,'0130' ,'0164' ,'0172' ,'3835')
--and trans_status = 'AP'
order by cre_date desc, trans_no;

select dt.* 
from ar_dsm_payment_dtl dt
--delete from ar_dsm_payment_dtl 
where trans_no like '1804030103%'
--and cre_date = to_date('07/10/2015 10:55:51','dd/mm/rrrr hh24:mi:ss')
order by trans_no desc, rep_code;


select to_char(cre_date,'dd/mm/rrrr hh24:mi:ss') d, i.* 
from ar_dsm_payment_info i
where ou_code = '000'
  and trans_no like '18040421%'
order by cre_date desc,trans_no desc;

--update ar_dsm_payment_info set pay_amount = 683.1 where  ou_code = '000' and trans_no = '1708152824';
Insert into ar_dsm_payment_info (OU_CODE,TRANS_NO,PAY_SEQ,PAY_TYPE,BW_BANK_CODE,BW_BANK_BRANCH,BW_BANK_ACCT,PAY_REF_NO,PAY_DATE,PAY_AMOUNT,CRE_BY,CRE_DATE,PROG_ID,UPD_BY,UPD_DATE) 
values ('000','1803007317',1,'O',null,null,'KBANK',null,null,430.2,'0073',to_date('12/03/2017 11:39:11','DD/MM/RRRR HH24:MI:SS'),null,null,null);
update ar_dsm_payment_hdr set trans_status = 'AP', approve_date = to_date('12/03/2017 11:39:11','DD/MM/RRRR HH24:MI:SS') where trans_no = '1803007317';


/*
delete from ar_dsm_payment_hdr h where ou_code = '000' and trans_no like '18030999%';
delete from ar_dsm_payment_dtl h where ou_code = '000' and trans_no like '18030999%';
delete from ar_dsm_payment_info h where ou_code = '000' and trans_no like '18030999%';
*/

     
SELECT 'P' || to_char(sysdate,'rrmm') || nvl(lpad(max(to_number(substr(trans_no,6,5))) + 1,5,'0'),'00001') MAXTRAN 
FROM bwprod.ar_dsm_payment_hdr WHERE ou_code = '000' and trans_no like 'P' || to_char(sysdate,'rrmm') || '%'


INSERT INTO bwprod.ar_dsm_payment_hdr (ou_code, trans_no, trans_date, loc_code, tot_rep, tot_amount, trans_status, manager_name, cre_by, cre_date) 
SELECT ou_code, 'P141000045' trans_no, trunc(sysdate) trans_date, loc_code, tot_rep, tot_amount,  trans_status, manager_name, cre_by, sysdate cre_date 
FROM bwprod.ar_dsm_payment_hdr WHERE ou_code = '000' and trans_no = 'P141000030' and loc_code = '0167' and trans_status = 'RJ' 
INSERT INTO bwprod.ar_dsm_payment_dtl (ou_code, trans_no, rep_seq, rep_code, rep_name, pay_amount, cre_by, cre_date) 
SELECT ou_code, 'P141000045' trans_no, rep_seq, rep_code, rep_name, pay_amount, cre_by, sysdate cre_date 
FROM bwprod.ar_dsm_payment_dtl WHERE ou_code = '000' and trans_no = 'P141000030' 


SELECT pkgbw_misc.getxrepformat(rep_code) rep_codee FROM bwprod.ar_dsm_payment_dtl WHERE ou_code = '000' and trans_no = 'P141000013' 

/*
--insert into ar_dsm_payment_dtl
select '000' ou_code, 'P141000011' trans_no, reprep_seq rep_seq, reprep_code rep_code, reprep_name rep_name, rownum*10 pay_amount,
       ref_rchreceipt_type, ref_rchreceipt_no, reploc_code cre_by, sysdate cre_date,
       prog_id, upd_by, upd_date 
from ar_dsm_payment_dtl a, ms_representative b
where trans_no like 'P1410%'
  and rep_seq = 379187
  and repou_code = '000'
  and reprep_code like '0266%'
  and repappt_status <> 'DE'
  and rownum < 51
order by 2
*/


INSERT INTO ar_dsm_payment_dtl 
VALUES('000','P141000013',965297,'0167108332','¤Ø³ÍÓä¾ ¾ÅàÂèÕÂÁ',103,NULL,NULL,'0167',TO_DATE('2014-10-03 16:43:12', 'YYYY-MM-DD HH24:MI:SS'),NULL,NULL,NULL);


SELECT to_date(TRANS_DATE,'dd/mm/rrrr') TRANSDATE
, (SELECT SUM(pay_amount) FROM bwprod.ar_dsm_payment_dtl  b WHERE b.trans_no = a.trans_no) TOTAMT
, (SELECT SUM(pay_amount) FROM bwprod.ar_dsm_payment_info b WHERE b.trans_no = a.trans_no) TOTPAY
, a.* FROM bwprod.ar_dsm_payment_hdr a WHERE ou_code = '000'
  and loc_code = '0361'
  and trans_no = '1606036102'
order by trans_no



select mailgroup, nsm, divcode, loc_code from bev$_mailplan
where mplou_code = '000'
  and mplyear = 2014
  and campaign = 201422
  and loc_code in ('0015','0144','0822','0340','0568','0457','0139','0193','0155','0591','8158','8535','8123','8352','8637','0101','0130','0164','0172','3835')
order by 1,2,3,4;


select a.*, (select ms.reprep_name from ms_representative ms where ms.repou_code = '000' and ms.reprep_seq = a.rep_seq) name from ar_dsm_payment_dtl a
--update ar_dsm_payment_dtl a set rep_name = (select ms.reprep_name from ms_representative ms where ms.repou_code = '000' and ms.reprep_seq = a.rep_seq)
--update ar_dsm_payment_dtl a set rep_code = (select ms.reprep_code from ms_representative ms where ms.repou_code = '000' and ms.reprep_seq = a.rep_seq)
where trans_no like '160603610%'
and rownum < 51;


update ar_dsm_payment_dtl a set trans_no = '1606036108'
where trans_no like '1606036102%'
and rownum < 51;

select * from ar_dsm_payment_dtl a
where trans_no like '1606036102'
order by trans_no;


update ar_dsm_payment_hdr a 
   set tot_rep = (select count(*) from ar_dsm_payment_dtl a where trans_no = a.trans_no)
     , tot_amount = (select sum(pay_amount) from ar_dsm_payment_dtl a where trans_no = a.trans_no)
where trans_no like '160603610%';

INSERT INTO bwprod.ar_dsm_payment_hdr (ou_code, trans_no, trans_date, loc_code, tot_rep, tot_amount, trans_status, manager_name, cre_by, cre_date) 
SELECT ou_code, '1606036108' trans_no, trans_date, loc_code
     , (select count(*) from ar_dsm_payment_dtl a where trans_no like '1606036108') tot_rep
     , (select sum(pay_amount) from ar_dsm_payment_dtl a where trans_no like '1606036108') tot_amount,  trans_status, manager_name, cre_by, cre_date 
FROM bwprod.ar_dsm_payment_hdr WHERE ou_code = '000' and trans_no = '1606036102' and loc_code = '0361' and trans_status = 'AP' ;


select * from AR_DSM_PAYMENT_INFO
where ou_code = '000'
  and trans_no like '1606036102%';
  

Insert into AR_DSM_PAYMENT_INFO (OU_CODE,TRANS_NO,PAY_SEQ,PAY_TYPE,BW_BANK_CODE,BW_BANK_BRANCH,BW_BANK_ACCT,PAY_REF_NO,PAY_DATE,PAY_AMOUNT,CRE_BY,CRE_DATE,PROG_ID,UPD_BY,UPD_DATE) 
values ('000','1606036108',1,'T','004','0735','TFB#8314',null,to_date('06 ÁÔ.Â. 2016','DD MON RRRR'),340723,'0361',to_date('06 ÁÔ.Â. 2016','DD MON RRRR'),null,null,null);


select * from AR_DSM_PAYMENT_dtl