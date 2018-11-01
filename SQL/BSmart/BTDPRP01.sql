--1 bwprod.BEV_DPORDER_1MBOVER
SELECT   OHDLOC_CODE dist,
            OHDREP_SEQ rep_seq,
            OHDREP_CODE rep_code,
            OHDREP_NAME rep_name,
            OHDTRANS_DATE order_date,
            (CASE
                WHEN dstsales_group = '00' THEN 'New Faris'
                WHEN dstsales_group = '11' THEN 'Old District'
                WHEN dstsales_group = '22' THEN 'New Mistine'
                WHEN dstsales_group = '99' THEN 'Test'
                ELSE dstsales_group
             END)
               dist_type,
            OHDNET_AMOUNT_AFTDISC,
            OHDTTL_AMOUNT_AFTDISC
     FROM      OM_TRANSACTION_HDR
            LEFT OUTER JOIN
               DB_SALES_LOCATION
            ON OHDLOC_CODE = dstloc_code
    WHERE       NVL (dstspecial_status, '0') = '0'      -- ignor test district
            AND OHDTTL_AMOUNT_AFTDISC > 1000000
            AND TRUNC (OHDTRANS_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')
            AND OHDCANCEL_DATE IS NULL


--2 BWPROD.BEV_DPORDER_CTDAMT
select actsales_date, sum(actno_oford) no_of_order, sum(ACTNETSALES) saless_amt
from SA_BAL_ACTUAL
where actbrand = '9'
      and actcamp = (SELECT     CPGCAMPAIGN_CODE AS EXPR1
                            FROM          DB_CAMPAIGN
                            WHERE      (trunc(sysdate) BETWEEN trunc(CPGEFF_SDATE) AND trunc(CPGEFF_EDATE)))
group by actsales_date
order by actsales_date


--3 BWPROD.BEV_DPORDER_CTDAMT_FARIS
SELECT   actsales_date,
              SUM (actno_oford) no_of_order,
              SUM (ACTNETSALES) saless_amt
       FROM   SA_BAL_ACTUAL
      WHERE   actbrand = '32'
              AND actcamp =
                    (SELECT   CPGCAMPAIGN_CODE AS EXPR1
                       FROM   DB_CAMPAIGN
                      WHERE   (trunc(SYSDATE) BETWEEN trunc(CPGEFF_SDATE) AND trunc(CPGEFF_EDATE)))
   GROUP BY   actsales_date
   ORDER BY   actsales_date
   
   
--4 BWPROD.BEV_DPORDER_RELHOLD
SELECT      SUBSTR (BIHSALES_CAMPAIGN, 1, 2)
              || '/'
              || SUBSTR (BIHSALES_CAMPAIGN, 3, 4)
                 current_campaign,
                 SUBSTR (BIHORDER_CAMPAIGN, 1, 2)
              || '/'
              || SUBSTR (BIHORDER_CAMPAIGN, 3, 4)
                 order_campaign,
              BIHLOC_CODE dist,
              BIHREP_SEQ rep_seq,
              BIHORDER_DATE order_date,
              (CASE
                  WHEN dstsales_group = '00' THEN 'New Faris'
                  WHEN dstsales_group = '11' THEN 'Old District'
                  WHEN dstsales_group = '22' THEN 'New Mistine'
                  WHEN dstsales_group = '99' THEN 'Test'
                  ELSE dstsales_group
               END)
                 dist_type,
              COUNT ( * ) AS order_count
       FROM      OM_ORDER_HDR
              LEFT OUTER JOIN
                 DB_SALES_LOCATION
              ON BIHLOC_CODE = dstloc_code
      WHERE       BIHHOLD_DATE IS NOT NULL                  --have been 'Hold'
              --and BIHORDER_STATUS = '05'                --'Print Invoiced' status
              AND BIHORDER_STATUS <> '04'            --Not 'Hold Order' status
              --AND BIHDMG = 0                          --'Key in BSmart' sourse
              AND NVL (dstspecial_status, '0') = '0'    -- ignor test district
              AND (TRUNC (BIHBILL_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')
              OR ((TRUNC (BIHORDER_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr'))and(BIHORD_TYPE NOT IN ('5', '6')))
              OR (TRUNC (BIHREF_TRANS_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')))
              
              
   --and dstsales_group = '00'               -- 00 is New faris, 11 is Old Mistine, 22 is New Mistine
   --and to_date(BIHORDER_DATE,'dd/mm/rrrr') = to_date('11/07/2012','dd/mm/rrrr')
   GROUP BY   BIHSALES_CAMPAIGN,
              BIHORDER_CAMPAIGN,
              BIHLOC_CODE,
              BIHREP_SEQ,
              BIHORDER_DATE,
              dstsales_group
   ORDER BY   BIHSALES_CAMPAIGN,
              BIHORDER_CAMPAIGN,
              BIHLOC_CODE,
              BIHREP_SEQ,
              BIHORDER_DATE,
              dstsales_group
              
              
--5 BWPROD.BEV_DPORDER_SALEAMT
SELECT   OHDTRANS_DATE,
              District_Group_Desc,
              SUM (NoOfOrder) NoOfOrder,
              SUM (OHDNET_AMOUNT_AFTDISC) OHDNET_AMOUNT_AFTDISC,
              SUM (OHDTTL_AMOUNT_AFTDISC) OHDTTL_AMOUNT_AFTDISC              
       FROM   (  SELECT   OHD.OHDTRANS_DATE OHDTRANS_DATE,
                          --OHD.OHDLOC_CODE,
                          (CASE
                              WHEN SLSLOC.DSTSALES_GROUP = '00'
                              THEN
                                 'New Faris District'
                              WHEN SLSLOC.DSTSALES_GROUP = '11'
                              THEN
                                 'Old District'
                              WHEN SLSLOC.DSTSALES_GROUP = '22'
                              THEN
                                 'New Mistine District'
                              WHEN SLSLOC.DSTSALES_GROUP = '99'
                              THEN
                                 'Test District'
                              ELSE
                                 SLSLOC.DSTSALES_GROUP
                           END)
                             AS District_Group_Desc,
                          'Invoice' Doctype,
                          COUNT ( * ) NoOfOrder,
                          SUM (OHDNET_AMOUNT_AFTDISC) OHDNET_AMOUNT_AFTDISC,
                          SUM (OHDTTL_AMOUNT_AFTDISC) OHDTTL_AMOUNT_AFTDISC
                   FROM            OM_TRANSACTION_HDR OHD
                                JOIN
                                   BEV$_BI_SALESLOC SLC
                                ON OHD.OHDOU_CODE = SLC.DSTOU_CODE
                                   AND SUBSTR (OHD.OHDUPD_REP_CODE, 1, 4) =
                                         SLC.DSTLOC_CODE
                             JOIN
                                SU_PARAM_DTL TPY
                             ON OHD.OHDTRANS_GROUP = TPY.PADENTRY_CODE
                                AND TPY.PADPARAM_ID = 395
                          JOIN
                             DB_SALES_LOCATION SLSLOC
                          ON OHD.OHDLOC_CODE = SLSLOC.DSTLOC_CODE
                             AND OHD.OHDOU_CODE = SLSLOC.DSTOU_CODE
                  WHERE   OHD.OHDOU_CODE = '000'
                          AND TRUNC (OHD.OHDTRANS_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
                          AND (OHDNET_AMOUNT_AFTDISC > 0)
               GROUP BY   OHD.OHDTRANS_DATE, SLSLOC.DSTSALES_GROUP
               UNION
                 SELECT   OHD.OHDCANCEL_DATE OHDTRANS_DATE,
                          --OHD.OHDLOC_CODE,
                          (CASE
                              WHEN SLSLOC.DSTSALES_GROUP = '00'
                              THEN
                                 'New Faris District'
                              WHEN SLSLOC.DSTSALES_GROUP = '11'
                              THEN
                                 'Old District'
                              WHEN SLSLOC.DSTSALES_GROUP = '22'
                              THEN
                                 'New Mistine District'
                              WHEN SLSLOC.DSTSALES_GROUP = '99'
                              THEN
                                 'Test District'
                              ELSE
                                 SLSLOC.DSTSALES_GROUP
                           END)
                             AS District_Group_Desc,
                          'Cancel' Doctype,
                          -1 * COUNT ( * ) NoOfOrder,
                          -1 * SUM (OHD.OHDNET_AMOUNT_AFTDISC),
                          -1 * SUM (OHD.OHDTTL_AMOUNT_AFTDISC)
                             OHDNET_AMOUNT_AFTDISC
                   FROM            OM_TRANSACTION_HDR OHD
                                JOIN
                                   BEV$_BI_SALESLOC SLC
                                ON OHD.OHDOU_CODE = SLC.DSTOU_CODE
                                   AND SUBSTR (OHD.OHDUPD_REP_CODE, 1, 4) =
                                         SLC.DSTLOC_CODE
                             JOIN
                                SU_PARAM_DTL TPY
                             ON OHD.OHDTRANS_GROUP = TPY.PADENTRY_CODE
                                AND TPY.PADPARAM_ID = 395
                          JOIN
                             DB_SALES_LOCATION SLSLOC
                          ON OHD.OHDLOC_CODE = SLSLOC.DSTLOC_CODE
                             AND OHD.OHDOU_CODE = SLSLOC.DSTOU_CODE
                  WHERE   OHD.OHDOU_CODE = '000'
                          AND TO_CHAR (ohd.ohdtrans_date, 'MM/YYYY') =
                                TO_CHAR (ohd.ohdcancel_date, 'MM/YYYY')
                          AND TRUNC (OHD.OHDCANCEL_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
                          --AND ISNULL(OHD.OHDTRANS_DATE, '1999-01-01 00:00:00.000') = ISNULL(OHD.OHDCANCEL_DATE, '1999-01-01 00:00:00.000')
                          AND (OHDNET_AMOUNT_AFTDISC > 0)
               GROUP BY   OHD.OHDCANCEL_DATE, SLSLOC.DSTSALES_GROUP)
   GROUP BY   OHDTRANS_DATE, District_Group_Desc
   ORDER BY   OHDTRANS_DATE, District_Group_Desc
   
   
   
--6 BWPROD.BEV_DPORDER_SUMORDSTS
SELECT   (case
                when PADENTRY_LDESC = 'URGENT-M1' then 'URGENT'
                else PADENTRY_LDESC
               end) ORDER_TYPE,
              TRANS_DATE,
              SUM (KEYIN) KEYIN,
              SUM (HOLD) HOLD,
              SUM (INVOICE) INVOICE
       FROM   (  SELECT   BIHBILL_DATE TRANS_DATE,
                          BIHORD_TYPE ORD_TYPE,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NULL
                                      AND PNT.PNTINVOICE_DATE IS NULL
                                      AND PARAM_STATUS.PADFLAG1 = '1'
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             KEYIN,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NOT NULL
                                      AND PNT.PNTINVOICE_DATE IS NULL
                                      AND PARAM_STATUS.PADFLAG2 = '1'
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             HOLD,
                          0 INVOICE
                   FROM   (SELECT   DISTINCT PADENTRY_CODE
                             FROM   SU_PARAM_DTL
                            WHERE   PADPARAM_ID = 315
                                    AND PADINACTIVE_STATUS = '0') PARAM,
                          (SELECT   DISTINCT PADENTRY_CODE, PADFLAG1, PADFLAG2
                             FROM   SU_PARAM_DTL
                            WHERE   PADPARAM_ID = 508
                                    AND PADINACTIVE_STATUS = '0') PARAM_STATUS,
                          OM_ORDER_HDR OOH,
                          OM_CHKPOINT_MAIN PNT,
                          DB_SALES_LOCATION
                  WHERE   BIHOU_CODE = '000'
                          --AND     BIHBILL_DATE                        = to_date('11/07/2012','dd/mm/yyyy')
                          AND (BIHORDER_STATUS NOT IN ('98', '99')
                               AND NVL (DSTSPECIAL_STATUS, '0') <> '1')
                          AND PARAM.PADENTRY_CODE = BIHORD_TYPE
                          AND PARAM_STATUS.PADENTRY_CODE = BIHORDER_STATUS
                          AND PNTOU_CODE = BIHOU_CODE
                          AND PNTSALES_CAMPAIGN = BIHSALES_CAMPAIGN
                          AND PNTREP_SEQ = BIHREP_SEQ
                          AND PNTSALES_SEQ = BIHBILL_SEQ
                          AND DSTOU_CODE = BIHOU_CODE
                          AND DSTLOC_CODE = BIHLOC_CODE
                          AND TRUNC (BIHBILL_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
               GROUP BY   BIHBILL_DATE, BIHORD_TYPE
               UNION ALL
                 SELECT   BIHORDER_DATE TRANS_DATE,
                          BIHORD_TYPE ORD_TYPE,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NULL
                                      AND PNT.PNTINVOICE_DATE IS NULL
                                      AND PARAM_STATUS.PADFLAG1 = '1'
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             KEYIN,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NOT NULL
                                      AND PNT.PNTINVOICE_DATE IS NULL
                                      AND PARAM_STATUS.PADFLAG2 = '1'
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             HOLD,
                          0 INVOICE
                   FROM   (SELECT   DISTINCT PADENTRY_CODE
                             FROM   SU_PARAM_DTL
                            WHERE   PADPARAM_ID = 315
                                    AND PADINACTIVE_STATUS = '0') PARAM,
                          (SELECT   DISTINCT PADENTRY_CODE, PADFLAG1, PADFLAG2
                             FROM   SU_PARAM_DTL
                            WHERE   PADPARAM_ID = 508
                                    AND PADINACTIVE_STATUS = '0') PARAM_STATUS,
                          OM_ORDER_HDR OOH,
                          OM_CHKPOINT_MAIN PNT,
                          DB_SALES_LOCATION
                  WHERE   BIHOU_CODE = '000'
                          --AND     TRUNC(BIHORDER_DATE)                 = to_date('11/07/2012','dd/mm/yyyy')
                          AND (BIHORDER_STATUS NOT IN ('98', '99')
                               AND NVL (DSTSPECIAL_STATUS, '0') <> '1')
                          AND BIHORD_TYPE NOT IN ('5', '6')
                          AND PARAM.PADENTRY_CODE = BIHORD_TYPE
                          AND PARAM_STATUS.PADENTRY_CODE = BIHORDER_STATUS
                          AND PNTOU_CODE = BIHOU_CODE
                          AND PNTSALES_CAMPAIGN = BIHSALES_CAMPAIGN
                          AND PNTREP_SEQ = BIHREP_SEQ
                          AND PNTSALES_SEQ = BIHBILL_SEQ
                          AND DSTOU_CODE = BIHOU_CODE
                          AND DSTLOC_CODE = BIHLOC_CODE
                          AND TRUNC (BIHORDER_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
               GROUP BY   BIHORDER_DATE, BIHORD_TYPE
               UNION ALL
                 SELECT /*+ ordered index(oth, IDX7_OM_TRANSACTION_HDR) index(ooh, IDX4_OM_ORDER_HDR) index(pnt, PKOM_CHKPOINT_MAIN)*/
                       OHDTRANS_DATE TRANS_DATE,
                          OHDORD_TYPE ORD_TYPE,
                          0 KEYIN,
                          0 HOLD,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NOT NULL
                                      AND PNT.PNTINVOICE_DATE IS NOT NULL
                                 /*AND bihorder_status = '05'*/
                              THEN
                                    1
                                 ELSE
                                    0
                              END)
                          + SUM(CASE
                                   WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                        AND PNT.PNTORDER_HOLD_DATE IS NULL
                                        AND PNT.PNTINVOICE_DATE IS NOT NULL
                                   /*AND bihorder_status = '05'*/
                                THEN
                                      1
                                   ELSE
                                      0
                                END)
                             INVOICE
                   FROM   OM_TRANSACTION_HDR OTH,
                          (SELECT   DISTINCT PADENTRY_CODE
                             FROM   SU_PARAM_DTL
                            WHERE   PADPARAM_ID = 315
                                    AND PADINACTIVE_STATUS = '0') PARAM,
                          OM_ORDER_HDR OOH,
                          OM_CHKPOINT_MAIN PNT,
                          DB_SALES_LOCATION
                  WHERE   OHDOU_CODE = '000'
                          --AND     TRUNC(OHDTRANS_DATE)  = to_date('11/07/2012','dd/mm/yyyy')
                          AND (OHDTRANS_STATUS <> '9'
                               AND NVL (DSTSPECIAL_STATUS, '0') <> '1')
                          AND PARAM.PADENTRY_CODE = OHDORD_TYPE
                          AND BIHOU_CODE = OHDOU_CODE
                          AND BIHREF_TRANS_YEAR = OHDYEAR
                          AND BIHREF_TRANS_GROUP = OHDTRANS_GROUP
                          AND BIHREF_TRANS_NO = OHDTRANS_NO
                          AND PNTOU_CODE = BIHOU_CODE
                          AND PNTSALES_CAMPAIGN = BIHSALES_CAMPAIGN
                          AND PNTREP_SEQ = BIHREP_SEQ
                          AND PNTSALES_SEQ = BIHBILL_SEQ
                          AND DSTOU_CODE = OHDOU_CODE
                          AND DSTLOC_CODE = OHDLOC_CODE
                          AND TRUNC (OHDTRANS_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
               GROUP BY   OHDTRANS_DATE, OHDORD_TYPE),
              SU_PARAM_DTL
      WHERE   PADPARAM_ID = 315 AND ORD_TYPE = PADENTRY_CODE
   GROUP BY   TRANS_DATE, (case
                when PADENTRY_LDESC = 'URGENT-M1' then 'URGENT'
                else PADENTRY_LDESC
               end)
               
               
               
               
--7 BWPROD.BEV_DPORDER_SUMORDSTS_FARIS
SELECT /*+ ordered index(oth, IDX7_OM_TRANSACTION_HDR) index(ooh, IDX4_OM_ORDER_HDR) index(pnt, PKOM_CHKPOINT_MAIN)*/
                       OHDTRANS_DATE TRANS_DATE,
                          --OHDORD_TYPE ORD_TYPE,
                          PARAM.PADENTRY_LDESC,
                          SUM(CASE
                                 WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                      AND PNT.PNTORDER_HOLD_DATE IS NOT NULL
                                      AND PNT.PNTINVOICE_DATE IS NOT NULL
                                 /*AND bihorder_status = '05'*/
                              THEN
                                    1
                                 ELSE
                                    0
                              END)
                          + SUM(CASE
                                   WHEN     PNT.PNTORDER_KEYIN_DATE IS NOT NULL
                                        AND PNT.PNTORDER_HOLD_DATE IS NULL
                                        AND PNT.PNTINVOICE_DATE IS NOT NULL
                                   /*AND bihorder_status = '05'*/
                                THEN
                                      1
                                   ELSE
                                      0
                                END)
                             INVOICE
                   FROM   OM_TRANSACTION_HDR OTH,
--                          (SELECT   DISTINCT PADENTRY_CODE
--                             FROM   SU_PARAM_DTL
--                            WHERE   PADPARAM_ID = 315
--                                    AND PADINACTIVE_STATUS = '0') PARAM,
                          OM_ORDER_HDR OOH,
                          OM_CHKPOINT_MAIN PNT,
                          DB_SALES_LOCATION,
                          SU_PARAM_DTL PARAM
                  WHERE   OHDOU_CODE = '000'
                          --AND     TRUNC(OHDTRANS_DATE)  = to_date('11/07/2012','dd/mm/yyyy')
                          AND (OHDTRANS_STATUS <> '9'
                               AND NVL (DSTSPECIAL_STATUS, '0') <> '1')
                          AND PARAM.PADENTRY_CODE = OHDORD_TYPE
                          AND PARAM.PADPARAM_ID = 315
                          AND BIHOU_CODE = OHDOU_CODE
                          AND BIHREF_TRANS_YEAR = OHDYEAR
                          AND BIHREF_TRANS_GROUP = OHDTRANS_GROUP
                          AND BIHREF_TRANS_NO = OHDTRANS_NO
                          AND PNTOU_CODE = BIHOU_CODE
                          AND PNTSALES_CAMPAIGN = BIHSALES_CAMPAIGN
                          AND PNTREP_SEQ = BIHREP_SEQ
                          AND PNTSALES_SEQ = BIHBILL_SEQ
                          AND DSTOU_CODE = OHDOU_CODE
                          AND DSTLOC_CODE = OHDLOC_CODE
                          AND TRUNC (OHDTRANS_DATE) =
                                TO_DATE (SYSDATE, 'dd/mm/rrrr')
                          AND DSTSALES_GROUP = '00'
               GROUP BY   OHDTRANS_DATE, PARAM.PADENTRY_LDESC--, OHDORD_TYPE
               order by OHDTRANS_DATE, PARAM.PADENTRY_LDESC
               
               
               
               
--8 BWPROD.BEV_DPORDER_TOSSOURCE
SELECT   BIHSOURCE source,
              padentry_ldesc order_by,
              BIHORDER_DATE order_date,
              (CASE
                  WHEN dstsales_group = '00' THEN 'New Faris'
                  WHEN dstsales_group = '11' THEN 'Old District'
                  WHEN dstsales_group = '22' THEN 'New Mistine'
                  WHEN dstsales_group = '99' THEN 'Test'
                  ELSE dstsales_group
               END)
                 dist_type,
              COUNT ( * ) AS order_count
       FROM         OM_ORDER_HDR
                 LEFT OUTER JOIN
                    su_param_dtl
                 ON BIHORDER_BY = padentry_code AND padparam_id = 316
              LEFT OUTER JOIN
                 DB_SALES_LOCATION
              ON BIHLOC_CODE = dstloc_code
      WHERE       BIHSOURCE = 'TOS'                       -- 'TOS' source only
              AND NVL (dstspecial_status, '0') = '0'    -- ignor test district
              --and dstsales_group = '00'               -- 00 is New faris, 11 is Old Mistine, 22 is New Mistine
              --and to_date(BIHORDER_DATE,'dd/mm/rrrr') = to_date('10/07/2012','dd/mm/rrrr')
              AND TRUNC (BIHREF_TRANS_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')
   GROUP BY   BIHSOURCE,
              padentry_ldesc,
              BIHORDER_DATE,
              dstsales_group
   ORDER BY   BIHSOURCE,
              padentry_ldesc,
              BIHORDER_DATE,
              dstsales_group
              
              

drop MATERIALIZED VIEW   BWPROD.BEMV_DP_HOURLY ;           
CREATE MATERIALIZED VIEW BWPROD.BEMV_DP_HOURLY
BUILD IMMEDIATE
REFRESH ON DEMAND
FORCE
AS               
select 0 COL1, 'REFRESH '||to_char(SYSDATE,'hh24:mi:ss') COL2, TRUNC(SYSDATE) COL3, substr(pkgdb_desc.getcurrent_campaign,1,2)||'/'||substr(pkgdb_desc.getcurrent_campaign,3,4) COL4, 0 COL5, 0 COL6, 0 COL7
from dual

union

select 1 COL1, 'ORDER_SUMORDSTS' COL2, TRUNC(SYSDATE) COL3, order_type COL4, keyin COL5, hold COL6, invoice COL7
from BWPROD.BEV_DPORDER_SUMORDSTS

union

select 2 COL1, 'ORDER_TOSSOURCE' COL2, TRUNC(SYSDATE) COL3, '' COL4, 0 COL5, 0 COL6, SUM(order_count) COL7
from BWPROD.BEV_DPORDER_TOSSOURCE

union

select 3 COL1, 'ORDER_CTDAMT' COL2, TRUNC(SYSDATE) COL3, '' COL4, 0 COL5, SUM(NO_OF_ORDER) COL6, SUM(SALESS_AMT) COL7
from BWPROD.BEV_DPORDER_CTDAMT

union

select 4 COL1, 'ORDER_RELHOLD' COL2, TRUNC(SYSDATE) COL3, '' COL4, 0 COL5, sum(order_count) COL6, 0 COL7
from BWPROD.BEV_DPORDER_RELHOLD

union

SELECT 5 COL1, 'NETSALES_BRAND' COL2, tran_date COL3, brand_group COL4, no_of_order COL5, ntb_amount COL6, NET_SALES COL7
FROM BEV_NETSALES_BY_BRAND_GROUP

union

SELECT 6 COL1, 'NETSALES_NSM' COL2, tran_date COL3, nsm COL4, no_of_order COL5, round(net_sales*100/107,2) COL6, net_sales COL7
FROM BWPROD.BEV_NETSALES_BY_NSM_ALL

union 

SELECT 7 COL1, 'ORDER_1MBOVER' COL2, TRUNC(SYSDATE) COL3, b.dstloc_code COL4, 0 COL5, nvl(sum(ohdnet_amount_aftdisc),0) COL6, nvl(sum(ohdttl_amount_aftdisc),0) COL7
FROM BWPROD.BEV_DPORDER_1MBOVER a RIGHT OUTER JOIN (select dstloc_code from db_sales_location
        where dstou_code = '000'
          and dstloc_code <> '8'
          and dstloc_type = 'N'
        order by dstloc_code) b ON b.dstloc_code = pkgbw_misc.getxnsmcode(a.dist)
GROUP BY b.dstloc_code


ORDER By 1, 4
--------------------------------------------------------------------------
--------------------------------------------------------------------------

--- 1  ---
begin     DBMS_SNAPSHOT.REFRESH('BEMV_DP_HOURLY'); end;
/
--- 2  ---
select * from BEMV_DP_HOURLY;

