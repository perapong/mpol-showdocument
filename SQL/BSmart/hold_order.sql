

select bho.bhosales_campaign
     , bih.bihnsm
     , bih.bihdiv
     , bih.bihloc_code
     , bih.bihloa
     , bih.bihrep_code
     , bih.bihrep_name
     , bih.bihorder_date
     , bho.bhoord_type_new
     , PKGSU_PARAM.getOrderType_Desc (bho.bhoord_type_new) odr_type_desc
     , bih.bihbill_seq
     , bih.bihorder_campaign
     , bih.bihttl_amount_aftdisc
     , bih.bihmailgroup
     , bih.bihar_balance
     , nvl((select sum(cahnet_amt) cahnet_amt from cc_tracer_hdr cah where cah.cahou_code = bho.bhoou_code and cah.cahrep_seq = bih.bihrep_seq and substr(cahtrac_camp,3,4)|| substr(cahtrac_camp,1,2) <= substr(bho.bhosales_campaign,3,4)|| substr(bho.bhosales_campaign,1,2)),0) tracer
     , (select sum(rtdreturn_price) 
        from om_return_hdr rth, om_return_dtl rtd
        where rth.rthou_code = bho.bhoou_code
          and rth.rthrep_code = bih.bihrep_seq
          and substr(rth.rthreturn_campaign,3,4)|| substr(rth.rthreturn_campaign,1,2) <= substr(bho.bhosales_campaign,3,4)|| substr(bho.bhosales_campaign,1,2)
          and rth.rthou_code = rtd.rtdou_code
          and rth.rthreturn_campaign = rtd.rtdreturn_campaign
          and rth.rthreturn_code = rtd.rtdreturn_code
          and rth.rthreturn_no = rtd.rtdreturn_no) returnmemo
from om_order_hold_log bho, om_order_hdr bih
where bho.bhoou_code = '000'
  and bih.bihou_code = bho.bhoou_code
  and bih.bihsales_campaign = bho.bhosales_campaign
  and bih.bihrep_seq = bho.bhorep_seq
  and bih.bihbill_seq = bho.bhobill_seq
  and bih.bihorder_status = '04'
  and bih.bihwork_status = '4'
--and (bho.bhosales_campaign = '222012' or bho.bhosales_campaign = '232012')
--and bih.bihloc_code = '0130'
  and bih.bihorder_date between to_date('04/01/2013','dd/mm/rrrr') and to_date('04/01/2013','dd/mm/rrrr')
--  and bih.bihou_code = rep.repou_code
--  and bih.bihrep_seq = rep.reprep_seq
order by bhosales_campaign, bihnsm, bihdiv, bihloc_code, bihrep_code


--select pkgbw_desc.getweekend(to_date('14/12/2012','dd/mm/rrrr'),to_date('14/12/2012','dd/mm/rrrr')) from dual

select * from db_sales_location where dstloc_code = '001'

--------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
select * from cc_tracer_hdr th 
where th.cahou_code = '000' 
--  and th.cahrep_seq =   
and substr(th.cahtrac_camp,3,4)|| substr(th.cahtrac_camp,1,2) <= '201215'
and th.cahrep_code = '0411086291'


/*

select *
--sum(rtdreturn_price) 
from om_return_hdr rth, om_return_dtl rtd
where rth.rthou_code = '000'
  and rth.rthrep_code = '0403114049'
  and substr(rth.rthreturn_campaign,3,4)|| substr(rth.rthreturn_campaign,1,2) <= '201215'
  and rth.rthou_code = rtd.rtdou_code
  and rth.rthreturn_campaign = rtd.rtdreturn_campaign
  and rth.rthreturn_code = rtd.rtdreturn_code
  and rth.rthreturn_no = rtd.rtdreturn_no

