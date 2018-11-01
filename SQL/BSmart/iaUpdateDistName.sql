select substr(dstloc_code,2,3) loc_code
, (select trim(distmgr) from tbl001@eh2as t where distcode = substr(dstloc_code,2,3))
, a.* 
from bw_riloc_ex a
--update bw_riloc_ex a set dstmgr_name = (select trim(distmgr) from tbl001@eh2as t where distcode = substr(dstloc_code,2,3))
where dstloc_type = 'S'
--  and dstloc_code = '0850'
--  and (select trim(distmgr) from tbl001@eh2as t where distcode = substr(dstloc_code,2,3)) <> a.dstmgr_name


/*
SELECT dstloc_code,
    dstloc_type,
    dstmgr_name,
    dstmgradd_province,
    dstdistrict_type,
    dstmgr_empid,
    MAX(DECODE (bx.dsbbrand_code, '1', DECODE (bx.dsbbrand_allowed, '0', '1', '0'), '0')) MISTINE_ALLOWED,
    MAX(DECODE (bx.dsbbrand_code, '2', DECODE (bx.dsbbrand_allowed, '0', '1', '0'), '0')) FRIDAY_ALLOWED,
    MAX(DECODE (bx.dsbbrand_code, '3', DECODE (bx.dsbbrand_allowed, '0', '1', '0'), '0')) FARIS_ALLOWED,
    dstparent_loc_code,
    MAX (dstmgrtel1) dstmgrtel1,
    dstloc_name,
    dstloc_province,
    dstmgr_shrtname
  FROM db_sales_location x,
    db_sales_location_brand bx
  WHERE x.dstou_code   = bx.dsbou_code
  AND x.dstloc_code    = bx.dsbloc_code
  and dstloc_type = 'S'
  AND dstloc_code NOT IN
    ( SELECT dist_code FROM bev$_skipdist
    )
  GROUP BY dstloc_code,
    dstloc_type,
    dstmgr_name,
    dstmgradd_province,
    dstdistrict_type,
    dstmgr_empid,
    dstparent_loc_code,
    dstloc_name,
    dstloc_province,
    dstmgr_shrtname 
    */
