select bb.*
     , substr(iaversion,1,3) iaversion
from (
select pkgbw_misc.getxnsmcode(DISTRICT) NSM
     , DIV
     , pkgbw_desc.getxdivdesc(DIV) DIVISION_NAME
     , DISTRICT
     , DISTRICT_NAME
     , last_send_date
     , (select max(iaversion) from bw_rirep t where t.loc_code = aa.DISTRICT and t.send_date = aa.last_send_date) iaversion
from ( select dstparent_loc_code DIV
     , dstloc_code DISTRICT
     , dstmgr_name DISTRICT_NAME
     , (select max(send_date) from bw_rirep t where t.loc_code = d.dstloc_code) last_send_date
from db_sales_location d
where dstou_code = '000'
  and dstloc_type = 'S'
  and dstmgr_name is not null
  and pkgbw_misc.getxnsmcode(dstloc_code) between 1 and 4

) aa

) bb
where iaversion < '2.4'
  and nsm = 3
order by 1,2,3,4 


-- tbl01@eh2as   or tbl02@eh2as
select distinct nsm_code, div_code
     , pkgbw_iaverify.getxdivdesc(div_code) div_name
     , loc_code, dist_name
     , send_date
     , (select max(iaversion) from bw_rirep t where t.loc_code = aa.loc_code and t.send_date = aa.send_date) iaversion
from (select pkgbw_iaverify.getxnsmcode(a.dstloc_code) nsm_code
           , pkgbw_iaverify.getxdivcode(a.dstloc_code) div_code
           , a.dstloc_code loc_code
           , dstmgr_name dist_name
           , (select max(send_date) from bw_rirep t where t.loc_code = a.dstloc_code) send_date
      from bw_riloc a
      where a.dstloc_type = 'S'
      --and substr(a.dstloc_code,1,1) not in (8,9)
        and a.dstloc_code not in ('0999','0998','0997')
     ) aa
where div_code between '001' and '806'
  and dist_name is not null
  and trunc(send_date) between to_date('21/02/2014','dd/mm/rrrr') and to_date('24/02/2014','dd/mm/rrrr')
  and (select max(iaversion) from bw_rirep t where t.loc_code = aa.loc_code and t.send_date = aa.send_date) < '2.4'
order by nsm_code, div_code, loc_code


/*
select distinct loc_code 
from (select * from bw_rirep
where iaversion <> '1.8'
--rep_code = 'SEND'
and send_date > sysdate - 2
order by send_date desc)
*/
/*
select nsm, div, loc_code, name, send_date
  , (select max(iaversion) from bw_rirep t where t.loc_code = aa.loc_code and t.send_date = aa.send_date) iaversion
from (
  select tab.loc_code, dst.loc_mgrname name, div.DSTPARENT_LOC_CODE div, NSM.DSTPARENT_LOC_CODE nsm
  , max(send_date) send_date
  from (select dstloc_code loc_code, dstmgr_name dist_name, a.dstparent_loc_code par_loc_code from bw_riloc a where a.dstloc_type = 'S') tab
  left outer join 
       (select dstloc_code div_code, dstmgr_name dist_name, a.dstparent_loc_code nsm from bw_riloc a where a.dstloc_type = 'D') div on tab.loc_code = div.div_code
--  left outer join BW_RILOC NSM on div.DSTPARENT_LOC_CODE = NSM.DSTLOC_CODE
--  left outer join bw_ri_district dst on tab.loc_code = dst.loc_code
  --inner join db_sales_location s on tab.loc_code = s.dstloc_code and s.dstloc_type = 'S'
  left outer join bw_rirep r on tab.loc_code = r.loc_code
  --where tab.brand = 1 and tab.status = 1 and tab.place = 2
  --and length(tab.loc_code) = 4
  group by tab.loc_code, div.DSTPARENT_LOC_CODE, NSM.DSTPARENT_LOC_CODE, dst.loc_mgrname
) aa
--group by nsm, div, loc_code, name, send_date
order by nsm, div, loc_code
*/
