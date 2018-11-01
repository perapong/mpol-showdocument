-- Start of DDL Script for Materialized View BWPROD.BEMV_DP_HOURLY
-- Generated 30/10/2014 14:55:51 from BWPROD@PROD

-- Drop the old instance of BEMV_DP_HOURLY
DROP MATERIALIZED VIEW BEMV_DP_HOURLY;
/

CREATE MATERIALIZED VIEW BEMV_DP_HOURLY
  PCTFREE     10
  MAXTRANS    255
  TABLESPACE  bwprod_tbs1
  STORAGE   (
    INITIAL     65536
    MINEXTENTS  1
    MAXEXTENTS  2147483645
  )
  NOCACHE
NOLOGGING
NOPARALLEL
BUILD IMMEDIATE 
REFRESH ON DEMAND
AS
SELECT 1 COL1, 'Refresh' COL2, 'วันที่ ' || to_char(sysdate,'dd/mm/rrrr') COL4, 
       to_number(to_char(sysdate,'hh24'))+1 COL5, to_number(substr(pkgdb_desc.getcurrent_campaign,1,2)) COL6, to_number(substr(pkgdb_desc.getcurrent_campaign,3,4)) COL7
FROM DUAL

union

SELECT 2 COL1, 'TOSSOURCE_RELHOLD' COL2, '' COL4, 0 COL5, CNT_TOS COL6, CNT_RELHOLD COL7
FROM (
      SELECT SUM(CASE WHEN BIH.BIHSOURCE = 'TOS' AND (BIH.BIHREF_TRANS_DATE >= TRUNC(SYSDATE) AND BIH.BIHREF_TRANS_DATE <= TRUNC(SYSDATE)+0.99999) THEN 1
                 ELSE 0 END) CNT_TOS
           , SUM(CASE WHEN BIH.BIHHOLD_DATE IS NOT NULL AND BIHORDER_STATUS <> '04' THEN 1
                 ELSE 0 END) CNT_RELHOLD
      FROM   OM_ORDER_HDR        BIH
      WHERE  BIH.BIHOU_CODE    = '000'
      AND    (   TRUNC(BIH.BIHBILL_DATE) = TRUNC(SYSDATE)
                 OR ((TRUNC (BIH.BIHORDER_DATE) = TRUNC(SYSDATE)) AND (BIH.BIHORD_TYPE NOT IN ('5', '6')))
                 OR (BIH.BIHREF_TRANS_DATE >= TRUNC(SYSDATE) AND BIH.BIHREF_TRANS_DATE <= TRUNC(SYSDATE)+0.99999))
      AND    EXISTS (SELECT NULL
                     FROM   DB_SALES_LOCATION DST
                     WHERE  DST.DSTOU_CODE  = BIH.BIHOU_CODE
                     AND    DST.DSTLOC_CODE = BIH.BIHLOC_CODE 
                     AND    NVL(DST.DSTSPECIAL_STATUS,'0')  = '0'
                    )

    )

union
select 3 COL1, 'ORDER_CTDAMT' COL2, '' COL4, 0 COL5, NVL(SUM(NO_OF_ORDER),0) COL6, NVL(SUM(SALESS_AMT),0) COL7
from BWPROD.BEV_DPORDER_CTDAMT

union

SELECT 4 COL1, 'NETSALES_BRAND' COL2, brand_group COL4, no_of_order COL5, ntb_amount COL6, NET_SALES COL7
FROM BEV_NETSALES_BY_BRAND_GROUP

union

--SELECT 5 COL1, 'NETSALES_NSM' COL2, nsm COL4, no_of_order COL5, round(net_sales*100/107,2) COL6, net_sales COL7
SELECT 5 COL1, 'NETSALES_NSM' COL2, nsm COL4, no_of_order COL5, ntb_amount COL6, net_sales COL7
FROM BWPROD.BEV_NETSALES_BY_NSM_ALL

union 

SELECT 6 COL1, 'ORDER_1MBOVER' COL2, b.nsm COL4, 0 COL5, nvl(NET_AMOUNT_AFTDISC,0) COL6, nvl(TTL_AMOUNT_AFTDISC,0) COL7
FROM (  SELECT      CASE WHEN OHDLOC_CODE = '0069' THEN '9'
                    ELSE pkgbw_misc.getxnsmcode(OHDLOC_CODE) END NSM,
                    SUM(OHDNET_AMOUNT_AFTDISC) NET_AMOUNT_AFTDISC,
                    SUM(OHDTTL_AMOUNT_AFTDISC) TTL_AMOUNT_AFTDISC
             FROM   OM_TRANSACTION_HDR
            WHERE   OHDOU_CODE = '000'
              AND   OHDTRANS_STATUS <> '9'
              AND   OHDCANCEL_DATE IS NULL
              AND   TRUNC(OHDTRANS_DATE) = TO_DATE(SYSDATE, 'dd/mm/rrrr')
                            AND   EXISTS (SELECT NULL
                                             FROM   DB_SALES_LOCATION DST
                                             WHERE  DST.DSTOU_CODE  = OHDOU_CODE
                                             AND    DST.DSTLOC_CODE = OHDLOC_CODE 
                                             AND    NVL(DST.DSTSPECIAL_STATUS,'0')  = '0' )

            --AND OHDTTL_AMOUNT_AFTDISC > 1000000
              AND OHDNET_AMOUNT_AFTDISC > 1000000
              AND OHDTRANS_SOURCE <> 'RET'
        GROUP BY CASE WHEN OHDLOC_CODE = '0069' THEN '9'
                    ELSE pkgbw_misc.getxnsmcode(OHDLOC_CODE) END
    ) a RIGHT OUTER JOIN 
    (   select dstloc_code NSM from db_sales_location
         where dstou_code = '000'
           and dstloc_code <> '8'
           and dstloc_type = 'N'
         order by dstloc_code
    ) b ON b.nsm = a.nsm

union

SELECT 7 COL1, 'ORDER_SUMORDSTS' COL2, order_type COL4, keyin COL5, hold COL6, invoice COL7
FROM (
    SELECT   (case
                when PADENTRY_LDESC = 'URGENT-M1' then 'URGENT'
                else PADENTRY_LDESC
               end) ORDER_TYPE,
              TRANS_DATE,
              SUM (KEYIN) KEYIN,
              SUM (HOLD) HOLD,
              SUM (INVOICE) INVOICE
       FROM   ( SELECT    TRUNC(SYSDATE) TRANS_DATE,
                          '6' ORD_TYPE,
                          0 KEYIN,
                          0 HOLD,
                          0 INVOICE
                     FROM DUAL
                UNION ALL
                   SELECT BIHBILL_DATE TRANS_DATE,
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
                          AND TRUNC (BIHBILL_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')
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
                          AND TRUNC (BIHORDER_DATE) = TO_DATE (SYSDATE, 'dd/mm/rrrr')
               GROUP BY   BIHORDER_DATE, BIHORD_TYPE
               UNION ALL
                 SELECT   OHDTRANS_DATE TRANS_DATE,
                          OHDORD_TYPE ORD_TYPE,
                          0 KEYIN,
                          0 HOLD,
                          count(1) INVOICE
                   FROM   OM_TRANSACTION_HDR OTH
                  WHERE   OHDOU_CODE = '000'
                    AND   OHDTRANS_STATUS <> '9'
                    AND   TRUNC(OHDTRANS_DATE) = TO_DATE(SYSDATE, 'dd/mm/rrrr')
                    AND   EXISTS (SELECT NULL
                                     FROM   DB_SALES_LOCATION DST
                                     WHERE  DST.DSTOU_CODE  = OTH.OHDOU_CODE
                                     AND    DST.DSTLOC_CODE = OTH.OHDLOC_CODE 
                                     AND    NVL(DST.DSTSPECIAL_STATUS,'0')  = '0' )
                    AND   OHDORD_TYPE in (SELECT DISTINCT PADENTRY_CODE
                                            FROM SU_PARAM_DTL
                                           WHERE PADPARAM_ID = 315
                                             AND PADINACTIVE_STATUS = '0' )
               GROUP BY OHDTRANS_DATE, OHDORD_TYPE
              ),
              SU_PARAM_DTL
      WHERE   PADPARAM_ID = 315 AND ORD_TYPE = PADENTRY_CODE
   GROUP BY   TRANS_DATE, (case
                when PADENTRY_LDESC = 'URGENT-M1' then 'URGENT'
                else PADENTRY_LDESC
               end)
   ORDER BY ORDER_TYPE 
)


/

-- Grants for Materialized View
GRANT SELECT ON bemv_dp_hourly TO select_bw_role
/

-- End of DDL Script for Materialized View BWPROD.BEMV_DP_HOURLY


begin DBMS_SNAPSHOT.REFRESH('BEMV_DP_HOURLY'); end;
/
--- 2  ---
select * from BEMV_DP_HOURLY;

