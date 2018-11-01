SELECT REP.REPOU_CODE                                                   OU_CODE
,      SUBSTR(REP.REPREP_LOCATION,1,INSTR(REP.REPREP_LOCATION,'|')-1)   NSM
,      SUBSTR(REP.REPREP_LOCATION,INSTR(REP.REPREP_LOCATION,'|')+1)     DIV
,      REP.REPLOC_CODE                                                  LOC
,      DECODE(NVL(REP.REPAPPT_TYPE,'0'),NVL(:P_APPT_TYPE,'2'),'N',NULL) FARIS 
,      REP.REPREP_SEQ                                                   REP_SEQ
,      REP.REPREP_CODE                                                  REP_CODE
,      SUBSTR(REP.REPREP_CODE,1,4)||'-'||SUBSTR(REP.REPREP_CODE,5,5)||'-'||SUBSTR(REP.REPREP_CODE,10,1) REP_CODE_SUB
,      OM2.OHDTRANS_DATE 
-----  ,      REP.REPREP_NAME||' ('||REP.REPOCCUPATION||')   : ' ||   OHDREP_NAME

,      REP.REPREP_NAME  OHDREP_NAME ,  rep.repmobile_no 

,      CASE WHEN REP.REPAPPT_STATUS IN ('TI','RI') AND (SELECT subq.MPSCAMPAIGN
                                                         FROM DB_MAILPLAN_SALES subq
                                                         WHERE subq.mpsou_code = '000'
                                                           and subq.MPSLOC_CODE = REP.REPLOC_CODE
                                                           and TRUNC(REP.REPAPPT_ST_DATE) between TRUNC(subq.MPSPREVSHIP) and TRUNC(subq.MPSSHIPDATE)) = :P_CAMPAIGN THEN REP.REPAPPT_STATUS 
       ELSE NULL END                                                    APPT_STATUS
,      REP.REPLOA
,      (    SELECT NVL(SUM(ACBBALANCE_AMT),0) BAL_AMT_BRAND
            FROM AR_CURRENT_BALANCE 
            WHERE ACBOU_CODE = REP.REPOU_CODE
            AND ACBREP_SEQ = REP.REPREP_SEQ
            AND DECODE(ACBBRAND_CODE,1,'M',2,'M',3,'F') = :P_BRAND)                                                AR_BALANCE
,      NVL(OM2.M_AMT_B1,0)                                              M_AMT_B1
,      NVL(OM2.M_AMT_B2,0)                                              M_AMT_B2 
,      NVL(OM2.M_AMT_B3,0)                                              M_AMT_B3
,      NVL(OM2.C_AMT_B1,0)                                              C_AMT_B1
,      NVL(OM2.C_AMT_B2,0)                                              C_AMT_B2 
,      NVL(OM2.C_AMT_B3,0)                                              C_AMT_B3 
,      NVL(OM2.RTN_AMT,0)                                               RTN_AMT 
,      OCS.CPSYTD_RETURN                                                YTD_RETURN
,      CDT.PV1_AMT 
,      CDT.PV2_AMT 
,      CDT.PV3_AMT 
,      DECODE(:P_BRAND,'M',(NVL(OCS.cpsytd_ntbmis,0)*1.07) + (NVL(OCS.cpsytd_ntbfri,0)*1.07), 'F',(NVL(OCS.cpsytd_canfar,0)*1.07) ) YTD_SALES
,      OM2.OHDTRANS_NO
, 0                                             POINT_BALANCE
FROM   MS_REPRESENTATIVE REP
,      MS_REP_BY_BRAND REB
,      DB_MAILPLAN       MPL
,      DB_MAILPLAN_DTL   MPD   
,      OM_CAMPAIGN_SUM    OCS
,      DB_SALES_LOCATION LOC
,      (
SELECT INF.OU_CODE
             , INF.REP_SEQ
             , INF.REP_CODE 
             , SUM(INF.PV1_AMT)   PV1_AMT
             , SUM(INF.PV2_AMT)   PV2_AMT
             , SUM(INF.PV3_AMT)   PV3_AMT
        FROM (  SELECT OHDOU_CODE      OU_CODE
                     , OHDUPD_REP_SEQ  REP_SEQ
                     , OHDUPD_REP_CODE REP_CODE
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS4.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS3.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(TSDDUE_AMT,0)
                           ELSE 0 END 
                          ) PV3_AMT 
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS3.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS2.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(TSDDUE_AMT,0)
                           ELSE 0 END 
                          ) PV2_AMT 
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS2.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(TSDDUE_AMT,0)
                           ELSE 0 END 
                          ) PV1_AMT 
                FROM   OM_TRANSACTION_HDR
                ,      AR_TRANSACTIONS_DTL
                ,      DB_MAILPLAN_SALES MS0
                ,      DB_MAILPLAN_SALES MS1
                ,      DB_MAILPLAN_SALES MS2
                ,      DB_MAILPLAN_SALES MS3
                ,      DB_MAILPLAN_SALES MS4
                WHERE  OHDOU_CODE             = :S_OU_CODE
                AND    TRUNC("OHDTRANS_DATE") BETWEEN TRUNC(NVL(MS4.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999
                AND    OHDTRANS_GROUP = :P_TRANS_GROUP
                AND    TSDOU_CODE     = OHDOU_CODE
                AND    TSDYEAR        = OHDYEAR
                AND    TSDTRANS_TYPE  IN (:INV_TYPE, :TR_TYPE)
                AND    TSDTRANS_NO    = OHDTRANS_NO
                AND    TSDPERIOD      = 1
                AND    DECODE(TSDBRAND_CODE,1,'M',2,'M',3,'F') = :P_BRAND
                AND    MS0.MPSOU_CODE     = OHDOU_CODE
                AND    MS0.MPSYEAR        = SUBSTR(:P_CAMPAIGN,3,4)
                AND    MS0.MPSCAMPAIGN    = :P_CAMPAIGN
                AND    MS0.MPSLOC_CODE    = OHDLOC_CODE
                AND    TRUNC(MS0.MPSSHIPDATE) = TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))
                AND    MS1.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS2.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS2.MPSYEAR(+)        = SUBSTR(:P_CAMP2,3,4)
                AND    MS2.MPSCAMPAIGN(+)    = :P_CAMP2
                AND    MS2.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS3.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS3.MPSYEAR(+)        = SUBSTR(:P_CAMP3,3,4)
                AND    MS3.MPSCAMPAIGN(+)    = :P_CAMP3
                AND    MS3.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS4.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS4.MPSYEAR(+)        = SUBSTR(:P_CAMP4,3,4)
                AND    MS4.MPSCAMPAIGN(+)    = :P_CAMP4
                AND    MS4.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    OHDUPD_REP_CODE  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
                AND    OHDLOC_CODE      BETWEEN NVL(:S_LOC_CODE,'!') AND NVL(:E_LOC_CODE,CHR(250))
                AND    OHDNSM           BETWEEN NVL(:S_NSM_CODE,'!') AND NVL(:E_NSM_CODE,CHR(250))  
                AND    OHDDIV           BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
                GROUP BY OHDOU_CODE
                       , OHDUPD_REP_SEQ
                       , OHDUPD_REP_CODE
                UNION ALL
                SELECT OHDOU_CODE      OU_CODE
                     , OHDUPD_REP_SEQ  REP_SEQ
                     , OHDUPD_REP_CODE REP_CODE
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS4.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS3.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(ORBNTB,0)
                           ELSE 0 END 
                          ) PV3_AMT 
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS3.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS2.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(ORBNTB,0)
                           ELSE 0 END 
                          ) PV2_AMT 
                     , SUM(
                           CASE WHEN (NVL(OHDTRANS_GROUP,'!') IN (:P_TRANS_GROUP,:P_TRANS2)) AND (OHDTRANS_DATE BETWEEN TRUNC(NVL(MS2.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999) THEN   
                                NVL(ORBNTB,0)
                           ELSE 0 END 
                          ) PV1_AMT 
                FROM   OM_TRANSACTION_HDR
                ,      OM_ORDER_HDRG     
                ,      DB_MAILPLAN_SALES MS0
                ,      DB_MAILPLAN_SALES MS1
                ,      DB_MAILPLAN_SALES MS2
                ,      DB_MAILPLAN_SALES MS3
                ,      DB_MAILPLAN_SALES MS4
                WHERE  OHDOU_CODE             = :S_OU_CODE
                AND    TRUNC("OHDTRANS_DATE") BETWEEN TRUNC(NVL(MS4.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+0.99999
                AND    OHDTRANS_GROUP = :P_TRANS2
                AND    OHDCANCEL_DATE IS NULL
                AND    MS0.MPSOU_CODE     = OHDOU_CODE
                AND    MS0.MPSYEAR        = SUBSTR(:P_CAMPAIGN,3,4)
                AND    MS0.MPSCAMPAIGN    = :P_CAMPAIGN
                AND    MS0.MPSLOC_CODE    = OHDLOC_CODE
                AND    TRUNC(MS0.MPSSHIPDATE) = TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))
                AND    MS1.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS2.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS2.MPSYEAR(+)        = SUBSTR(:P_CAMP2,3,4)
                AND    MS2.MPSCAMPAIGN(+)    = :P_CAMP2
                AND    MS2.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS3.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS3.MPSYEAR(+)        = SUBSTR(:P_CAMP3,3,4)
                AND    MS3.MPSCAMPAIGN(+)    = :P_CAMP3
                AND    MS3.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    MS4.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS4.MPSYEAR(+)        = SUBSTR(:P_CAMP4,3,4)
                AND    MS4.MPSCAMPAIGN(+)    = :P_CAMP4
                AND    MS4.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    OHDUPD_REP_CODE  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
                AND    OHDLOC_CODE      BETWEEN NVL(:S_LOC_CODE,'!') AND NVL(:E_LOC_CODE,CHR(250))
                AND    OHDNSM           BETWEEN NVL(:S_NSM_CODE,'!') AND NVL(:E_NSM_CODE,CHR(250))  
                AND    OHDDIV           BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
                AND    OHDOU_CODE     = ORBOU_CODE
                AND    OHDYEAR        = ORBINV_YEAR
                AND    OHDTRANS_GROUP = :P_TRANS2
                AND    OHDTRANS_NO    = ORBINV_NO
                AND    ORBSOURCE      = 'CS'
                AND    DECODE(ORBBRAND,1,'M',2,'M',3,'F') = :P_BRAND
                GROUP BY OHDOU_CODE
                       , OHDUPD_REP_SEQ
                       , OHDUPD_REP_CODE
             ) INF
        GROUP BY INF.OU_CODE
               , INF.REP_SEQ
               , INF.REP_CODE 
               ) CDT
,      (SELECT CURR.OU_CODE
             , CURR.REP_SEQ
             , CURR.REP_CODE
             , CURR.OHDTRANS_NO
             , CURR.OHDTRANS_DATE
             , SUM(NVL(CURR.M_AMT_B1,0)) M_AMT_B1
             , SUM(NVL(CURR.M_AMT_B2,0)) M_AMT_B2
             , SUM(NVL(CURR.M_AMT_B3,0)) M_AMT_B3
             , 0  C_AMT_B1
             , 0  C_AMT_B2
             , 0  C_AMT_B3
             , 0  RTN_AMT  
        FROM (
            SELECT OHDOU_CODE      OU_CODE
                 , OHDUPD_REP_SEQ  REP_SEQ
                 , OHDUPD_REP_CODE REP_CODE
                 , OHDTRANS_NO
                 , OHDTRANS_DATE
                 , SUM(
                       CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS_GROUP) AND (TSDBRAND_CODE = :P_BRAND1) THEN
                                CASE WHEN TSDTRANS_TYPE = :INV_TYPE THEN
                                     ROUND(NVL(TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                                ELSE NVL(TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B1
                 , SUM(
                       CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS_GROUP) AND (TSDBRAND_CODE = :P_BRAND2) THEN
                                CASE WHEN TSDTRANS_TYPE = :INV_TYPE THEN
                                     ROUND(NVL(TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                                ELSE NVL(TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B2
                 , SUM(
                       CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS_GROUP) AND (TSDBRAND_CODE = :P_BRAND3) THEN
                                CASE WHEN TSDTRANS_TYPE = :INV_TYPE THEN
                                     ROUND(NVL(TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                                ELSE NVL(TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B3
                 , 0  C_AMT_B1
                 , 0  C_AMT_B2
                 , 0  C_AMT_B3
                 , 0  RTN_AMT  
                FROM   OM_TRANSACTION_HDR
                ,      AR_TRANSACTIONS_DTL
                ,      DB_MAILPLAN_SALES MS1
                WHERE  OHDOU_CODE             = :S_OU_CODE
                AND    TRUNC("OHDTRANS_DATE") BETWEEN TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))+0.99999
                AND    OHDTRANS_GROUP = :P_TRANS_GROUP
                AND    NVL(OHDNET_AMOUNT_AFTDISC,0) > 0
                AND    TSDOU_CODE     = OHDOU_CODE
                AND    TSDYEAR        = OHDYEAR
                AND    TSDTRANS_TYPE  IN (:INV_TYPE, :TR_TYPE)
                AND    TSDTRANS_NO    = OHDTRANS_NO
                AND    TSDPERIOD      = 1
                AND    DECODE(TSDBRAND_CODE,1,'M',2,'M',3,'F') = :P_BRAND
                AND    MS1.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = OHDLOC_CODE
                AND    OHDUPD_REP_CODE  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
                AND    OHDLOC_CODE      BETWEEN NVL(:S_LOC_CODE,'!') AND NVL(:E_LOC_CODE,CHR(250))
                AND    OHDNSM           BETWEEN NVL(:S_NSM_CODE,'!') AND NVL(:E_NSM_CODE,CHR(250))  
                AND    OHDDIV           BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
            GROUP BY OHDOU_CODE
                   , OHDUPD_REP_SEQ 
                   , OHDUPD_REP_CODE
                   , OHDTRANS_NO
                   , OHDTRANS_DATE
            UNION ALL
            SELECT TSH.TSHOU_CODE       OU_CODE
                 , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_SEQ","TSHUPD_REP_SEQ")   REP_SEQ
                 , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE") REP_CODE
                 , TSH.TSHTRANS_NO      OHDTRANS_NO
                 , TSH.TSHDOC_DATE      OHDTRANS_DATE
                 , SUM(
                       CASE WHEN (TSD.TSDBRAND_CODE = :P_BRAND1) THEN
                            CASE WHEN TSD.TSDTRANS_TYPE = :P_REV_TYPE THEN
                                 -ROUND(NVL(TSD.TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                            ELSE -NVL(TSD.TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B1
                 , SUM(
                       CASE WHEN (TSD.TSDBRAND_CODE = :P_BRAND2) THEN
                            CASE WHEN TSD.TSDTRANS_TYPE = :P_REV_TYPE THEN
                                 -ROUND(NVL(TSD.TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                            ELSE -NVL(TSD.TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B2
                 , SUM(
                       CASE WHEN (TSD.TSDBRAND_CODE = :P_BRAND3) THEN
                            CASE WHEN TSD.TSDTRANS_TYPE = :P_REV_TYPE THEN
                                 -ROUND(NVL(TSD.TSDDUE_AMT,0)*100/(100+NVL(:P_VRATE,0)),2)
                            ELSE -NVL(TSD.TSDDUE_AMT,0) END
                       ELSE 0 END 
                       ) M_AMT_B3
                 , 0  C_AMT_B1
                 , 0  C_AMT_B2
                 , 0  C_AMT_B3
                 , 0  RTN_AMT  
            FROM   AR_TRANSACTIONS_HDR TSH
            ,      AR_TRANSACTIONS_DTL TSD
            ,      DB_MAILPLAN_SALES MS1
            WHERE  TSH.TSHTRANS_TYPE    IN (:P_REV_TYPE , :P_REV_TR)
            AND    TSH.TSHOU_CODE      = :S_OU_CODE
            AND    DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE")  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
            AND    TSH.TSHAR_TYPE      = '2'
            AND    TSH.TSHDOC_DATE     BETWEEN TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))+0.99999
            AND    TSH.TSHDIVISION_CODE BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
            AND    TSD.TSDOU_CODE      = TSH.TSHOU_CODE
            AND    TSD.TSDYEAR         = TSH.TSHYEAR
            AND    TSD.TSDTRANS_TYPE   = TSH.TSHTRANS_TYPE
            AND    TSD.TSDTRANS_NO     = TSH.TSHTRANS_NO
            AND    TSD.TSDPERIOD       = TSH.TSHPERIOD
            AND    DECODE(TSD.TSDBRAND_CODE,1,'M',2,'M',3,'F') = :P_BRAND
            AND    NOT EXISTS (SELECT  'X'
                               FROM    OM_TRANSACTION_HDR SIV
                               WHERE   SIV.OHDOU_CODE     =  TSH.TSHOU_CODE
                               AND     SIV.OHDYEAR        =  TSH.TSHYEAR
                               AND     SIV.OHDTRANS_GROUP IN (:P_TRANS_GROUP,:P_TRANS2) 
                               AND     SIV.OHDTRANS_NO    =  TSH.TSHTRANS_NO
                               AND     SIV.OHDCANCEL_DATE IS NULL
                               AND     TO_CHAR(SIV.OHDCANCEL_DATE,'MMRRRR') <> TO_CHAR(TSH.TSHDOC_DATE,'MMRRRR')
                              )
                AND    MS1.MPSOU_CODE(+)     = TSH.TSHOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = TSH.TSHDISTRICT_CODE
            GROUP BY TSH.TSHOU_CODE      
                   , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_SEQ","TSHUPD_REP_SEQ")
                   , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE")
                   , TSH.TSHTRANS_NO
                   , TSH.TSHDOC_DATE
                               ) CURR
        GROUP BY   CURR.OU_CODE
             , CURR.REP_SEQ
             , CURR.REP_CODE
             , CURR.OHDTRANS_NO
             , CURR.OHDTRANS_DATE
        UNION ALL
        SELECT TSH.TSHOU_CODE       OU_CODE
             , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_SEQ","TSHUPD_REP_SEQ")   REP_SEQ
             , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE") REP_CODE
             , TSHTRANS_NO              OHDTRANS_NO
             , TSH.TSHDOC_DATE      OHDTRANS_DATE
             , 0                    M_AMT_B1
             , 0                    M_AMT_B2
             , 0                    M_AMT_B3
             , 0                    C_AMT_B1
             , 0                    C_AMT_B2
             , 0                    C_AMT_B3
             , SUM( (NVL(TSD.TSDDUE_AMT,0) / 1.07) ) RTN_AMT
        FROM   AR_TRANSACTIONS_HDR TSH
        ,      AR_TRANSACTIONS_DTL TSD
        ,      DB_MAILPLAN_SALES MS1
        WHERE  TSH.TSHTRANS_TYPE    IN (:P_RET_TYPE , :P_CN_TYPE)
        AND    TSH.TSHOU_CODE      = :S_OU_CODE
        AND    DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE")  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
        AND    TSH.TSHAR_TYPE      = '2'
        AND    TSH.TSHDOC_DATE     BETWEEN TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))+0.99999
        AND    TSH.TSHDIVISION_CODE BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
        AND    TSD.tsdou_code = TSH.tshou_code
        AND    TSD.tsdyear = TSH.tshyear
        AND    TSD.tsdtrans_type = TSH.tshtrans_type
        AND    TSD.tsdtrans_no = TSH.tshtrans_no
        AND    DECODE(TSD.tsdbrand_code,1,'M',2,'M',3,'F') = :P_BRAND
        AND    (
                (TSH.TSHTRANS_TYPE   = :P_RET_TYPE) 
               ) 
                AND    MS1.MPSOU_CODE(+)     = TSH.TSHOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = TSH.TSHDISTRICT_CODE
        GROUP BY TSH.TSHOU_CODE
               , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_SEQ","TSHUPD_REP_SEQ")
               , DECODE("TSHBD_TRAN_FLAG",2,"TSHREF_REP_CODE","TSHUPD_REP_CODE")
               , TSHTRANS_NO
               , TSH.TSHDOC_DATE   
/*  CASH SALE NOT USE 13/01/2014 BY PERAPONG
        UNION ALL
        SELECT OHDOU_CODE      OU_CODE
             , OHDUPD_REP_SEQ  REP_SEQ
             , OHDUPD_REP_CODE REP_CODE
             , OHDTRANS_NO
             , OHDTRANS_DATE
             , 0 M_AMT_B1
             , 0 M_AMT_B2
             , 0 M_AMT_B3
             , SUM(
                   CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS2)  AND (ORBBRAND = :P_BRAND1) THEN
                        NVL(ORBNTB,0)
                   ELSE 0 END 
                   ) C_AMT_B1
             , SUM(
                   CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS2)  AND (ORBBRAND = :P_BRAND2) THEN
                        NVL(ORBNTB,0)
                   ELSE 0 END 
                   ) C_AMT_B2
             , SUM(
                   CASE WHEN TRUNC(OHDTRANS_DATE) >= TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND (OHDTRANS_GROUP = :P_TRANS2)  AND (ORBBRAND = :P_BRAND3) THEN
                        NVL(ORBNTB,0)
                   ELSE 0 END 
                   ) C_AMT_B3
             , 0  RTN_AMT  
                FROM   OM_TRANSACTION_HDR
                ,      OM_ORDER_HDRG     
                ,      DB_MAILPLAN_SALES MS1
                WHERE  OHDOU_CODE             = :S_OU_CODE
                AND    TRUNC("OHDTRANS_DATE") BETWEEN TRUNC(NVL(MS1.MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))+0.99999
                AND    OHDTRANS_GROUP = :P_TRANS2
                AND    DECODE(ORBBRAND,1,'M',2,'M',3,'F') = :P_BRAND
                AND    OHDCANCEL_DATE IS NULL
                AND    NVL(OHDNET_AMOUNT_AFTDISC,0) > 0
                AND    OHDUPD_REP_CODE  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
                AND    OHDLOC_CODE      BETWEEN NVL(:S_LOC_CODE,'!') AND NVL(:E_LOC_CODE,CHR(250))
                AND    OHDNSM           BETWEEN NVL(:S_NSM_CODE,'!') AND NVL(:E_NSM_CODE,CHR(250))  
                AND    OHDDIV           BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
                AND    OHDOU_CODE     = ORBOU_CODE
                AND    OHDYEAR        = ORBINV_YEAR
                AND    OHDTRANS_GROUP = :P_TRANS2
                AND    OHDTRANS_NO    = ORBINV_NO
                AND    ORBSOURCE      = 'CS'
                AND    DECODE(ORBBRAND,1,'M',2,'M',3,'F') = :P_BRAND
                AND    MS1.MPSOU_CODE(+)     = OHDOU_CODE
                AND    MS1.MPSYEAR(+)        = SUBSTR(:P_CAMP1,3,4)
                AND    MS1.MPSCAMPAIGN(+)    = :P_CAMP1
                AND    MS1.MPSLOC_CODE(+)    = OHDLOC_CODE
        GROUP BY OHDOU_CODE
               , OHDUPD_REP_SEQ 
               , OHDUPD_REP_CODE
               , OHDTRANS_NO
               , OHDTRANS_DATE
*/
        UNION ALL
        SELECT ORBOU_CODE           OU_CODE
             , ORBUPD_REP_SEQ       REP_SEQ
             , ORBUPD_REP_CODE      REP_CODE
             , ORBINV_NO            OHDTRANS_NO
             , ORBCANCEL_DATE       OHDTRANS_DATE
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '11' AND ORBBRAND = :P_BRAND1 THEN -ORBNTB
                    ELSE 0 END
               )                    M_AMT_B1
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '11' AND ORBBRAND = :P_BRAND2 THEN -ORBNTB
                    ELSE 0 END
               )                    M_AMT_B2
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '11' AND ORBBRAND = :P_BRAND3 THEN -ORBNTB
                    ELSE 0 END
               )                    M_AMT_B3
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '12' AND ORBBRAND = :P_BRAND1 THEN -ORBNTB
                    ELSE 0 END
               )                    C_AMT_B1
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '12' AND ORBBRAND = :P_BRAND2 THEN -ORBNTB
                    ELSE 0 END
               )                    C_AMT_B2
             , SUM(
                    CASE WHEN SUBSTR(ORBINV_NO,1,2) = '12' AND ORBBRAND = :P_BRAND3 THEN -ORBNTB
                    ELSE 0 END
               )                    C_AMT_B3
             , 0                    RTN_AMT
        FROM   OM_ORDER_HDRG     
        ,      DB_MAILPLAN_SALES 
        WHERE  ORBOU_CODE      = :S_OU_CODE
        AND    ORBSOURCE       IN ('IV','IT')
        AND    DECODE(ORBBRAND,1,'M',2,'M',3,'F') = :P_BRAND
        AND    TRUNC("ORBCANCEL_DATE") BETWEEN TRUNC(NVL(MPSSHIPDATE,TO_DATE('01/01/0001','DD/MM/RRRR')))+1 AND TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))+0.99999
        AND    MPSOU_CODE     = ORBOU_CODE
        AND    MPSYEAR        = SUBSTR(:P_CAMP1,3,4)
        AND    MPSCAMPAIGN    = :P_CAMP1
        AND    MPSLOC_CODE    = ORBDISTRICT
        AND    TRUNC("MPSSHIPDATE") = TRUNC(TO_DATE(:P_LAST_SHIP,'DD/MM/RRRR'))-1
        AND    TO_CHAR(ORBINV_DATE,'MMRRRR') <> TO_CHAR(ORBCANCEL_DATE,'MMRRRR')
        GROUP BY ORBOU_CODE           
               , ORBUPD_REP_SEQ       
               , ORBUPD_REP_CODE      
               , ORBINV_NO            
               , ORBCANCEL_DATE 
       )  OM2       
WHERE  REP.REPOU_CODE   = :S_OU_CODE
AND    REP.REPREP_CODE  BETWEEN NVL(:S_REP_CODE,'!') AND NVL(:E_REP_CODE,CHR(250))
AND    REP.REPLOC_CODE  BETWEEN NVL(:S_LOC_CODE,'!') AND NVL(:E_LOC_CODE,CHR(250))
AND    REP.REPAPPT_STATUS <> 'DE'
AND    REB.OU_CODE      = REP.REPOU_CODE
AND    REB.BRAND_GROUP  LIKE :P_BRAND || '%'
AND    REB.REP_SEQ      = REP.REPREP_SEQ
AND    REB.APPT_STATUS  NOT IN ('RE','DE')
AND    SUBSTR(REP.REPREP_LOCATION,1,INSTR(REP.REPREP_LOCATION,'|')-1) BETWEEN NVL(:S_NSM_CODE,'!') AND NVL(:E_NSM_CODE,CHR(250))  
AND    SUBSTR(REP.REPREP_LOCATION,INSTR(REP.REPREP_LOCATION,'|')+1)   BETWEEN NVL(:S_DIV_CODE,'!') AND NVL(:E_DIV_CODE,CHR(250))
AND    REP.REPLOC_CODE  = MPD.MDTLOC_CODE
AND    MPL.MPLOU_CODE   = REP.REPOU_CODE 
AND    TRUNC("MPLSHIPDATE") = TRUNC(TO_DATE(:S_DATE,'DD/MM/RRRR'))
AND    MPD.MDTOU_CODE   = MPL.MPLOU_CODE
AND    MPD.MDTYEAR      = MPL.MPLYEAR
AND    MPD.MDTCAMPAIGN  = MPL.MPLCAMPAIGN
AND    MPD.MDTMAILGROUP = MPL.MPLMAILGROUP
AND    OCS.CPSOU_CODE(+)        = REP.REPOU_CODE
AND    OCS.CPSCAMPAIGN_CODE(+)  = :P_CAMPAIGN
AND    OCS.CPSREP_SEQ(+)        = REP.REPREP_SEQ
AND    CDT.OU_CODE(+)           = REP.REPOU_CODE
AND    CDT.REP_SEQ(+)           = REP.REPREP_SEQ
AND    OM2.OU_CODE(+)           = REP.REPOU_CODE
AND    OM2.REP_SEQ(+)           = REP.REPREP_SEQ
AND    REP.REPOU_CODE       = LOC.DSTOU_CODE
AND    REP.REPLOC_CODE     = LOC.DSTLOC_CODE
AND    NVL(LOC.DSTSPECIAL_STATUS,'0') = '0'
AND    ( 
              (REP.REPAR_STATUS <> 'BD' AND REP.REPAPPT_STATUS <> 'RE') OR
              (REP.REPAR_STATUS = 'BD' AND (NVL(OM2.M_AMT_B1,0)+NVL(OM2.M_AMT_B2,0)+NVL(OM2.M_AMT_B3,0)+NVL(OM2.C_AMT_B1,0)+NVL(OM2.C_AMT_B2,0)+NVL(OM2.C_AMT_B3,0)+NVL(OM2.RTN_AMT,0)) <> 0)
            )
--AND   (
       --(NVL(OCS.CPSYTD_NETSALES,0) <> 0) OR
       --(SUBSTR(NVL(REP.REPAPPT_ST_CAMPAIGN,REP.REPAPPT_CAMPAIGN),3,4)||SUBSTR(NVL(REP.REPAPPT_ST_CAMPAIGN,REP.REPAPPT_CAMPAIGN),1,2) >= SUBSTR(:P_CAMP3,3,4)||SUBSTR(:P_CAMP3,1,2)) --OR 
       --(SUBSTR(REP.REPREP_CODE,5,5) = '99999')
--      )
/*AND CASE WHEN (NVL(OCS.CPSYTD_NETSALES,0) <> 0) AND (NVL(OM2.M_AMT_B1,0) + NVL(OM2.M_AMT_B2,0) + NVL(OM2.M_AMT_B3,0) + NVL(OM2.RTN_AMT,0) + NVL(CDT.PV1_AMT,0) + NVL(CDT.PV2_AMT,0) + NVL(CDT.PV3_AMT,0) = 0) AND (NVL(CASE WHEN REP.REPAPPT_STATUS IN ('TI','RI') AND REP.REPAPPT_ST_CAMPAIGN IN (:P_CAMP1,:P_CAMPAIGN) THEN REP.REPAPPT_STATUS 
                                                                                                                                                                           ELSE NULL END                                                                                                                                                                           
                                                                                                                                                                           ,'!') IN ('RI','TI')) THEN 'N'
    ELSE 'Y' END = 'Y'*/
ORDER BY 3, 4, 7, 9, OM2.OHDTRANS_NO
