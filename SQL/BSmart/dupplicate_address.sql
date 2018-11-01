--drop table zp_tmp_rep1 cascade constraints PURGE
--create table zp_tmp_rep1 as
select reprep_seq, reprep_code, reprep_name, repmobile_no, decode(reprep_status,'I1','AC','I2','AC','I3','AC',reprep_status) status, ma.realine1, ma.realine2, ma.realine3
, stf_gettumbon(ma.reatumbon_code, ma.reaprovince_code,'TH') tumbon, ma.reaamphur_code, stf_getamphur( ma.reaamphur_code, ma.reaprovince_code,'TH') amphur, stf_getprovince(reaprovince_code,'TH') province
, replace((ma.realine1 || ma.realine2 || ma.realine3 || ma.reatumbon_code || ma.reaamphur_code || ma.reaprovince_code) , chr(32),'') addr
from ms_representative ms, ms_rep_address ma
where repou_code = '000'
  and reploc_code = '0320'
  and ms.repou_code = ma.reaou_code
  and ms.reprep_seq = ma.rearep_seq
  and ma.reatype = 1
order by 

create table zp_tmp_rep3 as
select t.* from 
where exists (

select count(addr),reprep_seq, reprep_code, reprep_name, repmobile_no  from zp_tmp_rep1 
group by reprep_seq, reprep_code, reprep_name, repmobile_no having count(addr)> 1

select * from zp_tmp_rep1  order by addr

select 1 from zp_tmp_rep1 ma, ms_rep_address ma 
                where ma.reaou_code = '000'
                  and ma.reatype = 1
                 -- and nvl(ma.realine1,'') || nvl(ma.realine2,'') || nvl(ma.realine3,'') = nvl(t.realine1,'') || nvl(t.realine2,'') || nvl(t.realine3,'')
                  
                  and ma.reatumbon_code = t.reatumbon_code
                  and ma.reaamphur_code = t.reaamphur_code
                  and ma.reaprovince_code = t.reaprovince_code 
                  )

--5311

--4738
-- 573

select count(*) from ms_representative ms
where repou_code = '000'
  and reploc_code = '0032'
  and not exists (select 1 from ms_rep_address ma 
                where ms.repou_code = ma.reaou_code
                  and ms.reprep_seq = ma.rearep_seq
                  and ma.reatype = 1)


