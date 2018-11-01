

DROP MATERIALIZED VIEW BWPROD.BEMV_IA_SUMMARY
/


CREATE MATERIALIZED VIEW BWPROD.BEMV_IA_SUMMARY
BUILD IMMEDIATE
REFRESH START WITH to_date('13-10-2014 04:30 PM', 'DD-MM-YYYY HH12:MI PM')
 NEXT sysdate + 1
FORCE
AS SELECT brand,
       send_date,
    SUM(total) total,
    SUM(success) success,
    SUM(auto) auto,
    SUM(pending) pending,
    SUM(process) process,
    SUM(cs_reject) cs_reject ,
    SUM(at_reject) at_reject ,
    SUM(rec_senddp) rec_senddp,
    SUM(auto_no8) auto_no8
  FROM
    (SELECT v.*
    FROM bev$_ia_sum_dist v
    ) vvv
  GROUP BY brand, send_date


/

/*    JOB IA SUMMARY    */

begin     DBMS_SNAPSHOT.REFRESH('BEMV_IA_SUMMARY'); end;

select * from BEMV_IA_SUMMARY where send_date = trunc(sysdate)

SELECT * FROM BWPROD_BEV_IA_SUMMARY
SELECT * FROM BWPROD.BEV_IA_SUMMARY
