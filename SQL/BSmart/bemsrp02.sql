SELECT   rep.repou_code, reploc_code, --dst.dstloc_code,
               rep.repappt_source , reprep_status, 
               dst.dstparent_loc_code, SUBSTR(rep.reprep_code,1,4)||'-'||SUBSTR(rep.reprep_code,5,5)||'-'||SUBSTR(rep.reprep_code,10) reprep_code,
               rep.reprep_name,
               DECODE (rep.repappt_doc_by,'1','Y','N') repappt_doc_by,
               DECODE (rep.repappt_type,'2','Y','N') repappt_type,
               DECODE (rep.repappt_campaign,NULL, NULL,SUBSTR (rep.repappt_campaign, 1, 2)|| '/' || SUBSTR (rep.repappt_campaign, 3, 6)) repappt_campaign
               , dstspecial_status
    FROM ms_representative rep
       , db_sales_location dst
   WHERE rep.repou_code  =  '000'
     AND (rep.repappt_date) =  TO_DATE('10/07/2013','DD/MM/RRRR')
     AND rep.repappt_status <> 'DE'
     AND rep.repou_code = dst.dstou_code
     AND rep.reploc_code = dst.dstloc_code
     AND nvl(dstspecial_status,'0') != '1' 
ORDER BY dstloc_code, SUBSTR(repappt_campaign,3,4), SUBSTR(repappt_campaign,1,2), reprep_code


--page 1 MS,FD,FS   actbrand = '9'
--page 2 MS,FD      actbrand = 'X'
--page 3 FS         actbrand = 'F'

select * from sa_bal_actual
where actcamp = '252013'
  and actbrand = 'F'
  and trunc(actsales_date) between to_date('04/12/2013','dd/mm/rrrr') and to_date('17/12/2013','dd/mm/rrrr')
order by actsales_date
