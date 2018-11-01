--nvl((SELECT distinct 'Appointment' FROM ms_advertise_bwlmlog l WHERE ou_code = '000' and adaref_no = ref_no and log_code in (4,5)),'No Appointment') Appt
--, case when (adaprvoince_code in ('02','24','28','59','60','61')) then 'Bangkok' else 'other' end bangkok
select count(*)
from ms_advertise_appointment ll
where adaou_code = '000' and adayear = '2016' 
and adaprogram_code = '401' 
and adaprvoince_code not in ('02','24','28','59','60','61')
and exists (SELECT 1 FROM ms_advertise_bwlmlog l WHERE ou_code = '000' and adaref_no = ref_no and log_code in (4,5))
order by adacre_date desc
;

select *
from ms_advertise_appointment ll
--delete from ms_advertise_appointment ll
where adaou_code = '000' and adayear = '2018' 
--and adaref_no = '5011700017842'
--and adaprogram_code = '503' 
--and adacre_date between to_date('09/09/2013 00:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('10/09/2013 17:00:00','dd/mm/rrrr hh24:mi:ss')
and adacre_date >= trunc(sysdate) - 1
--and adadistrict_code is null
--and adadistrict_code = '0013' 
and adaprvoince_code not in ('02','24','28','59','60','61')
--and adaref_no = '1021300008976'
--and not exists (SELECT * FROM ms_advertise_bwlmlog l WHERE ou_code = '000' and adaref_no = ref_no and log_code = 1)
--and adafname like '%'
--and adalname like '%'
--and adamobile_no = '0854580105'
and adaprint_status <> 1
order by adacre_date desc
;

select *
from ms_advertise_bwlmlog
where ou_code = '000' 
  and ref_no like '5011700041638%' 
  and cre_by = '0013'
;

select * from MS_RPROJECT_WEB_INTERFACE where ref_seq >= 5207308 order by ref_seq desc;

INSERT INTO bwprod.ms_advertise_bwlmlog (ou_code, ref_no, log_code, log_text, log_status, rep_code, lm_remark, cre_by, cre_date)
VALUES ('000','9001600033225','3',null,1,'','ทดสอบ','8400',sysdate)
;

/* Generate District to Transaction */
pr_gen_dist(trim(:ms_advertise_appointment.adaprogram_code), '000',
                                     :ms_advertise_appointment.adaprvoince_code,
                                     v_prov_group, 
                                     TO_NUMBER(TO_CHAR(:MS_ADVERTISE_APPOINTMENT.ADAREF_DATE,'YYYY')),
                                     v_dist_code,
                                     v_div_code
                                     );

select * from zp_tmp_lm
select * from bckdata.ms_advertise_appointment1
       
SELECT ou_code, ref_no, log_code, log_text, log_status, cre_by, cre_date
FROM ms_advertise_bwlmlog
where ref_no = '2031300002411'


select l.adaref_no, l.adafname, l.adalname, l.adanick_name, l.adagender, l.adamobile_no , l.adaadd1, l.adaadd2, l.adaadd3
, t.tbntumbon_lname tumbon, a.ampamphur_lname amphur, p.prvprovince_lname province
, l.adapostal_code , l.adaref_date, l.adarep_code, l.apply_date, l.appoint_date 
from (select ll.*
        , (select max(cre_date) from ms_advertise_log where ou_code = ll.adaou_code and ref_no = ll.adaref_no and log_code = 1) apply_date 
        , (select max(cre_date) from ms_advertise_log where ou_code = ll.adaou_code and ref_no = ll.adaref_no and log_code = 2) appoint_date 
      from ms_advertise_appointment ll) l
      , db_province p, db_amphur a, db_tumbon t 
where adaou_code = '000' 
and adayear = '2013' 
--and adaprogram_code = '302' 
--and adadistrict_code = '8377' 
--and adaref_no = '2031300000036'
and l.adaou_code = p.prvou_code(+) 
and l.adaprvoince_code = p.prvprovince_code(+) 
and l.adaou_code = a.ampou_code(+) 
and l.adaamphur_code = a.ampamphur_code(+) 
and l.adaou_code = t.tbnou_code(+) 
and l.adatumbon_code = t.tbntumbon_code(+) 
order by adaref_date



select /*+ First_rows(5) */ px.*
   from ms_advertise_appointment  px
where adaou_code = '000'
  and adayear = '2013' 
  and adaprogram_code = '203' 
  and adadistrict_code in ('0179','0177','0199','0115','0027','0016','0058','0118')
  and adadistrict_code = '0115'
order by adaupd_date desc

select * 
from ms_advertise_bwlmlog
where ref_no in ('1021300000141')
order by cre_date
 
select * from db_sales_location
where dstou_code = '000' and dstloc_code is not null 
and dstloc_type = 'D' and dstparent_loc_code = 3 dstloc_code = '001'


select * 
from ms_advertise_appointment ad 
where adaou_code = '000' 
  and adayear = '2013'
  and adaprogram_code = '102'
--  and adaprvoince_code = '06'
  and adadistrict_code = '0694'
--and adafname like 'สำลี%'
--and adaprint_status = 1
  and adaref_no in ('2031300003195')
  
  
SELECT  * FROM ms_advertise_bwlmlog
WHERE ou_code = '000'
  AND ref_no = '1021300003416'
--and log_code = 1
order by cre_date desc

/*********   list info 
*********/

  SELECT   l.adaref_no,
           l.adadistrict_code,
           l.adafname,
           l.adalname,
           l.adanick_name,
           l.adagender,
           l.adamobile_no,
           l.adaadd1,
           l.adaadd2,
           l.adaadd3,
           t.tbntumbon_lname tumbon,
           a.ampamphur_lname amphur,
           p.prvprovince_lname province,
           l.adapostal_code,
           l.adaref_date,
           l.adarep_code,
           l.apply_date,
           l.appoint_date,
           l.appoint_date,
           l.log_code,
           DECODE (log_code,'1','ส่งลีด','2','ดำเนินการแต่งตั้ง','3','ส่งข้อมูลแต่งตั้ง','4','แต่งตั้งตรงคน','5','แต่งตั้งไม่ตรงคน','6','แต่งตั้งไม่ผ่าน','7','ไม่แต่งตั้ง') log_desc
    FROM   (SELECT   ll.*,
                     (SELECT   distinct MAX (cre_date)
                        FROM   ms_advertise_bwlmlog
                       WHERE       ou_code = ll.adaou_code
                               AND ref_no = ll.adaref_no
                               AND log_code = 1)
                         apply_date,
                     (SELECT   distinct MAX (cre_date)
                        FROM   ms_advertise_bwlmlog
                       WHERE       ou_code = ll.adaou_code
                               AND ref_no = ll.adaref_no
                               AND log_code IN (4, 5))
                         appoint_date,
                     (SELECT   distinct MAX (log_code)
                        FROM   ms_advertise_bwlmlog a
                       WHERE   a.ou_code = ll.adaou_code
                               AND a.ref_no = ll.adaref_no
                               AND cre_date =
                                      (SELECT   distinct MAX (cre_date)
                                         FROM   ms_advertise_bwlmlog t
                                        WHERE   t.ou_code = a.ou_code
                                                AND t.ref_no = a.ref_no))
                         log_code
              FROM   ms_advertise_appointment ll
             WHERE   adadistrict_code IS NOT NULL) l,
           db_province p,
           db_amphur a,
           db_tumbon t
   WHERE       adaou_code = '000'
           AND adayear IN ('2012', '2013')
           AND adaprogram_code = '203'
           AND adaref_date >= TO_DATE ('01/12/2012', 'dd/mm/rrrr')
           AND adadistrict_code = '0196'
           AND l.adaou_code = p.prvou_code(+)
           AND l.adaprvoince_code = p.prvprovince_code(+)
           AND l.adaou_code = a.ampou_code(+)
           AND l.adaamphur_code = a.ampamphur_code(+)
           AND l.adaou_code = t.tbnou_code(+)
           AND l.adatumbon_code = t.tbntumbon_code(+)
ORDER BY   adadistrict_code, adaref_date DESC

/*********   report
*********/
select division, district, count(*) lm_ttl
                     , sum(decode(log_code,1,1,0)) lm_new
                     , sum(decode(log_code,2,1,0)) lm_apply
                     , sum(decode(log_code,3,1,0)) lm_appoint
                     , sum(decode(log_code,4,1,0)) lm_match
                     , sum(decode(log_code,5,1,0)) lm_notmatch
                     , sum(decode(log_code,6,1,0)) lm_notpass
                     , sum(decode(log_code,7,1,0)) lm_notappt 
from (  select adadivision_code division, adadistrict_code district, pkgbw_lmsmart.Get_LastLogStatus(adaou_code, adaref_no) log_code
        from ms_advertise_appointment ad 
         --, (select dstloc_code from db_sales_location where dstou_code = '000' and dstloc_code is not null and dstloc_type = 'D' and dstparent_loc_code = ".substr($div,3,1).") dst ";
        where adaou_code = '000' 
          and adayear in ('2012','2013')
          and adadistrict_code is not null
          and adaprogram_code = '203'
          and adaprint_status = 1
          and adadistrict_code is not null
       -- and adadivision_code = dst.dstloc_code ";
       -- and adadivision_code = '$div' ";
     )
group by division, district 
order by division, district

select 
(select count(*)
from ms_advertise_appointment ad 
where adaou_code = '000' 
  and adayear in ('2012','2013')
  and adaprogram_code = '203'
) total,
(select count(*)
from ms_advertise_appointment ad 
where adaou_code = '000' 
  and adayear in ('2012','2013')
  and adaprogram_code = '203'
  and adadistrict_code is not null
) haveloc, 
(select count(*) 
from ms_advertise_appointment ad 
where adaou_code = '000' 
  and adayear in ('2012','2013')
  and adaprogram_code = '203'
  and adadistrict_code is not null
  and adaprint_status = 1
) new
from dual



/************************* LM Create Log Code 1 **************************************************************************************************/

declare
    cursor rec is
    select * from bwprod.ms_advertise_appointment a
    where adacre_date between to_date('09/04/2013','dd/mm/rrrr') and sysdate
      and adadistrict_code is not null
      and not exists ( SELECT 1 FROM bwprod.ms_advertise_bwlmlog
                        WHERE ou_code = '000'
                          AND ref_no = a.adaref_no 
                          and log_code = 1)
    ;
 
    vTmp  VARCHAR2(10);
BEGIN
   
    For Trec In Rec Loop
        Begin 
            insert into bwprod.ms_advertise_bwlmlog (ou_code, ref_no, log_code, log_status, cre_by, cre_date)
            values ('000', Trec.adaref_no, 1, 1, Trec.adadistrict_code, Trec.adacre_date)
              ;
              
            Exception  when Others Then Begin   dbms_output.put_line('error '||Trec.adaref_no);  End;
        End;
    End Loop;
  
END;




declare
    cursor rec is
    select * from bwprod.ms_advertise_bwlmlog a
    where ou_code = '000'
    --and ref_no like '102%'
      and log_code = 1
      and cre_date between to_date('01/01/2013','dd/mm/rrrr') and sysdate
      and exists ( SELECT 1 FROM bwprod.ms_advertise_bwlmlog t
                        WHERE t.ou_code = '000'
                          AND t.ref_no = a.ref_no 
                          and t.log_code <> 1
                          and t.cre_date < a.cre_date)
    ;
BEGIN
    For Trec In Rec Loop
        Begin 
            delete bwprod.ms_advertise_bwlmlog 
            where ou_code = Trec.ou_code
              and ref_no = Trec.ref_no
              and log_code = 1
              and cre_date = Trec.cre_date
              ;
        End;
    End Loop;
END;

/*


select * from ms_advertise_appointment where adaref_no = '1091300000075'


select * from db_sales_location where dstloc_code in ('1641')


select * from ms_advertise_bwlmlog a
where ou_code = '000'
--and ref_no = '1091300000013'
  and log_code = 2
and ref_no in (select ref_no from (select ref_no, count(*), log_code from ms_advertise_bwlmlog where log_code = 2 group by ou_code, ref_no, log_code having count(*)>1))
--and cre_by is null
order by ref_no, cre_date




  and exists (select 1 from ms_advertise_bwlmlog t where ou_code = '000'
              and t.ref_no = a.ref_no
              and t.log_code = 1
              and t.cre_by is not null)


select ref_no, count(*), log_code from ms_advertise_bwlmlog where ref_no = '2021300000263' group by ou_code, ref_no, log_code having count(*)>1

select ref_no, * from ms_advertise_bwlmlog where ref_no = '2021300000263'


select * from ms_advertise_bwlmlog where ou_code = '000' and ref_no = '2031300000362' and cre_date = (select max(cre_date) from ms_advertise_bwlmlog t where t.ou_code = '000' and t.ref_no = '2031300000362')

select * 
from ms_advertise_appointment
where adaref_date >= to_date('07/01/2013','dd/mm/rrrr')
  and adaref_no = '2031300004112'
order by adaupd_date desc




select * from ms_advertise_bwlmlog where log_code = 1 and trunc(cre_date) = trunc(sysdate)  order by cre_date desc


select * from ms_advertise_bwlmlog where log_code <> 1
and exists (  
select * from ms_advertise_appointment 
where adadistrict_code is not null
  and adaupd_by = 'GG'
  and adacre_date >= to_date('09/01/2012','dd/mm/rrrr')
  and exists (select dstloc_code 
        from db_sales_location 
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstloc_code = adadistrict_code
        and dstinactive_status = 0
        and dstmgr_name is null)
  and adaref_no = ref_no
)
        

select * 
        from db_sales_location 
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstloc_code = '0082'
        and dstinactive_status = 0
        and dstmgr_name is null
        

update ms_advertise_appointment 
set adadistrict_code = null, adadivision_code = null
where adadistrict_code is not null
  and adaupd_by = 'GG'
  and adacre_date >= to_date('09/01/2012','dd/mm/rrrr')
  and exists (select dstloc_code 
        from db_sales_location 
        where dstou_code = '000'
        and dstloc_type = 'S'
        and dstloc_code = adadistrict_code
        and dstinactive_status = 0
        and dstmgr_name is null)

--and adadistrict_code in ('0519','0520','0521','0522','0594','0595','0596','0597')





/*    Manternance LM Log   */

--insert into ms_advertise_bwlmlog                      
SELECT adaou_code ou_code, adaref_no ref_no, 1 log_code, 'apply' log_text, 1 log_status, adacre_by cre_by,
       adacre_date cre_date, null rep_code, null lm_remark
 FROM ms_advertise_appointment ad 
where adaou_code = '000' 
  and adayear = '2013'
  and adaprogram_code = '102'
  and adadistrict_code is not null
--and adadistrict_code = '0633'
  and not exists (SELECT * FROM ms_advertise_bwlmlog l
                    WHERE ou_code = '000'
                      and adaref_no = ref_no
                      and log_code = 1)


SELECT * FROM ms_advertise_bwlmlog l WHERE ou_code = '000' --and ref_no = '1021300004189' --
and log_code = 1
and cre_date between to_date('08/05/2013 23:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('08/05/2013 23:59:00','dd/mm/rrrr hh24:mi:ss') 


Document No
select * from su_running where srnou_code = '000' and srnrun_of_year = 2014 and srnprog_id = 'BWMSDT50' and srnprefix = '10113'

:MS_ADVERTISE_APPOINTMENT.ADAREF_NO := PKGSU_RUNNING.generateRef_NoR_poject(
                                                                                                :PARAMETER.S_OU_CODE
                                                                                    ,'R'
                                                                                  ,:ms_advertise_appointment.adaprogram_code||TO_CHAR(:MS_ADVERTISE_APPOINTMENT.ADAREF_DATE,'RR')
                                                                        ,:ms_advertise_appointment.adabrand
                                                                                  ,to_number(v_camp_year)
                                                                        ,:PARAMETER.S_ACCOUNT
                                                                                  ,:PARAMETER.S_PROG_ID )
select :MS_ADVERTISE_APPOINTMENT.ADAREF_NO := PKGSU_RUNNING.generateRef_NoR_poject('000'
                                                                                   ,'R'
                                                                                   ,:ms_advertise_appointment.adaprogram_code||TO_CHAR(:MS_ADVERTISE_APPOINTMENT.ADAREF_DATE,'RR')
                                                                                   ,:ms_advertise_appointment.adabrand
                                                                                   ,to_number(2013)
                                                                                   ,'PERAPONG'
                                                                                  ,:PARAMETER.S_PROG_ID ) from dual


Select --pi_prefix||LPAD(srnrun_nextno, v_length_run,0)
srn.*
         From   su_running srn
         Where  srnou_code      = '000'
         and    srnrun_code     = 'R'
         and    srnrun_of_year  = 2013
         and    srnprefix       = pi_prefix
