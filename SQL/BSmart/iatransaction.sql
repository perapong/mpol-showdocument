select d.dstparent_loc_code nsm, c.dstparent_loc_code division, b.loc_code district, to_char(a.cre_date,'dd/mm/rrrr hh24:mi:ss') send_date, a.rep_code
--, case nvl(a.rep_code,'NO') when 'SEND' then 0 when 'AUTO' then 0 when 'NO' then 0 else 1 end rep_cnt
, (select min(err_code) from bw_richk_profile t where t.reg_no = a.reg_no) err_code
, pkgbw_dsmsmart.getreturntextdesc(reg_no) err_desc
--, count(a.rep_code) rep_req
--, sum( case nvl(a.rep_code,'NO') when 'SEND' then 0 when 'AUTO' then 0 when 'NO' then 0 else 1 end) rep_rtn
--,a.* 
from (select * from bw_tablet
      where brand = 1
      and runno <= 50
      and length(loc_code) = 4
      and serial not in ('MP07DH7','MP07DGT')
      --and mgr_name <> 'ส่งซ่อม'
      order by runno) b inner join 
      bw_riloc c on b.loc_code = c.dstloc_code left outer join
      bw_riloc_ex d on c.dstparent_loc_code = d.dstloc_code left outer join 
     (select * from bw_rirep where trunc(cre_date) = to_date('28/02/2012','dd/mm/rrrr')) a on b.loc_code = a.loc_code
--where b.loc_code = '0392'
--group by b.loc_code
order by d.dstparent_loc_code, c.dstparent_loc_code, b.loc_code


/*
declare
  newregno varchar(50);
  oldregno varchar(50);
begin
  newregno := 'AAAiazAAGAAIuPXAAK';
  oldregno := '9998111223152812';
  update bw_rirep set reg_no     = newregno where reg_no like oldregno;
  update bw_riaddress set reg_no = newregno where reg_no like oldregno;
  update bw_ripicture set reg_no = newregno where reg_no like oldregno;
  update bw_riwelfare set reg_no = newregno where reg_no like oldregno;
end;


*/
/*
declare
  delregno varchar(50);
begin
  delregno := '8375120116031210';
  delete bw_rirep     where reg_no like delregno;
  delete bw_ripicture where reg_no like delregno;
  delete bw_riwelfare where reg_no like delregno;
end;
*/