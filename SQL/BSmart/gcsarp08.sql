select  a.bmccampaign,
        to_char(a.bmcshipdate,'dd/mm/yyyy') bmcshipdate,
        (select sum(aa.bmcnumber_active) 
            from bwprod.bw_msl_campaign_count aa
            where aa.bmccampaign='202013') bfrep, 
        sum(a.bmcnumber_regist) bmcnumber_regist,
        sum(a.bmcnumber_remove) bmcnumber_remove,
        (select bb.cpgcampaign_code
            from db_campaign bb
            where bb.cpgou_code = '000' and trunc(a.bmcshipdate) between trunc(bb.cpgeff_sdate) and trunc(bb.cpgeff_edate)) cur_camp
      from bwprod.bw_msl_campaign_count_daily a
      where substr(a.bmccampaign,3,4)||substr(a.bmccampaign,1,2) > '201320' 
      group by a.bmccampaign,a.bmcshipdate
      order by substr(a.bmccampaign,3,4)||substr(a.bmccampaign,1,2),a.bmcshipdate
      
      
      
select * 
from bwprod.bw_msl_campaign_count_daily
where bmcou_code = '000'
  and bmccampaign = '122014'
  and bmcshipdate = to_date('12/06/2014','dd/mm/rrrr')
  and bmcloc_code = '8376'


select * from db_member_dtl_ex 
where mmdou_code = '000'
  and mmdclub_code = 'GC1'
--and mmdrep_code = '8376006819'
  and mmdex_date = to_date('12/06/2014','dd/mm/rrrr')
  and mmdmember_date < to_date('04/06/2014','dd/mm/rrrr')
  and mmdmember_campaign = '122014'


select *
from bwprod.bw_msl_campaign_count aa
where aa.bmccampaign='122014'


select aa.*,(aa.bmcnumber_active) 
            from bwprod.bw_msl_campaign_count aa
            where aa.bmccampaign='202013'
            
            
select * from db_member_dtl
where mmdou_code = '000'
  and mmdclub_code = 'GC1'
  and mmdrep_code = '8376006819'
  and mmdmember_date < to_date('04/06/2014','dd/mm/rrrr')
  and mmdmember_campaign = '122014'
  
  
select * from ms_rep_goldclub
where repou_code = '000'
  and rep_code = '8376006819'


select * from db_sales_location where dstou_code = '000' and dstloc_code = '8376'
