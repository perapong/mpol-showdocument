select * from bwprod.bw_riaddress where reg_no in (
    select reg_no from (
        select a.reg_no , count(*) 
        from bwprod.bw_riaddress a, bwprod.bw_rirep r
        where a.addr_type = 1
        and a.reg_no = r.reg_no 
        and substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
        group by a.reg_no
    having count(*) > 1)
)
order by reg_no , addr_type;

--select * from bwprod.bw_riaddress where reg_no in ('0751131003173655')


/*

insert into bw_riaddress (reg_no, addr_type, seq_no, country, default_flag, type_address, latitude, longitude, cre_by, cre_date, upd_by, upd_date)
SELECT reg_no, 1 addr_type, 1 seq_no,
       66 country, 1 default_flag, '01' type_address,
       0 latitude, 0 longitude, cre_by, cre_date, upd_by, upd_date
  FROM bw_rirep
 WHERE reg_no = '0751131003173655' 
insert into bw_riaddress (reg_no, addr_type, seq_no, country, default_flag, type_address, latitude, longitude, cre_by, cre_date, upd_by, upd_date)
SELECT reg_no, 2 addr_type, 2 seq_no,
       66 country, 1 default_flag, '01' type_address,
       0 latitude, 0 longitude, cre_by, cre_date, upd_by, upd_date
  FROM bw_rirep
 WHERE reg_no = '0751131003173655' 

select * from bwprod.bw_riaddress a

--delete from bwprod.bw_riaddress a
where addr_type = 1
and a.line1 is null
and exists (select 1 from bw_riaddress t where t.addr_type = 1 and t.reg_no = a.reg_no and t.line1 is not null and t.latitude is not null and t.longitude is not null)
and exists (select 1 from bw_rirep r where r.loc_code is not null and r.reg_no = a.reg_no 
            and substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C') )
order by reg_no

/*

select r.loc_code, r.first_name, r.last_name, r.send_date, r.iaversion, a.* 
from bwprod.bw_riaddress a, bwprod.bw_rirep r
where a.reg_no = r.reg_no 
and a.addr_type = 1
and substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
and (a.line1 is null or a.tumbon_code is null)
--and (a.line1 is null or nvl(a.latitude,0) = 0 or nvl(a.longitude,0) = 0 )
and trunc(r.send_date) >= to_date('01/09/2012','dd/mm/rrrr')
order by r.send_date, a.reg_no 



select * from bwprod.bw_riaddress where reg_no in (
    select reg_no from (
        select a.reg_no  
        from bwprod.bw_riaddress a, bwprod.bw_rirep r
        where a.addr_type = 1
        and a.reg_no = r.reg_no 
        and substr(nvl(r.rep_code,'null'),1,1) not in ('1','2','3','4','5','6','7','8','9','0','C')
        and a.line1 is null
        ))
and cre_date > to_date('25/09/2012','dd/mm/rrrr')
order by reg_no , addr_type;
*/
