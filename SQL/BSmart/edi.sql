grant select on bev_bw_edi to webdiv
select * from bev_bw_edi

--create or replace view bev_bw_edi as
select 1 ptype, fs.fs_code, fs.fs_sup_code, fs.fs_sup_seq, null description, pdtstandard_cost standard_cost, pdtstk_per_carton unit_pack, null plan_camp,
       null camp_sdate, null camp_month, null campaign, null plan_unit, null fg_stock, null fg_wip, 
       rm.rm_seq, rm.rm_code, rm.rm_desc, rm.rm_stock_unit, rm.rm_qm_unit,
       rm.rm_rej_stock, rm.rm_rej_vender, rm.rm_vender, rm.rm_minimum, rm.rm_leadtime,
       po.po_seq, po.po_no, po.po_date, po.po_qty, po.po_due_date, po.cover_order1, po.cover_order2, po.remark
from perapong.bw_edi_fs fs , perapong.bw_edi_rm rm , perapong.bw_edi_po po , db_product_dtl dd
where fs.fs_sup_code = rm.fs_sup_code
  and fs.fs_sup_seq  = rm.fs_sup_seq
  and rm.fs_sup_code = po.fs_sup_code
  and rm.fs_sup_seq  = po.fs_sup_seq
  and rm.rm_seq      = po.rm_seq
  and fs.fs_code     = dd.pdtfinished_code
  and fs.fs_code = '10043'
  and fs.inactive = 0
  and rm.inactive = 0
  and po.inactive = 0
union all
select 2 ptype, fs_code, null fs_sup_code, null fs_sup_seq, null description, standard_cost, unit_pack, plan_camp,
       camp_sdate, camp_month, campaign, plan_unit, null fg_stock, null fg_wip, 
       null rm_seq, null rm_code, null rm_desc, null rm_stock_unit, null rm_qm_unit,
       null rm_rej_stock, null rm_rej_vender, null rm_vender, null rm_minimum, null rm_leadtime,
       null po_seq, null po_no, null po_date, null po_qty, null po_due_date, null cover_order1, null cover_order2, null remark
from BEMV_BW_EDI_FS h
where fs_code = '10043'

order by 1, 2, 15, 25




-- Start of DDL Script for Materialized View BWPROD.BEMV_BW_EDI_FS
-- Generated 2/26/2014 9:29:56 AM from BWPROD@PROD1

-- Drop the old instance of BEMV_BW_EDI_FS
DROP MATERIALIZED VIEW bemv_bw_edi_fs
/

CREATE MATERIALIZED VIEW bemv_bw_edi_fs
  PCTFREE     10
  MAXTRANS    255
  TABLESPACE  bwprod_tbs
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
  NOCACHE
NOLOGGING
NOPARALLEL
BUILD IMMEDIATE 
REFRESH START WITH TO_DATE('27-02-2014 06:36 AM','DD-MM-YYYY HH12:MI PM') NEXT SYSDATE + 1 
AS
SELECT /*+APPEND */
       d.eodfs_code fs_code,
       pd.pdtstandard_cost standard_cost,
       pd.pdtstk_per_carton unit_pack,
       eodcampaign plan_camp,
       SUBSTR (eodcampaign, 1, 2) || '/' || SUBSTR (eodcampaign, 3, 4) campaign,
       pkgdb_desc.getcampaign_sdate (eodou_code, eodcampaign) camp_sdate,
       TO_CHAR (pkgdb_desc.getcampaign_sdate (eodou_code, eodcampaign),'mm/rr') camp_month,
       d.eodpo_qty plan_unit
  FROM PP_ESTIMATE_ORDER_HDR h, PP_ESTIMATE_ORDER_DTL d, DB_PRODUCT_DTL pd ,
       (SELECT  pkgdb_desc.getprev_campaign ('000',pkgdb_desc.getcurrent_campaign, 2)  prevCamp from dual) Cpx
 WHERE   h.eohou_code      ='000'
       and d.eodou_code    = h.eohou_code
       AND d.eodprocess_no = h.eohprocess_no
       AND d.eodbrand_code = h.eohbrand_code
       AND d.eodprod_id    = h.eohprod_id
       AND d.eodfs_code    = pd.pdtfinished_code
       AND SUBSTR (eodcampaign, 3, 4) || SUBSTR (eodcampaign, 1, 2) >=  Substr(Cpx.prevCamp,3,4)|| Substr(Cpx.prevCamp,1,2)
/

-- Grants for Materialized View
GRANT SELECT ON bemv_bw_edi_fs TO select_bw_role
/

-- End of DDL Script for Materialized View BWPROD.BEMV_BW_EDI_FS
/*
old
CREATE MATERIALIZED VIEW BWPROD.BEMV_BW_EDI_FS
BUILD IMMEDIATE
REFRESH START WITH to_date('17-05-2013 02:43 PM', 'DD-MM-YYYY HH12:MI PM')
 NEXT sysdate + 2/24
FORCE
SELECT spdfinished_code fs_code
     , pdtstandard_cost standard_cost
     , pdtstk_per_carton unit_pack
     , plan_camp
     , substr(plan_camp,1,2) || '/' || substr(plan_camp,3,4) campaign
     , pkgdb_desc.getcampaign_sdate(spdou_code, plan_camp) camp_sdate
     , to_char(pkgdb_desc.getcampaign_sdate(spdou_code, plan_camp),'mm/rr') camp_month
     , plan_unit
from ( select spdou_code, plan_camp, spdfinished_code, SUM(plan_unit) plan_unit from (
            select 'CURR' SRC  , spdou_code, spdplan_campaign plan_camp, spdfinished_code, spdcur_unit plan_unit 
              from mk_saleplan_dtl ax
             where spdou_code ='000'
            union all                 
            select 'ADV' SRC   , spdou_code, spdadv_campaign plan_camp , spdfinished_code, spdadv_unit plan_unit 
              from mk_saleplan_dtl bx
             where spdou_code    ='000'
            )
            group by spdou_code, spdfinished_code, plan_camp
     ) md, db_product_dtl dd
where md.spdou_code = '000'
  and md.spdfinished_code = dd.pdtfinished_code
order by fs_code, camp_sdate
*/

/*
SELECT spdfinished_code fs_code
     , plan_camp
     , substr(plan_camp,1,2) || '/' || substr(plan_camp,3,4) campaign
     , pkgdb_desc.getcampaign_sdate(spdou_code, plan_camp) camp_sdate
     , to_char(pkgdb_desc.getcampaign_sdate(spdou_code, plan_camp),'mm/rr') camp_month
     , pdtstandard_cost standard_cost
     , pdtstk_per_carton unit_pack
     , plan_unit
from ( select spdou_code, plan_camp, spdfinished_code, SUM(plan_unit) plan_unit from (
            select 'CURR' SRC  , spdou_code, spdplan_campaign plan_camp, spdfinished_code, spdcur_unit plan_unit 
              from mk_saleplan_dtl ax
             where spdou_code ='000'
             --and spdfinished_code ='35134'
             --and substr(spdplan_campaign,3) ||substr(spdplan_campaign,1,2) between  '201312' and '201312'
            union all                 
            select 'ADV' SRC   , spdou_code, spdadv_campaign plan_camp , spdfinished_code, spdadv_unit plan_unit 
              from mk_saleplan_dtl bx
             where spdou_code    ='000'
             --and spdfinished_code ='35134'
             --and substr(spdadv_campaign,3) ||substr(spdadv_campaign,1,2) between  '201312' and '201312'
            )
            group by spdou_code, spdfinished_code, plan_camp
     ) md, db_product_dtl dd
where md.spdou_code = '000'
  and md.spdfinished_code like '35134'
  and md.spdfinished_code = dd.pdtfinished_code
order by fs_code, camp_sdate
            





