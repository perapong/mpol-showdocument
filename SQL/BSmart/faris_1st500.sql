  
  
  
select --, mp.start_ship, mp.end_ship, ds.*
       '16/2012 - 16/2012' camp
     , pkgbw_misc.getxnsmcode(ds.dstloc_code) nsm
     , pkgbw_misc.getxdivcode(ds.dstloc_code) div
     , ds.dstloc_code dist
     , ds.dstloc_name distname
     , ds.dstmgr_name distmgr
     , (select count(*) --h.ohdttl_amount_befdisc, h.ohdnet_amount_befdisc, h.ohdttl_amount_aftdisc, ms.*
        from om_transaction_hdr h--, ms_representative ms
        where h.ohdou_code = mp.mplou_code
          and h.ohdyear = 12
          and (h.ohdtrans_group = 11 or h.ohdtrans_group = 12)
          and h.ohdtrans_no is not null
          
          and h.ohdloc_code = mp.loc_code
          and trunc(h.ohdtrans_date) between mp.start_ship and mp.end_ship
          and h.ohdord_flag_status = 'F'
          --and h.ohdttl_amount_befdisc >= 500
          --and h.ohdnet_amount_befdisc >= 500
          and h.ohdttl_amount_aftdisc >= 500
          ) faris1st
from db_sales_location ds, bev$_mailplan mp 
where ds.dstou_code = '000'
--and ds.dstparent_loc_code = '004'
--and ds.dstloc_code = '0018%'
  and ds.dstloc_code like '8%'
  and ds.dstloc_type = 'S'
  and ds.dstinactive_status = '0'
  and mp.mplou_code = ds.dstou_code
  and mp.mplyear = '2012'
  and mp.mplcampaign = '162012'
  and mp.loc_code = ds.dstloc_code
order by 2,3,ds.dstloc_code
  
  
  
  
  
  
  
  
  
  
  
  
  
  
/*
select * from bev$_mailplan mp
where mp.mplou_code = '000'
  and mp.mplyear = '2012'
  and mp.mplcampaign = '162012'
  and mp.loc_code = '0018'
  
  
  
    select h.ohdttl_amount_befdisc, h.ohdnet_amount_befdisc, h.ohdttl_amount_aftdisc, ms.*
    from om_transaction_hdr h, ms_representative ms
    where h.ohdou_code = '000'
      and h.ohdyear = 12
      and (h.ohdtrans_group = 11 or h.ohdtrans_group = 12)
      and h.ohdtrans_no is not null
      
      and h.ohdloc_code = '0018'
      and trunc(h.ohdtrans_date) between to_date('28/07/2012','dd/mm/rrrr') and to_date('10/08/2012','dd/mm/rrrr')
      and h.ohdord_flag_status = 'F'
--      and h.ohdttl_amount_befdisc >= 500
--      and h.ohdnet_amount_befdisc >= 500
      and h.ohdttl_amount_aftdisc >= 500
      
      and h.ohdou_code = ms.repou_code
      and h.ohdrep_code = ms.reprep_code
