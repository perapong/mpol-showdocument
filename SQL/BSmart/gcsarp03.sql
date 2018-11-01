--10.0.0.230 
--Source Code => D:\Dropbox\RP\BS\GCSARP03.rptdesign
--Copy File   => D:\Dropbox\tomcat\webapps\bsmart-birt\report

select t.campaign,t.region,t.province,t.amphur,t.member_class bmsmember_class,t.rep_code repcode,t.rep_name reprep_name,
  t.net_mistine bmsnet_mistine,t.netytd_mistine bmsytd_mistine,t.net_friday bmsnet_friday,t.netytd_friday bmsytd_friday,
  t.net_faris bmsnet_faris,t.netytd_faris bmsytd_faris
  --select replace(rep_code,'-','') dd, t.* 
from bwprod.bw_msl_gcsa t
where t.member_type='G' 
  and t.campaign=case when ?1 is null or ?2='null' then bwprod.pkgdb_desc.getprev_campaign('000',bwprod.pkgdb_desc.getCurrent_Campaign,1) 
    else ?3 end
order by t.region,t.province,t.amphur,bmsmember_class,repcode
group by rep_code
having count(*) > 1




select   t.campaign,t.region,t.province,t.amphur,t.member_class bmsmember_class,t.rep_code repcode,t.rep_name reprep_name,
  t.net_mistine bmsnet_mistine,t.netytd_mistine bmsytd_mistine,t.net_friday bmsnet_friday,t.netytd_friday bmsytd_friday,
  t.net_faris bmsnet_faris,t.netytd_faris bmsytd_faris
--select distinct rep_code
--create table perapong.gc_bw_msl_gcsa as select *   --delete 
from bwprod.bw_msl_gcsa t
where t.member_type='G' 
  and t.campaign='192014'
--and exists (select * from komkrij.gold_c250914 a where a.reprep_code = replace(t.rep_code,'-',''))
--and rep_code = '0193-11276-0'
--order by t.region,t.province,t.amphur,bmsmember_class,repcode
--group by rep_code
having count(*) > 1


--5/06/2014   18/06/2014 2:09:10


-- data from process bwprod.pkgbw_member_process
--                 & bwprod.pkgbw_campaignly_ship_process.Member_Sales_Summary_GC(Parm_OuCode,ShipDate,'GC1');
-- data from bw_msl_campaign_sales
select * from bw_msl_campaign_sales
where bmsou_code = '000'
  and bmsyear = 14
  and bmscampaign = '122014'

--              Insert into BW_MSL_GCSA
                select n.lastcampaign campaign,
                    g.padentry_ldesc region,d.prvprovince_lname province,e.ampamphur_lname amphur,
                    case when a.bmsmember_class<>150 then 'G' else 'D' end bmsmember_type,
                    case when a.bmsmember_class<>150 then 'G'||lpad(a.bmsmember_class,1,'0') else null end bmsmember_class,
                    b.reploc_code||'-'||lpad(b.reprep_running,5,'00000')||'-'||lpad(b.repcheck_digi,1,'0') repcode,b.reprep_name,

                    sum(distinct case when a.bmscampaign=n.lastcampaign
                        then a.bmsnet_mistine else 0 end) bmsnet_mistine,
                    sum(distinct case when a.bmscampaign<=n.lastcampaign
                        then a.bmsnet_mistine else 0 end) bmsytd_mistine,

                    sum(distinct case when a.bmscampaign=n.lastcampaign
                        then a.bmsnet_friday else 0 end) bmsnet_friday,
                    sum(distinct case when a.bmscampaign<n.lastcampaign
                        then a.bmsnet_friday else 0 end) bmsytd_friday,

                    sum(distinct case when a.bmscampaign=n.lastcampaign
                        then a.bmsnet_faris else 0 end) bmsnet_faris,
                    sum(distinct case when a.bmscampaign<=n.lastcampaign
                        then a.bmsnet_faris else 0 end) bmsytd_faris,
                    'GCSARP',
                    b.reprep_seq

                from bw_msl_campaign_sales a
                inner join ms_representative b on
                    a.bmsou_code=b.repou_code and a.bmsrep_seq=b.reprep_seq
                inner join ms_rep_address c on
                    a.bmsou_code=c.reaou_code and a.bmsrep_seq=c.rearep_seq and c.reatype='1' and c.reano='1'
                inner join db_province d on
                    a.bmsou_code=d.prvou_code and c.reaprovince_code=d.prvprovince_code
                inner join db_amphur e on
                    a.bmsou_code=e.ampou_code and c.reaamphur_code=e.ampamphur_code
                inner join db_province_region f on
                    c.reaprovince_code=f.prvprovince_code
                inner join su_param_dtl g on
                    f.dstregion_code=g.padentry_code and g.padparam_id=302
                inner join (select case when '122014' is null or '122014'                                                               --edit
                                ='null' then pkgdb_desc.getprev_campaign('000',pkgdb_desc.getCurrent_Campaign,1) else '122014'          --eidt 
                            end lastcampaign from dual) n on
                    a.bmscampaign between '0120'||a.bmsyear and n.lastcampaign

                where a.bmsou_code='000' --Parm_OuCode 
                    and a.bmsloc_code='0167' --Trx.dstloc_code                                                                          --edit
                    and (nvl(a.bmsmember_class,8) between 1 and 8 or a.bmsmember_class=150)
                    and not exists
                    (select 1 from bw_msl_gcsa x
                     where x.campaign=n.lastcampaign and x.region=g.padentry_ldesc and x.province=d.prvprovince_lname
                        and x.amphur=e.ampamphur_lname and x.member_type=case when a.bmsmember_class<>150 then 'G' else 'D' end
                        and x.member_class=case when a.bmsmember_class<>150 then 'G'||lpad(a.bmsmember_class,1,'0') else null end
                        and x.rep_code=b.reploc_code||'-'||lpad(b.reprep_running,5,'00000')||'-'||lpad(b.repcheck_digi,1,'0')
                        and x.progid='GCSARP')
                group by g.padentry_ldesc,d.prvprovince_lname,e.ampamphur_lname,case when a.bmsmember_class<>150 then 'G'
                    else 'D' end,case when a.bmsmember_class<>150 then 'G'||lpad(a.bmsmember_class,1,'0') else null end,
                    b.reploc_code||'-'||lpad(b.reprep_running,5,'00000')||'-'||lpad(b.repcheck_digi,1,'0'),b.reprep_name,b.reprep_seq;








/***********************************************************************************/
                แก้ไขข้อมูลมีหลาย Row   edit dupplicate Data mor than one row
/***********************************************************************************/
/*
insert into perapong.zp_tmp_gcsa1 
select count(*) cnt, rep_code, campaign
from bwprod.bw_msl_gcsa t
where t.member_type = 'G' 
  and t.campaign = '112014'
--and rep_code = '0788-04426-5'
group by rep_code, campaign
having count(*) > 1
*/


select a.*, nvl((select sum(netytd_mistine) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
          , nvl((select sum(netytd_friday) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
          , nvl((select sum(netytd_faris) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
from bwprod.bw_msl_gcsa a
where a.member_type = 'G' 
  and a.campaign = '102014'
  and rep_code in (select rep_code from perapong.zp_tmp_gcsa1 where campaign = '102014')
  --and rep_code = '0639-10317-0'
  --and member_class <> 'G8'
  --and net_mistine = 0


update bwprod.bw_msl_gcsa a
set netytd_mistine = nvl((select sum(netytd_mistine) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
          , netytd_friday = nvl((select sum(netytd_friday) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
          , netytd_faris = nvl((select sum(netytd_faris) from bwprod.bw_msl_gcsa t
                                where t.member_type = a.member_type
                                  and t.campaign = a.campaign
                                  and t.rep_code = a.rep_code),0)
where a.member_type = 'G' 
  and a.campaign = '112014'
  and rep_code in (select rep_code from perapong.zp_tmp_gcsa1 where campaign = '112014')
  --and rep_code = '0639-10317-0'

insert into perapong.zp_tmp_gcsa2
select * from bwprod.bw_msl_gcsa a
--delete from bwprod.bw_msl_gcsa a
where a.member_type = 'G' 
  and a.campaign = '112014'
  and rep_code in (select rep_code from perapong.zp_tmp_gcsa1 where campaign = '112014')
  and member_class <> nvl((select 'G'||mmdmember_class from db_member_dtl where mmdou_code = '000' and mmdclub_code = 'GC1' and mmdrep_code = replace(a.rep_code,'-','')),'G8')
  --and rep_code = '0788-04426-5'


select 'G'||mmdmember_class from db_member_dtl where mmdou_code = '000' and mmdclub_code = 'GC1' and mmdrep_code = replace('0788-04426-5','-','')


/***********************************************************************************/
                End
/***********************************************************************************/




/***********************************************************************************/
                แก้ไขรายการที่ไม่มีข้อมูล อำเภอ จังหวัด ภาค
/***********************************************************************************/
-- edit 2
declare 

    cursor rec is
        select *
        from ms_rep_address 
        where reaou_code = '000' 
          and rearep_seq in (select rep_seq
                from bwprod.bw_msl_gcsa a
                where a.member_type = 'G' 
                and a.campaign = '092014'                   --edit
                and amphur is null
                )
          and reatype = 1
        ;
    vprov varchar(200);
    vregion varchar2(200);
    vamp varchar(200);
begin
    For Trec In Rec Loop
        begin
            select prvprovince_lname
            into vprov
            from db_province where prvou_code = '000'
            and prvprovince_code = trec.reaprovince_code;
            exception when no_data_found then vprov := null; 
        end;
        begin
            select ampamphur_lname 
            into vamp
            from db_amphur where ampou_code = '000'
            and ampamphur_code = trec.reaamphur_code;
            exception when no_data_found then 
                begin
                    select tbnamphur_code into vamp from db_tumbon where tbntumbon_code = trec.reatumbon_code;
                    exception when no_data_found then vamp := null; 
                end;
        end;
        begin
            select padentry_ldesc into vregion
            from su_param_dtl g , db_province_region f 
                    where g.padparam_id = 302
                      and f.dstregion_code = g.padentry_code 
                      and f.prvprovince_code = trec.reaprovince_code;
            exception when no_data_found then vregion := null; 
        end; 

        begin
            update bwprod.bw_msl_gcsa a
            set region = vregion
              , province = vprov
              , amphur = vamp
                where a.member_type = 'G' 
                and a.campaign = '092014'                       --edit
                and a.rep_seq = trec.rearep_seq
                and a.amphur is null
                ;
        end;
    end loop;
end;

/***********************************************************************************/
                End
/***********************************************************************************/


/***********************************************************************************/
                แก้ไขข้อมูลเก่าที่ Sum ยอดมาผิด
/***********************************************************************************/

declare
    cursor rec is
        select * 
        from bw_msl_gcsa a , bw_msl_campaign_sales b
        where campaign = '122014'
          and nvl(net_mistine,0) = 0
          and nvl(net_friday,0) = 0
          and nvl(net_faris,0) = 0
          and rep_seq = bmsrep_seq 
          and campaign = bmscampaign 
          and nvl(bmsmember_class,8) <> 150
        ;
begin
    For Trec In rec Loop
        update bw_msl_gcsa
           set net_mistine = nvl(Trec.bmsnet_mistine,0)
           --, netytd_mistine = nvl(Trec.bmsnet_mistine,0)
             , net_friday = nvl(Trec.bmsnet_friday,0)
           --, netytd_friday = nvl(Trec.bmsnet_friday,0)
             , net_faris = nvl(Trec.bmsnet_faris,0)
           --, netytd_faris = nvl(Trec.bmsnet_faris,0)
        where campaign = Trec.campaign
          and nvl(net_mistine,0) = 0
          and nvl(net_friday,0) = 0
          and nvl(net_faris,0) = 0
          and rep_seq = Trec.rep_seq 
        ;
    End Loop;
end;


declare
    cursor rec is
        select a.* 
        from bw_msl_gcsa a
        where campaign = '112014'
        --and rep_code = '0157-14738-0'
          and nvl(netytd_mistine,0) = 0
          and nvl(netytd_friday,0) = 0
          and nvl(netytd_faris,0) = 0
        ;
    ccampaign       VARCHAR2(6);
    vrep_seq        VARCHAR2(10);
    vrep_code       NUMBER;
    vytd_mistine    NUMBER;
    vytd_friday     NUMBER;
    vytd_faris      NUMBER;
begin
    For Trec In rec Loop
        ccampaign := pkgbw_it.cy2yc(Trec.campaign);
        begin
            select      sum(distinct case when pkgbw_it.cy2yc(a.bmscampaign)<=ccampaign
                            then a.bmsnet_mistine else 0 end) bmsytd_mistine,
                        sum(distinct case when pkgbw_it.cy2yc(a.bmscampaign)<=ccampaign
                            then a.bmsnet_friday else 0 end) bmsytd_friday,
                        sum(distinct case when pkgbw_it.cy2yc(a.bmscampaign)<=ccampaign
                            then a.bmsnet_faris else 0 end) bmsytd_faris,
                        bmsrep_seq, bmsrep_code
            into vytd_mistine, vytd_friday, vytd_faris, vrep_seq, vrep_code
            from bw_msl_campaign_sales a
            where bmscampaign <= ccampaign
              and bmsrep_code = replace(Trec.rep_code,'-','')
            --where pkgbw_it.cy2yc(bmscampaign) <= '201408' and bmsrep_code = '0776038273'
            group by bmsrep_seq, bmsrep_code;
            exception when no_data_found then
                begin
                    vytd_mistine := 0;
                    vytd_friday := 0;
                    vytd_faris := 0;
                end;
        end;    
        
        begin
            update bw_msl_gcsa
               set netytd_mistine = nvl(vytd_mistine,0)
                 , netytd_friday = nvl(vytd_friday,0)
                 , netytd_faris = nvl(vytd_faris,0)
            where campaign = Trec.campaign
              and rep_code = Trec.rep_code
              and nvl(netytd_mistine,0) = 0
              and nvl(netytd_friday,0) = 0
              and nvl(netytd_faris,0) = 0
            ;
        end;
    End Loop;
end;

/***********************************************************************************/
                End
/***********************************************************************************/



