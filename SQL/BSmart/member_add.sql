begin
    zp_pkg_test.REG_Member_FA017_20;
    --zp_pkg_test.REG_Member_NMS18_21;
end;

-------------------  FARIS  MEMBER  ----------------------------------------------------------------------------------------------------------------------
-------------------  FARIS  MEMBER  ----------------------------------------------------------------------------------------------------------------------
-------------------  FARIS  MEMBER  ----------------------------------------------------------------------------------------------------------------------
select d.*, pkgms_master.getrepname_byseq('000', mmdrep_seq) name
from db_member_dtl d
where mmdou_code = '000'
  and mmdclub_code like 'FA01%'
  and mmdrep_code like '8%'
  and mmdupd_rep_date > to_date('15/08/2013','dd/mm/rrrr')
--and mmdrep_seq = 6571591
  and exists (select * from om_order_hdr o where o.bihou_code = '000' and o.bihsales_campaign = '172013' and bihrep_seq = mmdrep_seq--6578364--
  and bihorder_date between to_date('14/08/2013','dd/mm/rrrr') and sysdate)
  
  
DECLARE
    cursor rec is
        select 'FA0'||substr(repappt_campaign,1,2) clubcode, ms.* 
        from ms_representative ms 
        where ms.repou_code = '000' 
          and ms.reprep_code like '8%' 
          --and ms.reprep_code = '8175008393'
          --and ms.repappt_date = trunc(sysdate)
          --and ms.repcre_date between to_date('15/08/2013 10:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('15/08/2013 11:00:00','dd/mm/rrrr hh24:mi:ss')
          --and ms.repcre_date between (sysdate-0.06) and sysdate
          and not exists (select 1 from db_member_dtl d where mmdou_code = '000' and mmdclub_code like 'FA01%' and mmdrep_seq = ms.reprep_seq and mmdrep_code like '8%')
          and not exists (select 1 from db_member_dtl_ex d where mmdou_code = '000' and mmdclub_code like 'FA01%' and mmdrep_seq = ms.reprep_seq and mmdrep_code like '8%')
          and repappt_campaign in ('172013','182013','192013','202013')
        ;
    vTmp VARCHAR2(200);
    vErr VARCHAR2(200);
BEGIN
    For Trec In Rec Loop
        Begin 
            vTmp := zp_pkg_test.RegisterMember (Trec.repou_code, Trec.reprep_code, Trec.clubcode, 'ia-system', 'ia-system', vErr);
        End;
        commit;
    End Loop;
END;

select * from db_member_dtl a where mmdou_code = '000'
--and a.mmdrep_seq = 6559649
and mmdprog_id = 'ia-system'
and trunc(mmdupd_rep_date) = trunc(sysdate)


-------------------  MISTINE  MEMBER  ----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
select d.*, pkgms_master.getrepname_byseq('000', mmdrep_seq) name
from db_member_dtl d
where mmdou_code = '000'
  and mmdclub_code like 'NMS%'
--and mmdupd_rep_date > to_date('15/08/2013','dd/mm/rrrr')
  and mmdrep_seq = 6571591


DECLARE
    cursor rec is
        select 'NMS'||substr(repappt_campaign,1,2) clubcode, ms.* 
        from ms_representative ms 
        where ms.repou_code = '000' 
          and ms.reprep_code not like '8%' 
          and ms.reploc_code not in (select dist_code from bev$_skipdist)
          --6581034
          --and ms.repappt_date = to_date('15/08/2013','dd/mm/rrrr')
          --and ms.repcre_date between to_date('01/08/2013 00:00:00','dd/mm/rrrr hh24:mi:ss') and to_date('15/08/2013 11:00:00','dd/mm/rrrr hh24:mi:ss')
          and ms.repcre_date between (sysdate-0.94) and sysdate
          and repappt_campaign in ('182013','192013','202013','212013')
          and not exists (select 1 from db_member_dtl d where mmdou_code = '000' and mmdclub_code like 'NMS%' and mmdrep_seq = ms.reprep_seq)
          and not exists (select 1 from db_member_dtl_ex d where mmdou_code = '000' and mmdclub_code like 'FA0%' and mmdrep_seq = ms.reprep_seq and mmdrep_code like '8%')
        ;
    vTmp VARCHAR2(200);
    vErr VARCHAR2(200);
BEGIN
    For Trec In Rec Loop
        Begin 
            vTmp := zp_pkg_test.RegisterMember (Trec.repou_code, Trec.reprep_code, Trec.clubcode, 'ia-system', 'ia-system', vErr);
        End;
        commit;
    End Loop;
END;

select * from db_member_dtl a where mmdou_code = '000'
--and a.mmdrep_seq = 6559649
and mmdprog_id = 'ia-system'
and trunc(mmdupd_rep_date) = trunc(sysdate)


select sysdate, sysdate -0.04 d from dual









