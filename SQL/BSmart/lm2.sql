select pkgbw_misc.getxnsmcode(adadistrict_code) nsm
     , adadivision_code
     , adadistrict_code
     , (select distinct loc_master from bw_riloc_area where loc_code = adadistrict_code) loc_master
     , adaprogram_code
     , adaref_date
     , ttl_lead
     , ttl_lead - cnt_dist not_assign
     , cnt_dist cnt_have_dist
     , (cnt_success1 + cnt_success2 + cnt_success3) cnt_appoint
     , cnt_success1
     , cnt_success2
     , cnt_success3
     , cnt_notpass
     , cnt_notappt
     , cnt_wait
     , cnt_other
from (
        select b.adadivision_code
             , b.adadistrict_code
             , b.adaprogram_code
             , b.adaref_date
             , count(*) ttl_lead
             , sum(cnt_dist) cnt_dist
             , sum(cnt_success1) cnt_success1
             , sum(cnt_success2) cnt_success2
             , sum(cnt_success3) cnt_success3
             , sum(cnt_notpass) cnt_notpass
             , sum(cnt_notappt) cnt_notappt
             , sum(cnt_wait) cnt_wait
             , sum(cnt_other) cnt_other
        from (
                select a.adadivision_code
                     , a.adaprogram_code
                     , a.adaref_date
                     , a.adadistrict_code
                     , case when adadistrict_code is not null then 1 else 0 end cnt_dist
                     --, case when adadistrict_code is not null and adaprint_status = 1 then 1 else 0 end cnt_new
                     , case when log_code = 2 then 1 else 0 end cnt_success1
                     , case when log_code = 4 then 1 else 0 end cnt_success2
                     , case when log_code = 5 then 1 else 0 end cnt_success3
                     , case when (log_code = 1 or log_code = 3) then 1 else 0 end cnt_wait
                     , case when log_code = 6 then 1 else 0 end cnt_notpass
                     , case when log_code = 7 then 1 else 0 end cnt_notappt
                     , case when nvl(log_code,9) > 7 then 1 else 0 end cnt_other 
                from (select b.*, pkgbw_lmsmart.Get_LastLogStatus(adaou_code, adaref_no) log_code from ms_advertise_appointment b) a
                where adaou_code = '000'
                  and adayear = 2013
                  and adaref_date between to_date('01/01/2013','dd/mm/rrrr') and sysdate
                and adaprogram_code = '203'
             ) b
        group by b.adadivision_code, b.adadistrict_code
        , b.adaprogram_code, b.adaref_date
     )
order by 1, adadivision_code, adadistrict_code, adaprogram_code, adaref_date
/*and adadistrict_code in ('0519','0520','0521','0522','0594','0595','0596','0597')*/
  

  
select *
from ms_advertise_appointment 
where adaou_code = '000'
  and adayear = 2014
  and adaref_date >= to_date('01/05/2013','dd/mm/rrrr')
  and adadistrict_code = '1279'
order by adacre_date desc


/***************************************************************************************************************************************************************
                                                                            check not have district
***************************************************************************************************************************************************************/

select l.adaref_no,
           l.adafname,
           l.adalname,
           l.adaadd1,
           l.adaadd2,
           l.adaadd3,
           t.tbntumbon_lname tumbon,
           a.ampamphur_lname amphur,
           p.prvprovince_lname province
           , adaref_date
from ms_advertise_appointment l
   , db_province p
   , db_amphur a
   , db_tumbon t
where adaou_code = '000'
  and adayear = 2014
  and adaref_date between trunc(sysdate)-5 and sysdate-1
  and adadistrict_code is null
  AND l.adaou_code = p.prvou_code(+)
  AND l.adaprvoince_code = p.prvprovince_code(+)
  AND l.adaou_code = a.ampou_code(+)
  AND l.adaamphur_code = a.ampamphur_code(+)
  AND l.adaou_code = t.tbnou_code(+)
  AND l.adatumbon_code = t.tbntumbon_code(+)
order by province, amphur, tumbon, adaref_no


/***************************************************************************************************************************************************************
                                                                            check balance district
***************************************************************************************************************************************************************/

select dstloc_name, a.loc_master, pkgbw_misc.getxnsmcode(dstloc_code) nsm, dstparent_loc_code, dstloc_code, d.dstmgr_empid, dstmgr_name, d.dstmgr_eff_sdate
     , (select count(*) from ms_advertise_appointment where adaou_code = '000' 
            and adayear >= 2014 
            and adaprogram_code = '104' 
            and adaref_date >= to_date('01/01/2013','dd/mm/rrrr')
            and adadistrict_code = dstloc_code) cnt
from db_sales_location d, ( select distinct loc_code, loc_master from bw_riloc_area ) a
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstinactive_status = 0
        and d.dstloc_code = a.loc_code
      --and dstparent_loc_code between '001' and '033'
        and dstsales_group in ('00','11','22')
        and dstloc_name not like 'Indep%'
        and dstloc_code <> '0900'
      --and dstloc_code not like '8%'
      --and dstloc_code in (select dstloc_code from db_sales_location where dstou_code = '000' and dstloc_name like '%130%')
      --and dstloc_code in ('8142','8144','8146')
        and loc_master = '0133'
order by a.loc_master, dstloc_name, dstloc_code

--------------------------------------------------------
--------------------------------------------------------

select dstloc_name, d.dstloc_province, pkgbw_misc.getxnsmcode(dstloc_code) nsm, dstparent_loc_code, dstloc_code, d.dstmgr_empid, dstmgr_name, d.dstmgr_eff_sdate
     , (select count(*) from ms_advertise_appointment where adaou_code = '000' and adayear >= 2013 
           and adaprogram_code = '103' and adaref_date >= to_date('01/01/2013','dd/mm/rrrr')
                                      and adadistrict_code = dstloc_code) cnt
from db_sales_location d
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstinactive_status = 0
        and d.dstloc_name = 'จ.เพชรบุรี'
        and dstsales_group in ('00','11','22')
        and dstloc_name not like 'Indep%'
        and dstloc_code <> '0900'
order by 2, dstloc_name, dstloc_code

--------------------------------------------------------
--------------------------------------------------------

select *
from ms_advertise_appointment l, ( select distinct loc_code, loc_master from bw_riloc_area ) a
where adaou_code = '000' and adayear >= '2013' 
and adaprogram_code = '204' 
and adadistrict_code is not null
and l.adadistrict_code = a.loc_code
and a.loc_master = '0109'
order by adaupd_by, adacre_date desc



select * from db_sales_location where dstou_code = '000'
--and dstloc_name like '%130%'
and dstloc_code in ('0519','0522','0595','0594')

select distinct loc_code from bw_riloc_area where province in ('02','24','28','59','60','61') --loc_code in ('8142','0144','0133','0132') or 
and loc_master is null 
--= '0133'

select *
from ms_advertise_appointment
where adaou_code = '000'
  and adayear >= 2013
  and adaprogram_code = '204'
  and adadistrict_code = '0184'
  and adadistrict_code in ('0060','0127','0128','0147','0160','0169')
--and adadistrict_code in (select distinct loc_code from bw_riloc_area where loc_master = '0127')
--and adaref_date >= to_date('09/01/2013','dd/mm/rrrr')
--and adaref_no in ('2031300004614','2021300000835','2021300001053')
--and adafname = 'ศิริพร'
--and adalname like '%เจริญ'
--and adaprvoince_code in ('60','61')
--and adaprvoince_code in (select dstloc_code from db_sales_location where dstou_code = '000' and dstloc_name ='สุขุมวิท 77-103 บางจาก 0131')
--and adadistrict_code is null
order by adacre_date desc, adadistrict_code
  
/*
2031300004614
2021300000835
2021300001053
*/
  
  
select dstloc_name, a.loc_master, dstparent_loc_code, dstloc_code, dstmgr_name, d.dstmgr_eff_sdate
     , (select count(*) from ms_advertise_appointment where adaou_code = '000' and adayear = 2013 
           and adaprogram_code = '204' and adaref_date >= to_date('01/01/2013','dd/mm/rrrr')
                                      and adadistrict_code = dstloc_code) cnt
from db_sales_location d, ( select distinct loc_code, loc_master from bw_riloc_area ) a
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstinactive_status = 0
        and d.dstloc_code = a.loc_code
        and dstparent_loc_code between '001' and '033'
        and dstloc_name not like 'Indep%'
        and dstloc_code <> '0900'
        and dstloc_code not like '8%'
      --and dstloc_code in ('0519','0520','0521','0522','0594','0595','0596','0597')
        and loc_master = '0139'
order by a.loc_master, dstloc_name, dstloc_code

select * from bw_riloc_area where loc_code in ('0921','0922')

select *
from ms_advertise_appointment
where adaou_code = '000'
  and adayear = 2014
  and adaprogram_code = '103'
  and adadistrict_code like '8%'
--and adadistrict_code in (select distinct loc_code from bw_riloc_area where loc_master = '0127')
  and adaref_date >= to_date('01/01/2014','dd/mm/rrrr')
  and adaprvoince_code not in ('02','24','28','59','60','61')
--and adadistrict_code is null
order by adadistrict_code

select count(*), adaprvoince_code
from ms_advertise_appointment
where adaou_code = '000'
  and adayear = 2014
  and adaprogram_code = '103'
  and adadistrict_code is not null
group by adaprvoince_code

select * 
from db_sales_location a
where dstou_code = '000'
  and dstloc_type = 'S'
  and dstloc_name like '%สีมา%'
order by dstloc_code

create table zp_bck_advertise_appointment as
select * from ms_advertise_appointment 
where adaou_code = '000' and adayear = 2013 
  and adaprogram_code = '203' and adaref_date >= to_date('09/01/2013','dd/mm/rrrr')
--select * from zp_bck_advertise_appointment

create table zp_bck_advertise_appointment2 as
delete from zp_bck_advertise_appointment2
insert into zp_bck_advertise_appointment2
select * from ms_advertise_appointment a
where adaou_code = '000' and adayear = 2013 
  and adaprogram_code = '203' and adaref_date >= to_date('09/01/2013','dd/mm/rrrr')
--and adadistrict_code in ('0015','0018','0021','0024','0032','0025','0010','0017','0046','0022','0023','0006','0007')
  and adadistrict_code in ('0115')
  and not exists (select 1 from ms_advertise_bwlmlog where ou_code = a.adaou_code and ref_no = a.adaref_no and log_code <> 1)
  
declare
    cursor rec is
        select * from zp_bck_advertise_appointment2;
BEGIN
    For Trec In Rec Loop
        Begin 
            update ms_advertise_appointment
               set adadistrict_code = null
                 , adadivision_code = null
             where adaref_no = Trec.adaref_no;
            Exception when no_data_found Then Begin null; End;
        End;
    End Loop;
END;

select * from ms_advertise_appointment a
--where exists (select adaref_no from zp_bck_advertise_appointment2 t where a.adaref_no = t.adaref_no )
where adaou_code = '000'
  and exists (select loc_code from bw_riloc_area where loc_code = adadistrict_code and loc_master = '0127')
  

--check bw_riloc_area-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
select count(*) cnt, loc_code from (select distinct loc_master, loc_code from bw_riloc_area) group by loc_code having count(*) > 1

select * from bw_riloc_area
where loc_code in ('0184','0024','0182','0957','1277','0128','0057') order by loc_code, province

select * from (
select (select distinct min(province) from bw_riloc_area t where t.loc_code = a.dstloc_code) province,
a.* 
from db_sales_location a
where dstou_code = '000'
  and dstloc_code not like '8%'
  and dstloc_type = 'S'
--  and dstloc_name like 'จ.%'
order by dstloc_code
) where province is null

select * from db_province  

SELECT * FROM log_db_sales_location WHERE ldstloc_code = '1279'




select * from ms_advertise_appointment 
--update ms_advertise_appointment set adaprint_status = 0
where adaou_code = '000' 
--and adayear = 2013 
and adaprogram_code = '204' 
and adadistrict_code is null and trunc(adacre_date) = trunc(sysdate) and adaprint_status = 1


--  Reverse District Assigned -----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
select * from ms_advertise_appointment a
--update ms_advertise_appointment a set adadistrict_code = null, adadivision_code = null
where adaou_code = '000' 
  and adayear = 2014 
--and adaprogram_code = '204' 
  and adadistrict_code = '0162'
  and adarep_seq is null
  and not exists (select * from ms_advertise_bwlmlog t where t.ou_code = a.adaou_code and t.ref_no = a.adaref_no and t.log_code > 1)


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

select * from ms_rproject_setup where rpsprogram_code = '204'


select * from ms_advertise_bwlmlog t where t.ou_code = '000' and t.ref_no = '1041400031881'
