1. Summary  Award

CREATE TABLE ZMAI01_9A9B_262012 AS
SELECT optpoint_campaign campaign,
       optpoint_prog_ref prog_ref,     
       optpnt_type,
       px.optupd_rep_code  rep_code,
       px.optrefer_trans_year trans_year,
       px.optrefer_trans_group trans_group,
       px.optrefer_trans_no tran_no,
       sum(optgross_sales) optgross_sales , 
       SUM(optnet_sales)  optnet_sales 
  FROM om_transaction_pnt PX
where optou_code ='000'
  and optpoint_campaign ='262012'
  and optrefer_trans_group ='11'
  and optpoint_prog_ref IN ('9A','9B','9C','9D')
  and optpnt_type iN ('A','V')
  and optpnt_type !='C'
Group by  optpoint_campaign  ,optpoint_prog_ref  ,optpnt_type,px.optupd_rep_code   ,px.optrefer_trans_year  ,px.optrefer_trans_group  ,px.optrefer_trans_no ;


-------
2. : Export data to Excel & Check data

SELECT campaign, rep_code, prog_ref, optpnt_type,
        sum(netmis) netmis, sum(netfri)netfri  
  FROM ZMAI01_9A9B_262012
where  campaign ='262012'
 group by campaign, prog_ref,optpnt_type,rep_code
 
3.  Manual Check data
 
	Import data to : BW_AWARD9A_REP

4.  Execute Script
 
  
Insert into  bw_award9a_rep (rep_code, campaign, prog_ref, optpnt_type, trans_year, trans_group, invoice_no,prn_rep, gross_amt,net_amt)       
  
SELECT rep_code, campaign, prog_ref, optpnt_type,  trans_year, trans_group, tran_no invoice_no, 'REP' prn_rep ,
         sum(optgross_sales) gross_amt ,
         sum(optnet_sales)  net_amt
  FROM zmai01_9a9b_262012 zx 
where  exists (select rep_code  FROM bw_award9a_rep tx   where tx.rep_code = zx.rep_code)
group by  campaign, prog_ref, optpnt_type, rep_code, trans_year, trans_group, tran_no;


5.  Print report : BEBWRP07
   Menu :
       >>Better way program
	      >> Report
			>>>  Bonus gold reward 26  (C7-C10)
 



