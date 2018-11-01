JOB$_MS_GEN_DISTRICT
/* Perapong Run Fix Gen District for ms_advertise_appointment */
declare
    cursor rec is
        select decode(p.prvprovince_group, '6016','3011',p.prvprovince_group) prvprovince_group
             , a.*
        from ms_advertise_appointment a, db_province p 
        where adaou_code = '000'
          and adayear = 2015
          and adaprvoince_code not in ('02','24','28','59','60','61')
          and adadistrict_code is null
          and adadivision_code is null 
          and adarep_seq is null
          and p.prvou_code = a.adaou_code
          and p.prvprovince_code = a.adaprvoince_code;
          
v_DIST  VARCHAR2(10);
v_DIV   VARCHAR2(10);
Begin
    For Trec In rec Loop
        Begin
            pr_gen_dist(Trec.adaprogram_code, '000', Trec.adaprvoince_code, Trec.prvprovince_group, Trec.adayear, v_DIST, v_DIV);
        End;
        
        Begin
            Update ms_advertise_appointment u
               set u.adadistrict_code = v_DIST
                 , u.adadivision_code = v_DIV
             Where u.adaou_code = Trec.adaou_code
               and u.adaref_no = Trec.adaref_no
               and u.adayear = Trec.adayear
               and u.adaprogram_code = Trec.adaprogram_code
               and u.adadistrict_code is null
               and u.adadivision_code is null 
               and u.adarep_seq is null;
            
            Exception when no_data_found Then Null;
        End;
    End Loop;
End;
/*
select to_char(adacre_date,'HH24') "เวลา"
--     , adasource_code
     , sum(decode(adasource_code,'06',1,0)) "นิตยสาร HAIR"
     , sum(decode(adasource_code,'18',1,0)) "ทีวีพูล"
     , sum(decode(adasource_code,'19',1,0)) "นสพ. ไทยรัฐ"
     , sum(decode(adasource_code,'21',1,0)) "ทีวีไม่ทราบช่อง"
     , sum(decode(adasource_code,'22',1,0)) "ทีวีช่อง 3"
     , sum(decode(adasource_code,'23',1,0)) "ทีวีช่อง 5"
     , sum(decode(adasource_code,'24',1,0)) "ทีวีช่อง 7"
     , sum(decode(adasource_code,'25',1,0)) "ทีวีช่อง 9"
     , sum(decode(adasource_code,'26',1,0)) "PSI เคเบิ้ลทีวี"
     , sum(decode(adasource_code,'27',1,0)) "Internet"
     , sum(decode(adasource_code,'31',1,0)) "เพื่อน, ญาติที่เป็นสมาชิก"
     , sum(decode(adasource_code,'32',1,0)) "แคตตาล็อก"
     , sum(decode(nvl(adasource_code,'99'),'99',1,0)) "อื่นๆ"
--,r.*
--distinct PKGSU_PARAM.GETSOURCE_ADVDESC(r.ADASOURCE_CODE)
from ms_advertise_appointment r
where adaou_code = '000'
  and adayear = 2013
  and adaprogram_code = 101
  and adaref_date = to_date('09/09/2013','dd/mm/rrrr')
--and adasource_code = 24
--and adacre_date between to_date('09/09/2013 23:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('09/09/2013 23:59:59','dd/mm/rrrr hh24:mi:ss')

group by to_char(adacre_date,'HH24')
order by to_char(adacre_date,'HH24')


*/
