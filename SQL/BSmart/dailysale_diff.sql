select * from sa_bal_actual
where actou_code = '000'
  and actsales_date between to_date('11/06/2014','dd/mm/rrrr') and to_date('12/06/2014','dd/mm/rrrr')
--and actcamp
--and actbrand = '9'
order by actsales_date  
  
  
  
select 
--sum(recbeg_rep_count), sum(recbeg_appt_count_nr), sum(recbeg_appt_count_re), sum(recbeg_appt_count_to), sum(recbeg_appt_count_ti), sum(recbeg_appt_count_de), sum(recbeg_appt_count_ri)
a.* 
from ms_count_rep a , db_sales_location d
where recou_code = '000'
  and recas_of_date >= to_date('10/07/2013','dd/mm/rrrr')
and recloc_code = '0089'
  and recou_code = dstou_code
  and recloc_code = dstloc_code
  and d.dstspecial_status = 0
  
  
select * from ms_count_rep where recou_code = '000'
  and recas_of_date >= to_date('09/06/2014','dd/mm/rrrr')
and recloc_code = '8226'

  

select *
              FROM MS_COUNT_REP TT 
              WHERE TT.RECOU_CODE = '000'
              and   TT.RECAS_OF_DATE BETWEEN TO_DATE('10/05/2014','DD/MM/YYYY')
                                     AND     TO_DATE('14/06/2014','DD/MM/YYYY')+ 1-1/(24*60*60)
              AND   recloc_code = '8226'
              ORDER BY RECLOC_CODE, RECAS_OF_DATE
