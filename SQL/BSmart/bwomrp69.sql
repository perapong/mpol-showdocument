SELECT   ohd.ohdou_code ou_code, ohd.ohdupd_rep_code, 
         DECODE(2,NULL,'All',TRIM(ohd.ohdnsm)||' : '||pkgom_master.get_dstloc_desc (ohd.ohdou_code,TRIM(ohd.ohdnsm)))  nsm, 
         ohd.ohddiv div,
         pkgom_master.get_dstloc_desc (ohd.ohdou_code, TRIM(ohd.ohddiv)) div_name,
         --COUNT (DISTINCT DECODE (TRUNC(ohd.ohdtrans_date),TO_DATE ('08/01/2014', 'DD/MM/YYYY'), ohd.ohdtrans_no)) cnt_order,
         NVL ( (DECODE (TRUNC(ohd.ohdtrans_date),TO_DATE ('08/01/2014', 'DD/MM/YYYY'), odt.odttrans_aft_discount)),0) sales,
         --COUNT (DISTINCT ohd.ohdtrans_no) ctd_order,
         NVL ( (odt.odttrans_aft_discount),0) ctd_sales
    FROM om_transaction_hdr ohd,
         om_transaction_dtl odt,
         db_sales_location dst,
         su_param_dtl pad
   WHERE ohd.ohdou_code = dst.dstou_code
     AND ohd.ohdloc_code = dst.dstloc_code
     AND ohd.ohdou_code = odt.odtou_code
     AND ohd.ohdyear = odt.odtyear
     AND ohd.ohdtrans_group = odt.odttrans_group
     AND ohd.ohdtrans_no = odt.odttrans_no
     AND ohd.ohdcancel_date is null
     AND ohd.ohdtrans_group = pad.padentry_code
     AND pad.padparam_id           = 395
     AND ohd.ohdgoldclub_status = '1'
     AND dst.dstspecial_status      = '0'
     AND dst.dstloc_type = 'S'
     AND  pad.padflag1 = '0'    --- direct selling only
     AND TRIM(ohd.ohdnsm) = NVL(2,TRIM(ohd.ohdnsm))
     and ohd.ohddiv = '031'
     AND ohd.ohdou_code = '000'
     AND TRUNC(ohd.ohdtrans_date) BETWEEN TO_DATE ('08/01/2014', 'DD/MM/YYYY') AND TO_DATE ('08/01/2014', 'DD/MM/YYYY') + 0.99999
     AND nvl(ohd.ohddiv, '$') <> '101'
--GROUP BY ohd.ohdou_code, DECODE(2,NULL,'All',TRIM(ohd.ohdnsm)||' : '||pkgom_master.get_dstloc_desc (ohd.ohdou_code,TRIM(ohd.ohdnsm))), ohd.ohddiv
order by ohd.ohddiv




select * from om_transaction_hdr where ohdou_code = '000' and ohdrep_seq = 5074957 and ohdtrans_no = '1100158531'
select * from om_transaction_dtl where odtou_code = '000' and odtyear = 14 and odttrans_no = '1100158531'

