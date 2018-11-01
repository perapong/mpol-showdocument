SELECT t.ou,  t.camp, t.camp_disp,  t.nsm, 
               'x' stotyp,  'x' stotyp_disp,  pkgbw_misc.getxdivcode(t.dist)  divcode, 
               t.rep_code, t.no_order, t.net_amt, t.avg_amt, t.rep_code2,
               t.dist, t.mslno, t.chkdgt, t.loa, t.ytd
FROM TABLE (PKG_BW_GC_REPORT.FPU_TAB_BEGCRP14)  t
--where rep_code2 = '0140015521'
ORDER BY  t.nsm, divcode , t.rep_code


PKG_BW_GC_REPORT.FPU_TAB_BEGCRP14

begin
    PKG_BW_GC_PARAM.SET_BEGCRP14_PARAM(1, --:P_NSM_F,
                                       1, --:P_NSM_T,
                                       '201401',    --:P_CAMPAIGN_F,
                                       '201413');   --:P_CAMPAIGN_T);
end;

select PKG_BW_GC_PARAM.GET_BEGCRP14_NSM_F,
       PKG_BW_GC_PARAM.GET_BEGCRP14_NSM_T,
       PKG_BW_GC_PARAM.GET_BEGCRP14_CAMP_F,
       PKG_BW_GC_PARAM.GET_BEGCRP14_CAMP_T
from dual

FUNCTION FPU_TAB_BEGCRP14  RETURN TAB_BEGCRP14  pipelined  IS

    TabOut              TAB_BEGCRP14;
    rRefCur             sys_refcursor;

    vTmp_nsm_f          VARCHAR2(5);
    vTmp_nsm_t          VARCHAR2(5);
    nTmp_camp_f         NUMBER;
    nTmp_camp_t         NUMBER;


BEGIN
    vTmp_nsm_f          := PKG_BW_GC_PARAM.GET_BEGCRP14_NSM_F;
    vTmp_nsm_t          := PKG_BW_GC_PARAM.GET_BEGCRP14_NSM_T;
    nTmp_camp_f         := PKG_BW_GC_PARAM.GET_BEGCRP14_CAMP_F;
    nTmp_camp_t         := PKG_BW_GC_PARAM.GET_BEGCRP14_CAMP_T;


     BEGIN
        OPEN rRefCur FOR
            SELECT t2.ou,       t2.camp,        t2.camp_disp,   t2.nsm,
                   trim(t2.stotyp) stotyp ,   trim(t2.stotyp_disp) stotyp_disp,
                   t2.rep_code, t2.no_order,    t2.net_amt,     t2.avg_amt,     t2.rep_code2,
                   t2.dist,     t2.mslno,       t2.chkdgt,      t2.loa,         t2.ytd
            FROM (
                    SELECT 'OU' ou,
                           to_char(nTmp_camp_t) camp,
                           substr(nTmp_camp_t,5,2)||'/'||substr(nTmp_camp_t,1,4) camp_disp,
                           to_char(t1.nsm) nsm,
                           TRIM(NVL(replace(x.stotyp,' ','') ,
                                    SUBSTR(STF_GC_GET_stotype (t1.dist, t1.mslno, t1.chkdgt),2)
                                    )
                               ) stotyp,
                           TRIM(NVL(DECODE(nvl( replace(x.stotyp,' ','') ,'^'),'^', x.stotyp, 'G'||x.stotyp) ,
                               STF_GC_GET_stotype (t1.dist, t1.mslno, t1.chkdgt)
                               )) stotyp_disp,

                           t1.rep_code, x.no_order, x.net_amt, (x.net_amt/x.no_order) avg_amt, t1.rep_code2,
                           t1.dist, t1.mslno, t1.chkdgt, x.loa, t1.ytd
                    FROM
                    (
                    SELECT DISTINCT
                           g1.nsm,
                           g1.dist, g1.mslno, g1.chkdgt,
                           replace(lpad(g1.dist,4,'0')||'-'||lpad(g1.mslno,5,'0')||'-'||lpad(g1.chkdgt,1,'0'),' ','') rep_code,
                           replace(lpad(g1.dist,4,'0')||lpad(g1.mslno,5,'0')||lpad(g1.chkdgt,1,'0'),' ','') rep_code2,
                           STF_GC_GET_YTD_BY_REP_CODE (g1.dist, g1.mslno, g1.chkdgt, nTmp_camp_t) ytd
                    FROM   as400_mslgcm g1
                    WHERE  g1.nsm     BETWEEN vTmp_nsm_f      AND vTmp_nsm_t
                    AND    g1.camp    BETWEEN nTmp_camp_f     AND nTmp_camp_t
                    ) t1 LEFT OUTER JOIN
                    (
                    SELECT a.stotyp, a.dist, a.mslno, a.chkdgt, a.loa,
                           SUM(nvl(a.netsales,0)) net_amt, 1 no_order
                    FROM  as400_mslgcm a
                    WHERE   a.nsm     BETWEEN vTmp_nsm_f      AND vTmp_nsm_t
                    AND     a.camp    =       nTmp_camp_t
                    GROUP BY a.stotyp,  a.dist, a.mslno, a.chkdgt, a.loa
                    ) x ON TRIM(x.dist) = TRIM(t1.dist) AND x.mslno = t1.mslno AND x.chkdgt = t1.chkdgt

               )  t2

               ORDER BY t2.nsm, t2.stotyp, t2.rep_code;

    END;



    LOOP
        fetch rRefCur bulk collect into TabOut limit 10000;
        exit when TabOut.count = 0;
        FOR i in 1 .. TabOut.count LOOP
            pipe row (TabOut(i));
        END LOOP;
    END LOOP;

END;
